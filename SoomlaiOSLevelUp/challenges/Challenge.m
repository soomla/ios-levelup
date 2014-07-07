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

#import "Challenge.h"
#import "BalanceMission.h"
#import "MissionStorage.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"
#import "RecordMission.h"
#import "LevelUpEventHandling.h"
#import "SoomlaUtils.h"

@implementation Challenge

@synthesize missions;

static NSString* TAG = @"SOOMLA Challenge";

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andMissions:(NSArray *)oMissions {
    if (self = [super initWithMissionId:oMissionId andName:oName]) {
        self.missions = oMissions;
    }
    
    [self observeNotifications];
    return self;
}

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andMissions:(NSArray *)oMissions andRewards:(NSArray *)oRewards {
    if (self = [super initWithMissionId:oMissionId andName:oName andRewards:oRewards]) {
        self.missions = oMissions;
    }
    
    [self observeNotifications];
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        
        NSMutableArray* tmpMissions = [NSMutableArray array];
        NSArray* missionDicts = dict[LU_MISSIONS];
        
        // Iterate over all missions in the JSON array and for each one create
        // an instance according to the mission type
        for (NSDictionary* missionDict in missionDicts) {
            
            Mission* mission = [Mission fromDictionary:missionDict];
            if (mission) {
                [tmpMissions addObject:mission];
            }
        }
        
        self.missions = tmpMissions;
    }
    
    [self observeNotifications];
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableArray* missionsArr = [NSMutableArray array];
    for (Mission* mission in self.missions) {
        [missionsArr addObject:[mission toDictionary]];
    }
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:missionsArr forKey:LU_MISSIONS];
    
    return toReturn;
}


- (BOOL)isCompleted {
    
    // could happen in construction
    // need to return false in order to register for child events
    if (!self.missions) {
        return NO;
    }

    for (Mission* mission in self.missions) {
        if (![mission isCompleted]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)missionCompleted:(NSNotification *)notification {
    LogDebug(TAG, @"missionCompleted notification");
    Mission* mission = notification.userInfo[DICT_ELEMENT_MISSION];
    
    if ([self.missions containsObject:mission]) {
        BOOL completed = YES;
        for (Mission* m in self.missions) {
            if (![m isCompleted]) {
                completed = NO;
                break;
            }
        }
        
        if (completed) {
            [self setCompleted:YES];
        }
    }
}

- (void)missionCompletionRevoked:(NSNotification *)notification {
    LogDebug(TAG, @"missionCompletionRevoked notification");
    Mission* mission = notification.userInfo[DICT_ELEMENT_MISSION];
    
    
    if ([self.missions containsObject:mission]) {

        // if the challenge was completed before, but now one of its child missions
        // was uncompleted - the challenge is revoked as well
        if ([MissionStorage isMissionCompleted:self]) {
            [self setCompleted:NO];
        }
    }
}

/**
 Overrides parent method to customize the observed notifications for `Challenge`
 */
- (void)observeNotifications {
    LogDebug(TAG, @"observeNotifications called");
    if (![self isCompleted]) {
        LogDebug(TAG, @"observing!");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(missionCompleted:) name:EVENT_MISSION_COMPLETED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(missionCompletionRevoked:) name:EVENT_MISSION_COMPLETION_REVOKED object:nil];
    }
}

/**
 Ignore `stopObservingNotifications` since challenge can be revoked by child missions revoked
 */
- (void)stopObservingNotifications {
    LogDebug(TAG, @"ignore stopObservingNotifications since challenge can be revoked by child missions revoked");
}


@end
