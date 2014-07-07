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

#import "Mission.h"
#import "MissionStorage.h"
#import "Reward.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"
#import "DictionaryFactory.h"
#import "SoomlaUtils.h"

@implementation Mission

@synthesize missionId, name, rewards;

static NSString* TAG = @"SOOMLA Mission";
static DictionaryFactory* dictionaryFactory;


- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName {
    self = [super init];
    if ([self class] == [Mission class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }

    if (self) {
        self.missionId = oMissionId;
        self.name = oName;
    }
    return self;
}

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andRewards:(NSArray *)oRewards {
    self = [super init];
    if ([self class] == [Mission class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.missionId = oMissionId;
        self.name = oName;
        self.rewards = oRewards;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if ([self class] == [Mission class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        
        self.missionId = dict[LU_MISSION_MISSIONID];
        self.name = dict[LU_NAME];
        
        NSMutableArray* tmpRewards = [NSMutableArray array];
        NSArray* rewardsArr = dict[LU_REWARDS];
        
        // Iterate over all rewards in the JSON array and for each one create
        // an instance according to the reward type
        for (NSDictionary* rewardDict in rewardsArr) {
            
            Reward* reward = [Reward fromDictionary:rewardDict];
            if (reward) {
                [tmpRewards addObject:reward];
            }
        }
        
        self.rewards = tmpRewards;
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 NSStringFromClass([self class]), SOOM_CLASSNAME,
                                 self.missionId, LU_MISSION_MISSIONID,
                                 self.name, LU_NAME,
                                 nil];
    
    NSMutableArray* rewardsArr = [NSMutableArray array];
    for (Reward* reward in self.rewards) {
        [rewardsArr addObject:[reward toDictionary]];
    }
    [dict setObject:rewardsArr forKey:LU_REWARDS];
    
    return dict;
}

- (BOOL)isCompleted {
    return [MissionStorage isMissionCompleted:self];
}

- (void)setCompleted:(BOOL)completed {
    [MissionStorage setCompleted:completed forMission:self];
    if (completed) {
        
        // Stop observing notifications.  Not interesting until revoked.
        [self stopObservingNotifications];
        
        [self giveRewards];
    } else {
        [self takeRewards];

        // listen again for chance to be completed
        [self observeNotifications];
    }
}

- (BOOL)isEqualToMission:(Mission *)mission {
    if (!mission) {
        return NO;
    }
    
    return [self.missionId isEqualToString:mission.missionId];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[Mission class]]) {
        return NO;
    }
    
    return [self isEqualToMission:(Mission *)object];
}

- (void)observeNotifications {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Error, attempting to invoke abstract method directly." userInfo:nil];
}

- (void)stopObservingNotifications {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Error, attempting to invoke abstract method directly." userInfo:nil];
}


// Static methods

+ (Mission *)fromDictionary:(NSDictionary *)dict {
    return (Mission *)[dictionaryFactory createObjectWithDictionary:dict];
}

+ (void)initialize {
    if (self == [Mission self]) {
        dictionaryFactory = [[DictionaryFactory alloc] init];
    }
}

//
// Private methods
//

- (NSUInteger)hash {
    return [self.missionId hash];
}

- (void)giveRewards {
    for (Reward* reward in self.rewards) {
        [reward give];
    }
}

- (void)takeRewards {
    for (Reward* reward in self.rewards) {
        [reward take];
    }
}


@end
