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

@class Score;
@class Gate;
@class Reward;
@class Mission;
@class World;
@class Level;

// Events
#define EVENT_SCORE_RECORD_CHANGED           @"levelup_score_record_changed"
#define EVENT_GATE_OPENED                    @"levelup_gate_opened"
#define EVENT_REWARD_GIVEN                   @"levelup_reward_given"
#define EVENT_REWARD_TAKEN                   @"levelup_reward_taken"
#define EVENT_MISSION_COMPLETED              @"levelup_mission_completed"
#define EVENT_MISSION_COMPLETION_REVOKED     @"levelup_mission_completeion_revoked"
#define EVENT_WORLD_COMPLETED                @"levelup_world_completed"
#define EVENT_LEVEL_STARTED                  @"levelup_level_started"
#define EVENT_LEVEL_ENDED                    @"levelup_level_ended"

// UserInfo Elements
#define DICT_ELEMENT_SCORE                   @"score"
#define DICT_ELEMENT_GATE                    @"gate"
#define DICT_ELEMENT_REWARD                  @"reward"
#define DICT_ELEMENT_WORLD                   @"world"
#define DICT_ELEMENT_MISSION                 @"mission"
#define DICT_ELEMENT_LEVEL                   @"level"
#define DICT_ELEMENT_IS_CHALLENGE            @"isChallenge"
#define DICT_ELEMENT_IS_BADGE                @"isBadge"


@interface LevelUpEventHandling : NSObject


+ (void)observeAllEventsWithObserver:(id)observer withSelector:(SEL)selector;

+ (void)postScoreRecordChanged:(Score *)score;

+ (void)postGateOpened:(Gate *)gate;

+ (void)postRewardGiven:(Reward *)reward;

+ (void)postRewardTaken:(Reward *)reward;

+ (void)postMissionCompleted:(Mission *)mission;

+ (void)postMissionCompletionRevoked:(Mission *)mission;

+ (void)postWorldCompleted:(World *)world;

+ (void)postLevelStarted:(Level *)level;

+ (void)postLevelEnded:(Level *)level;


@end
