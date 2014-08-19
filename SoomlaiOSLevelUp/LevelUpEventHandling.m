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
#import "Challenge.h"

@implementation LevelUpEventHandling


+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_SCORE_RECORD_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_SCORE_RECORD_REACHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_GATE_OPENED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MISSION_COMPLETED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_MISSION_COMPLETION_REVOKED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_WORLD_COMPLETED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_LEVEL_STARTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_LEVEL_ENDED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:EVENT_WORLD_REWARD_ASSIGNED object:nil];
}

+ (void)postScoreRecordChanged:(Score *)score {
    NSDictionary *userInfo = @{DICT_ELEMENT_SCORE: score};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_SCORE_RECORD_CHANGED object:self userInfo:userInfo];
}

+ (void)postScoreRecordReached:(Score *)score {
    NSDictionary *userInfo = @{DICT_ELEMENT_SCORE: score};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_SCORE_RECORD_REACHED object:self userInfo:userInfo];
}

+ (void)postGateOpened:(Gate *)gate {
    NSDictionary *userInfo = @{DICT_ELEMENT_GATE: gate};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GATE_OPENED object:self userInfo:userInfo];
}

+ (void)postMissionCompleted:(Mission *)mission {
    NSDictionary *userInfo = @{
                               DICT_ELEMENT_MISSION: mission,
                               DICT_ELEMENT_IS_CHALLENGE: @([mission isKindOfClass:[Challenge class]])
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MISSION_COMPLETED object:self userInfo:userInfo];
}

+ (void)postMissionCompletionRevoked:(Mission *)mission {
    NSDictionary *userInfo = @{
                               DICT_ELEMENT_MISSION: mission,
                               DICT_ELEMENT_IS_CHALLENGE: @([mission isKindOfClass:[Challenge class]])
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MISSION_COMPLETION_REVOKED object:self userInfo:userInfo];
}

+ (void)postWorldCompleted:(Mission *)world {
    NSDictionary *userInfo = @{DICT_ELEMENT_WORLD: world};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_WORLD_COMPLETED object:self userInfo:userInfo];
}

+ (void)postLevelStarted:(Level *)level {
    NSDictionary *userInfo = @{DICT_ELEMENT_LEVEL: level};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_LEVEL_STARTED object:self userInfo:userInfo];
}

+ (void)postWorldRewardAssigned:(World *)world {
    NSDictionary *userInfo = @{DICT_ELEMENT_WORLD: world};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_WORLD_REWARD_ASSIGNED object:self userInfo:userInfo];
}

+ (void)postLevelEnded:(Level *)level {
    NSDictionary *userInfo = @{DICT_ELEMENT_LEVEL: level};
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_LEVEL_ENDED object:self userInfo:userInfo];
}

@end
