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

@class Challenge;
@class Gate;
@class GatesList;
@class Score;
@class BadgeReward;

@interface World : NSObject {
    
    @private
    NSString* worldId;
    GatesList* gates;
    NSMutableDictionary* innerWorlds;
    NSMutableDictionary* scores;
    NSMutableArray* challenges;
}

@property (strong, nonatomic, readonly) NSString* worldId;
@property (strong, nonatomic, readonly) GatesList* gates;
@property (strong, nonatomic, readonly) NSMutableDictionary* innerWorlds;
@property (strong, nonatomic, readonly) NSMutableDictionary* scores;
@property (strong, nonatomic, readonly) NSMutableArray* challenges;


- (id)initWithWorldId:(NSString *)oWorldId;

- (id)initWithWorldId:(NSString *)oWorldId andGates:(GatesList *)oGates
     andInnerWorlds:(NSMutableDictionary *)oInnerWorlds andScores:(NSMutableDictionary *)oScores andChallenges:(NSArray *)oChallenges;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary*)toDictionary;

- (void)addChallenge:(Challenge *)challenge;

- (NSDictionary *)getRecordScores;

- (NSDictionary *)getLatestScores;

- (void)setValue:(double)scoreVal toScoreWithScoreId:(NSString *)scoreId;

- (void)addScore:(Score *)score;

- (void)addGate:(Gate *)gate;

- (void)addInnerWorld:(World *)world;

- (BOOL)isCompleted;

- (void)setCompleted:(BOOL)completed;

- (void)setCompleted:(BOOL)completed recursively:(BOOL)recursive;

- (BOOL)canStart;

- (void)assignBadge:(BadgeReward*)badgeReward;

- (NSString*)getAssignedBadgeId;

// Static methods

+ (World *)fromDictionary:(NSDictionary *)dict;


@end
