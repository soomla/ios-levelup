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
#import "Mission.h"
#import "LevelUp.h"
#import "LevelUpEventHandling.h"
#import "KeyValueStorage.h"
#import "SoomlaUtils.h"

@implementation MissionStorage

static NSString* TAG = @"SOOMLA MissionStorage";

+ (void)setCompleted:(BOOL)completed forMission:(Mission *)mission {
    [self setCompleted:completed forMission:mission andNotify:YES];
}

+ (void)setCompleted:(BOOL)completed forMission:(Mission *)mission andNotify:(BOOL)notify {
    NSString* msg = [NSString stringWithFormat:@"setCompleted %d %@", completed, mission.missionId];
    LogDebug(TAG, msg);
    NSString* key = [self keyMissionCompletedWithMissionId:mission.missionId];
    
    if (completed) {
        [KeyValueStorage setValue:@"yes" forKey:key];
        
        if (notify) {
            [LevelUpEventHandling postMissionCompleted:mission];
        }
    } else {
        [KeyValueStorage deleteValueForKey:key];
        if (notify) {
            [LevelUpEventHandling postMissionCompletionRevoked:mission];
        }
    }
}

+ (BOOL)isMissionCompleted:(Mission *)mission {
    NSString* key = [self keyMissionCompletedWithMissionId:mission.missionId];
    NSString* val = [KeyValueStorage getValueForKey:key];
    NSString* msg = [NSString stringWithFormat:@"key:%@ val:%@", key, val];
    LogDebug(TAG, msg)
    return (val && [val length] > 0);
}


// Private
+ (NSString *)keyMissionsWithMissionId:(NSString *)missionId andPostfix:(NSString *)postfix {
    return [NSString stringWithFormat: @"%@missions.%@.%@", LU_DB_KEY_PREFIX, missionId, postfix];
}

+ (NSString *)keyMissionCompletedWithMissionId:(NSString *)missionId {
    return [self keyMissionsWithMissionId:missionId andPostfix:@"completed"];
}


@end
