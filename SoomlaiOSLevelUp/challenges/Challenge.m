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
#import "LUJSONConsts.h"
#import "SoomlaUtils.h"

@implementation Challenge

@synthesize missions;

static NSString* TAG = @"SOOMLA Challenge";

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andMissions:(NSArray *)oMissions {
    if (self = [super initWithMissionId:oMissionId andName:oName]) {
        self.missions = oMissions;
    }
    
    return self;
}

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andMissions:(NSArray *)oMissions andRewards:(NSArray *)oRewards {
    if (self = [super initWithMissionId:oMissionId andName:oName andRewards:oRewards]) {
        self.missions = oMissions;
    }
    
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


@end
