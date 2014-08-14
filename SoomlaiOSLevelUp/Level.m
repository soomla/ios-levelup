/*
 Copyright (C) 2012-2014 Soomla Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "Level.h"
#import "LevelStorage.h"
#import "Score.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"
#import "VirtualItemScore.h"
#import "VirtualItemNotFoundException.h"
#import "StoreInventory.h"
#import "SoomlaUtils.h"


@implementation Level

@synthesize state;

static NSString* TAG = @"SOOMLA Level";


- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    
    return toReturn;
}

    
- (int)getTimesStarted {
    return [LevelStorage getTimesStartedForLevel:self];
}

- (int)getTimesPlayed {
    return [LevelStorage getTimesPlayedForLevel:self];
}

- (long long)getSlowestDurationMillis {
    return [LevelStorage getSlowestDurationMillisForLevel:self];
}

- (long long)getFastestDurationMillis {
    return [LevelStorage getFastestDurationMillisforLevel:self];
}

- (long long)getPlayDurationMillis {
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    long long duration = elapsed;
    if (startTime != 0) {
        duration += now - startTime;
    }
    return duration;
}

- (BOOL)start {
    
    
    LogDebug(TAG, ([NSString stringWithFormat:@"Starting level with worldId: %@", self.worldId]));
    
    if (![self canStart]) {
        return NO;
    }
    
    startTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    elapsed = 0;
    state = RUNNING;
    [LevelStorage incTimesStartedForLevel:self];
    
    return YES;
}

- (void)pause {
    if (state != RUNNING) {
        return;
    }
    
    long long now = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    elapsed = now - startTime;
    startTime = 0;
    state = PAUSED;
}

- (void)resume {
    if (state != PAUSED) {
        return;
    }

    startTime = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    state = RUNNING;
}

- (void)end:(BOOL)completed {
    
    // check end() called without matching start()
    if (startTime == 0) {
        LogDebug(TAG, @"end() called without prior start()! ignoring.");
        return;
    }
    
    state = ENDED;
    
    if (completed) {
        long long duration = [self getPlayDurationMillis];
        
        // Calculate the slowest \ fastest durations of level play
        
        if (duration > [self getSlowestDurationMillis]) {
            [LevelStorage setSlowestDurationMillis:duration forLevel:self];
        }
        
        if (duration < [self getFastestDurationMillis]) {
            [LevelStorage setFastestDurationMillis:duration forLevel:self];
        }
        
        for (NSString* key in self.scores) {
            [(Score*)self.scores[key] saveAndReset]; // resetting scores
        }
        
        // Count number of times this level was played
        [LevelStorage incTimesPlayedForLevel:self];
        
        // reset timers
        startTime = 0;
        elapsed = 0;
        currentTime = 0;
        
        [self setCompleted:YES];
    }
}

- (void)setCompleted:(BOOL)completed {
    state = COMPLETED;
    [super setCompleted:completed];
}


@end
