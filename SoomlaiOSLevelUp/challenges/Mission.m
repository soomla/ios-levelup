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
#import "Schedule.h"
#import "Gate.h"

@implementation Mission

@synthesize rewards, schedule, gate;

static NSString* TAG = @"SOOMLA Mission";
static DictionaryFactory* dictionaryFactory;


- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName {
    return [self initWithMissionId:oMissionId
                           andName:oName
                  andGateClassName:nil
                 andGateInitParams:nil];
}

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andRewards:(NSArray *)oRewards {
    return [self initWithMissionId:oMissionId
                           andName:oName
                        andRewards:oRewards
                  andGateClassName:nil
                 andGateInitParams:nil];
}

- (id)initWithMissionId:(NSString *)oMissionId
                andName:(NSString *)oName
       andGateClassName:(NSString *)oClassName
      andGateInitParams:(NSArray *)oGateInitParams {
    return [self initWithMissionId:oMissionId
                           andName:oName
                        andRewards:[NSMutableArray array]
                  andGateClassName:oClassName
                 andGateInitParams:oGateInitParams];
}


- (id)initWithMissionId:(NSString *)oMissionId
                andName:(NSString *)oName
             andRewards:(NSArray *)oRewards
       andGateClassName:(NSString *)oClassName
      andGateInitParams:(NSArray *)oGateInitParams {
    self = [super initWithName:oName andDescription:@"" andID:oMissionId];
    if ([self class] == [Mission class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        
        self.rewards = oRewards;
//        self.gate = gate
        
        if (oClassName) {
            Class gateClass = NSClassFromString(oClassName);
            self.gate = [[gateClass alloc] init];
            
            // STUCK - need to initialize in reflection according
            // to number of arguments in gateInitParams and that's not possible in Objective C
        }
//        self.schedule = [Schedule AnyTimeOnce];
        
    }
    return self;

}


- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if ([self class] == [Mission class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        
        NSMutableArray* tmpRewards = [NSMutableArray array];
        NSArray* rewardsArr = dict[SOOM_REWARDS];
        
        // Iterate over all rewards in the JSON array and for each one create
        // an instance according to the reward type
        for (NSDictionary* rewardDict in rewardsArr) {
            
            Reward* reward = [Reward fromDictionary:rewardDict];
            if (reward) {
                [tmpRewards addObject:reward];
            }
        }
        
        self.rewards = tmpRewards;
        
        self.gate = [Gate fromDictionary:dict[LU_GATE]];
        if (dict[SOOM_SCHEDULE]) {
            self.schedule = [[Schedule alloc] initWithDictionary:dict[SOOM_SCHEDULE]];
        }
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[super toDictionary]];
    
    
    NSMutableArray* rewardsArr = [NSMutableArray array];
    for (Reward* reward in self.rewards) {
        [rewardsArr addObject:[reward toDictionary]];
    }
    [dict setObject:rewardsArr forKey:SOOM_REWARDS];
    [dict setObject:[self.gate toDictionary] forKey:LU_GATE];
    [dict setObject:[self.schedule toDictionary] forKey:SOOM_SCHEDULE];
    
    return dict;
}

- (NSString *)autoGateId {
    return [NSString stringWithFormat:@"gate_%@", ID];
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

@end
