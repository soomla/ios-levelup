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

#import "World.h"
#import "Mission.h"
#import "Score.h"
#import "Gate.h"
#import "LUJSONConsts.h"
#import "SoomlaUtils.h"
#import "DictionaryFactory.h"

@implementation World

@synthesize gate, innerWorldsMap, scores, missions;

static NSString* TAG = @"SOOMLA World";
static DictionaryFactory* dictionaryFactory;


- (id)initWithWorldId:(NSString *)oWorldId {
    if (self = [super initWithName:@"" andDescription:@"" andID:oWorldId]) {
    }
    return self;
}

- (id)initWithWorldId:(NSString *)oWorldId andGate:(Gate *)oGate
    andInnerWorldsMap:(NSMutableDictionary *)oInnerWorldsMap andScores:(NSMutableDictionary *)oScores andMissions:(NSArray *)oMissions {

    if (self = [super initWithName:@"" andDescription:@"" andID:oWorldId]) {
        gate = oGate;
        innerWorldsMap = oInnerWorldsMap;
        scores = oScores;
        missions = [NSMutableArray arrayWithArray:oMissions];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        
        
        NSMutableDictionary* tmpInnerWorlds = [NSMutableDictionary dictionary];
        NSArray* innerWorldDicts = dict[LU_WORLDS];
        
        // Iterate over all inner worlds in the JSON array and for each one create
        // an instance according to the world type
        for (NSDictionary* innerWorldDict in innerWorldDicts) {
            
            World* world = [World fromDictionary:innerWorldDict];
            if (world) {
                [tmpInnerWorlds setObject:world forKey:world.ID];
            }
        }
        
        innerWorldsMap = tmpInnerWorlds;
        
        
        NSMutableDictionary* tmpScores = [NSMutableDictionary dictionary];
        NSArray* scoreDicts = dict[LU_SCORES];
        
        // Iterate over all scores in the JSON array and for each one create
        // an instance according to the score type
        for (NSDictionary* scoreDict in scoreDicts) {
            
            Score* score = [Score fromDictionary:scoreDict];
            if (score) {
                [tmpScores setObject:score forKey:score.ID];
            }
        }

        scores = tmpScores;
        
        
        NSMutableArray* tmpMissions = [NSMutableArray array];
        NSArray* missionDicts = dict[LU_MISSIONS];
        
        // Iterate over all challenges in the JSON array and create an instance for each one
        for (NSDictionary* missionDict in missionDicts) {
            [tmpMissions addObject:[[Mission alloc] initWithDictionary:missionDict]];
        }
        
        missions = tmpMissions;
        
        if (dict[LU_GATE]) {
            gate = [Gate fromDictionary:dict[LU_GATE]];
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[super toDictionary]];

    [dict setObject:[gate toDictionary] forKey:LU_GATE];

    NSMutableArray* innerWorldsArr = [NSMutableArray array];
    for (NSString* innerWorldId in innerWorldsMap) {
        [innerWorldsArr addObject:[innerWorldsMap[innerWorldId] toDictionary]];
    }
    [dict setObject:innerWorldsArr forKey:LU_WORLDS];
    
    NSMutableArray* scoresArr = [NSMutableArray array];
    for (NSString* scoreId in self.scores) {
        [innerWorldsArr addObject:[self.scores[scoreId] toDictionary]];
    }
    [dict setObject:scoresArr forKey:LU_SCORES];
    
    NSMutableArray* missionsArr = [NSMutableArray array];
    for (Mission* mission in missions) {
        [missionsArr addObject:[mission toDictionary]];
    }
    [dict setObject:missionsArr forKey:LU_MISSIONS];
    
    return dict;
}


// Static methods

+ (World *)fromDictionary:(NSDictionary *)dict {
    return (World *)[dictionaryFactory createObjectWithDictionary:dict];
}

+ (void)initialize {
    if (self == [World self]) {
        dictionaryFactory = [[DictionaryFactory alloc] init];
    }
}

@end
