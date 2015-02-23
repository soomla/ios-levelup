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

#import "LevelUpEventHandling.h"

@implementation LevelUpEventHandling


+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_SCORE_RECORD_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_SCORE_LATEST_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_SCORE_RECORD_REACHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GATE_OPENED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GATE_CLOSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MISSION_COMPLETED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MISSION_COMPLETION_REVOKED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_WORLD_COMPLETED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_LEVEL_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_LEVEL_ENDED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_WORLD_REWARD_ASSIGNED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_LAST_COMPLETED_INNER_WORLD_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_LEVEL_UP_INITIALIZED object:nil];
}

+ (void)postScoreRecordChanged:(NSString *)scoreId {
    NSDictionary *userInfo = @{DICT_ELEMENT_SCORE: scoreId};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_SCORE_RECORD_CHANGED object:self userInfo:userInfo];
}

+ (void)postScoreLatestChanged:(NSString *)scoreId {
    NSDictionary *userInfo = @{DICT_ELEMENT_SCORE: scoreId};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_SCORE_LATEST_CHANGED object:self userInfo:userInfo];
}

+ (void)postScoreRecordReached:(NSString *)scoreId {
    NSDictionary *userInfo = @{DICT_ELEMENT_SCORE: scoreId};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_SCORE_RECORD_REACHED object:self userInfo:userInfo];
}

+ (void)postGateOpened:(NSString *)gateId {
    NSDictionary *userInfo = @{DICT_ELEMENT_GATE: gateId};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GATE_OPENED object:self userInfo:userInfo];
}

+ (void)postGateClosed:(NSString *)gateId {
    NSDictionary *userInfo = @{DICT_ELEMENT_GATE: gateId};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GATE_CLOSED object:self userInfo:userInfo];
}

+ (void)postMissionCompleted:(NSString *)missionId {
    NSDictionary *userInfo = @{
                               DICT_ELEMENT_MISSION: missionId
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MISSION_COMPLETED object:self userInfo:userInfo];
}

+ (void)postMissionCompletionRevoked:(NSString *)missionId {
    NSDictionary *userInfo = @{
                               DICT_ELEMENT_MISSION: missionId
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MISSION_COMPLETION_REVOKED object:self userInfo:userInfo];
}

+ (void)postWorldCompleted:(NSString *)worldId {
    NSDictionary *userInfo = @{DICT_ELEMENT_WORLD: worldId};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_WORLD_COMPLETED object:self userInfo:userInfo];
}

+ (void)postLevelStarted:(NSString *)levelId {
    NSDictionary *userInfo = @{DICT_ELEMENT_LEVEL: levelId};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_LEVEL_STARTED object:self userInfo:userInfo];
}

+ (void)postWorldRewardAssigned:(NSString *)worldId {
    NSDictionary *userInfo = @{DICT_ELEMENT_WORLD: worldId};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_WORLD_REWARD_ASSIGNED object:self userInfo:userInfo];
}

+ (void)postLastCompletedInnerWorldChanged:(NSString *)worldId andInnerWorld:(NSString *)innerWorldId {
    NSDictionary *userInfo = @{
                               DICT_ELEMENT_WORLD: worldId,
                               DICT_ELEMENT_INNER_WORLD: innerWorldId
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_LAST_COMPLETED_INNER_WORLD_CHANGED object:self userInfo:userInfo];
}

+ (void)postLevelEnded:(NSString *)levelId {
    NSDictionary *userInfo = @{DICT_ELEMENT_LEVEL: levelId};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_LEVEL_ENDED object:self userInfo:userInfo];
}

+ (void)postLevelUpInitialized {
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_LEVEL_UP_INITIALIZED object:self];
}

@end
