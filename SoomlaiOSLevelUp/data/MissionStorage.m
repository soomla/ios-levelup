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

#import "MissionStorage.h"
#import "LevelUp.h"
#import "LevelUpEventHandling.h"
#import "KeyValueStorage.h"
#import "SoomlaUtils.h"

@implementation MissionStorage

static NSString* TAG = @"SOOMLA MissionStorage";

+ (void)setCompleted:(BOOL)completed forMission:(NSString *)missionId {
    [self setCompleted:completed forMission:missionId andNotify:YES];
}

+ (void)setCompleted:(BOOL)completed forMission:(NSString *)missionId andNotify:(BOOL)notify {
    
    int total = [self getTimesCompleted:missionId] + (completed ? 1 : -1);
    if (total < 0) {
        total = 0;
    }
    NSString* key = [self keyMissionTimesCompletedWithMissionId:missionId];
    [KeyValueStorage setValue:[@(total) stringValue] forKey:key];
    
    if (notify) {
        if (completed) {
            [LevelUpEventHandling postMissionCompleted:missionId];
        } else {
            [LevelUpEventHandling postMissionCompletionRevoked:missionId];
        }
    }
}

+ (BOOL)isMissionCompleted:(NSString *)missionId {
    return [self getTimesCompleted:missionId] > 0;
}

+ (int)getTimesCompleted:(NSString *)missionId {
    NSString* key = [self keyMissionTimesCompletedWithMissionId:missionId];
    NSString* val = [KeyValueStorage getValueForKey:key];
    NSString* msg = [NSString stringWithFormat:@"key:%@ val:%@", key, val];
    LogDebug(TAG, msg)
    
    return (![val length]) ? 0 : [val intValue];
}


// Private
+ (NSString *)keyMissionsWithMissionId:(NSString *)missionId andPostfix:(NSString *)postfix {
    return [NSString stringWithFormat: @"%@missions.%@.%@", LU_DB_KEY_PREFIX, missionId, postfix];
}

+ (NSString *)keyMissionTimesCompletedWithMissionId:(NSString *)missionId {
    return [self keyMissionsWithMissionId:missionId andPostfix:@"timesCompleted"];
}


@end
