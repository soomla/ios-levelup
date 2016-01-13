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

#import "LevelUp.h"
#import "KeyValueStorage.h"
#import "SoomlaUtils.h"
#import "GateStorage.h"
#import "MissionStorage.h"
#import "WorldStorage.h"
#import "LevelStorage.h"
#import "ScoreStorage.h"

#define SOOMLA_LEVELUP_VERSION @"1.0.12"

@implementation LevelUp

static NSString *TAG = @"SOOMLA LevelUp";

+ (NSString*)getVersion {
    return SOOMLA_LEVELUP_VERSION;
}

+ (NSDictionary *)getLevelUpState {
    NSMutableDictionary *stateDict = [NSMutableDictionary dictionary];

    NSDictionary *modelDict = [self getLevelUpModel];
    if (!modelDict) {
        return stateDict;
    }

    [self applyGatesStateToDict:modelDict andApplyTo:stateDict];
    [self applyWorldsStateToDict:modelDict andApplyTo:stateDict];
    [self applyMissionsStateToDict:modelDict andApplyTo:stateDict];
    [self applyScoresStateToDict:modelDict andApplyTo:stateDict];

    return stateDict;
}

+ (BOOL)resetLevelUpState:(NSDictionary *)state {
    if (!state) {
        return NO;
    }

    LogDebug(TAG, ([NSString stringWithFormat:@"Resetting state with: %@", state]));

    [self clearCurrentState];

    LogDebug(TAG, @"Current state was cleared");

    return [self resetGatesStateFromDict:state] &&
    [self resetWorldsStateFromDict:state] &&
    [self resetMissionsStateFromDict:state] &&
    [self resetScoresStateFromDict:state];

}

+ (NSDictionary *)getLevelUpModel {
    NSString *modelStr = [KeyValueStorage getValueForKey:[NSString stringWithFormat:@"%@%@", LU_DB_KEY_PREFIX, @"model"]];
    LogDebug(TAG, ([NSString stringWithFormat:@"model: %@", modelStr]));

    if (IsStringEmpty(modelStr)) {
        return nil;
    }

    NSDictionary* modelDict = [SoomlaUtils jsonStringToDict:modelStr];
    return modelDict;
}

+ (NSDictionary *)getWorlds:(NSDictionary *)model {
    NSMutableDictionary *worlds = [NSMutableDictionary dictionary];

    NSDictionary *mainWorld = model[@"mainWorld"];
    if (mainWorld) {
        [self addWorldObjectToWorlds:worlds worldToAdd:mainWorld];
    }

    return worlds;
}

+ (NSDictionary *)getMissions:(NSDictionary *)model {
    NSMutableDictionary *missions = [self getListFromWorlds:model andListName:@"missions"];
    [self findInternalLists:missions andContainersList:@[ @"Challenge" ] andListName:@"missions"];

    return missions;
}

+ (NSDictionary *)getGates:(NSDictionary *)model {
    NSMutableDictionary *resultHash = [NSMutableDictionary dictionary];

    NSDictionary *worlds = [self getWorlds:model];
    for (NSString *worldId in worlds.allKeys) {
        NSDictionary *worldDict = worlds[worldId];
        NSDictionary *gateDict = worldDict[@"gate"];
        if (gateDict) {
            NSString *objectId = gateDict[@"itemId"];
            if (!IsStringEmpty(objectId)) {
                resultHash[objectId] = gateDict;
            }
        }
    }

    NSDictionary *missions = [self getMissions:model];
    for (NSString *missionId in missions.allKeys) {
        NSDictionary *missionDict = missions[missionId];
        NSDictionary *gateDict = missionDict[@"gate"];
        if (gateDict) {
            NSString *objectId = gateDict[@"itemId"];
            if (!IsStringEmpty(objectId)) {
                resultHash[objectId] = gateDict;
            }
        }
    }

    [self findInternalLists:resultHash andContainersList:@[ @"GatesListAND", @"GatesListOR" ] andListName:@"gates"];

    return resultHash;
}

+ (NSDictionary *)getScores:(NSDictionary *)model {
    return [self getListFromWorlds:model andListName:@"scores"];
}

// Private

+ (void) clearCurrentState {
    NSArray *allKeys = [KeyValueStorage getEncryptedKeys];
    for (NSString *key in allKeys) {
        if (([key rangeOfString:[GateStorage keyGatePrefix]].length > 0) ||
            ([key rangeOfString:[LevelStorage keyLevelPrefix]].length > 0) ||
            ([key rangeOfString:[MissionStorage keyMissionPrefix]].length > 0) ||
            ([key rangeOfString:[ScoreStorage keyScorePrefix]].length > 0) ||
            ([key rangeOfString:[WorldStorage keyWorldPrefix]].length > 0)) {
            [KeyValueStorage deleteValueForKey:key];
        }
    }
}

+ (void)applyGatesStateToDict:(NSDictionary *)model andApplyTo:(NSMutableDictionary *)state {
    NSMutableDictionary *gatesStateDict = [NSMutableDictionary dictionary];
    NSDictionary *gates = [self getGates:model];

    for (NSString *gateId in gates.allKeys) {
        NSDictionary *gateDict = gates[gateId];
        NSMutableDictionary *gateValuesDict = [NSMutableDictionary dictionary];
        NSString *gateId = gateDict[@"itemId"];
        if (!IsStringEmpty(gateId)) {
            gateValuesDict[@"open"] = [NSNumber numberWithBool:[GateStorage isOpen:gateId]];

            gatesStateDict[gateId] = gateValuesDict;
        }
    }

    state[@"gates"] = gatesStateDict;
}

+ (void)applyWorldsStateToDict:(NSDictionary *)model andApplyTo:(NSMutableDictionary *)state {
    NSMutableDictionary *worldsStateDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *levelsStateDict = [NSMutableDictionary dictionary];

    NSDictionary *worlds = [self getWorlds:model];
    for (NSString *wId in worlds.allKeys) {
        NSDictionary *worldDict = worlds[wId];
        NSString *worldId = worldDict[@"itemId"];
        if (!IsStringEmpty(worldId)) {
            NSMutableDictionary *worldValuesDict = [NSMutableDictionary dictionary];

            worldValuesDict[@"completed"] = [NSNumber numberWithBool:[WorldStorage isWorldCompleted:worldId]];
            NSString *assignedRewardId = [WorldStorage getAssignedReward:worldId];
            if (!IsStringEmpty(assignedRewardId)) {
                worldValuesDict[@"assignedReward"] = assignedRewardId;
            }

            NSString *innerWorldId = [WorldStorage getLastCompletedInnerWorld:worldId];
            if (!IsStringEmpty(innerWorldId)) {
                worldValuesDict[@"lastCompletedInnerWorld"] = innerWorldId;
            }

            worldsStateDict[worldId] = worldValuesDict;

            NSString *className = worldDict[@"className"];
            if (!IsStringEmpty(className) && [className isEqualToString:@"Level"]) {
                NSMutableDictionary *levelValuesDict = [NSMutableDictionary dictionary];
                levelValuesDict[@"started"] = [NSNumber numberWithInt:[LevelStorage getTimesStartedForLevel:worldId]];
                levelValuesDict[@"played"] = [NSNumber numberWithInt:[LevelStorage getTimesPlayedForLevel:worldId]];
                levelValuesDict[@"timesCompleted"] = [NSNumber numberWithInt:[LevelStorage getTimesCompletedForLevel:worldId]];
                levelValuesDict[@"slowest"] = [NSNumber numberWithLongLong:[LevelStorage getSlowestDurationMillisForLevel:worldId]];
                levelValuesDict[@"fastest"] = [NSNumber numberWithLongLong:[LevelStorage getFastestDurationMillisForLevel:worldId]];

                levelsStateDict[worldId] = levelValuesDict;
            }
        }
    }

    state[@"worlds"] = worldsStateDict;
    state[@"levels"] = levelsStateDict;
}

+ (void)applyMissionsStateToDict:(NSDictionary *)model andApplyTo:(NSMutableDictionary *)state {
    NSMutableDictionary *missionsStateDict = [NSMutableDictionary dictionary];

    NSDictionary *missions = [self getMissions:model];
    for (NSString *mId in missions.allKeys) {
        NSDictionary *missionDict = missions[mId];
        NSString *missionId = missionDict[@"itemId"];
        if (!IsStringEmpty(missionId)) {
            NSMutableDictionary *missionValuesDict = [NSMutableDictionary dictionary];
            missionValuesDict[@"timesCompleted"] = [NSNumber numberWithInt:[MissionStorage getTimesCompleted:missionId]];

            missionsStateDict[missionId] = missionValuesDict;
        }
    }

    state[@"missions"] = missionsStateDict;
}

+ (void)applyScoresStateToDict:(NSDictionary *)model andApplyTo:(NSMutableDictionary *)state {
    NSMutableDictionary *scoresStateDict = [NSMutableDictionary dictionary];

    NSDictionary *scores = [self getScores:model];
    for (NSString *sId in scores.allKeys) {
        NSDictionary *scoreDict = scores[sId];
        NSString *scoreId = scoreDict[@"itemId"];
        if (!IsStringEmpty(scoreId)) {
            NSMutableDictionary *scoreValuesDict = [NSMutableDictionary dictionary];
            scoreValuesDict[@"latest"] = [NSNumber numberWithDouble:[ScoreStorage getLatestScore:scoreId]];
            scoreValuesDict[@"record"] = [NSNumber numberWithDouble:[ScoreStorage getRecordScore:scoreId]];

            scoresStateDict[scoreId] = scoreValuesDict;
        }
    }

    state[@"scores"] = scoresStateDict;
}

+ (BOOL) resetGatesStateFromDict:(NSDictionary *)state {
    return [self resetStateFromDict:state
                        andListName:@"gates"
                    andApplierBlock:^BOOL(NSString *itemId, NSDictionary *itemValuesDict) {
                        NSNumber *openState = itemValuesDict[@"open"];
                        if (openState) {
                            [GateStorage setOpen:[openState boolValue] forGate:itemId andEvent:NO];
                        }

                        return YES;
                    }];
}

+ (BOOL) resetWorldsStateFromDict:(NSDictionary *)state {
    BOOL worldsApplyState = [self resetStateFromDict:state
                                         andListName:@"worlds"
                                     andApplierBlock:^BOOL(NSString *itemId, NSDictionary *itemValuesDict) {
                                         NSNumber *completedState = itemValuesDict[@"completed"];
                                         if (completedState) {
                                             [WorldStorage setCompleted:[completedState boolValue] forWorld:itemId andNotify:NO];
                                         }

                                         NSString *assignedRewardId = itemValuesDict[@"assignedReward"];
                                         if (!IsStringEmpty(assignedRewardId)) {
                                             [WorldStorage setReward:assignedRewardId forWorld:itemId andNotify:NO];
                                         }

                                         NSString *innerWorldId = itemValuesDict[@"lastCompletedInnerWorld"];
                                         if (!IsStringEmpty(innerWorldId)) {
                                             [WorldStorage setLastCompletedInnerWorld:innerWorldId forWorld:itemId andNotify:NO];
                                         }

                                         return YES;
                                     }];

    BOOL levelsApplyState = [self resetStateFromDict:state
                                         andListName:@"levels"
                                     andApplierBlock:^BOOL(NSString *itemId, NSDictionary *itemValuesDict) {
                                         NSNumber *timesStarted = itemValuesDict[@"started"];
                                         if (timesStarted) {
                                             [LevelStorage setTimesStartedForLevel:itemId andStartedCount:[timesStarted intValue]];
                                         }

                                         NSNumber *timesPlayed = itemValuesDict[@"played"];
                                         if (timesPlayed) {
                                             [LevelStorage setTimesPlayedForLevel:itemId andPlayedCount:[timesPlayed intValue]];
                                         }

                                         NSNumber *timesCompleted = itemValuesDict[@"timesCompleted"];
                                         if (timesCompleted) {
                                             [LevelStorage setTimesCompletedForLevel:itemId andTimesCompleted:[timesCompleted intValue]];
                                         }

                                         NSNumber *slowest = itemValuesDict[@"slowest"];
                                         if (slowest) {
                                             [LevelStorage setSlowestDurationMillis:[slowest longLongValue] forLevel:itemId];
                                         }

                                         NSNumber *fastest = itemValuesDict[@"fastest"];
                                         if (fastest) {
                                             [LevelStorage setFastestDurationMillis:[fastest longLongValue] forLevel:itemId];
                                         }

                                         return YES;
                                     }];

    return worldsApplyState && levelsApplyState;
}

+ (BOOL) resetMissionsStateFromDict:(NSDictionary *)state {
    return [self resetStateFromDict:state andListName:@"missions"
                    andApplierBlock:^BOOL(NSString *itemId, NSDictionary *itemValuesDict) {
                        NSNumber *timesCompleted = itemValuesDict[@"timesCompleted"];
                        if (timesCompleted) {
                            [MissionStorage setTimesCompleted:itemId andTimesCompleted:[timesCompleted intValue]];
                        }

                        return YES;
                    }];
}

+ (BOOL) resetScoresStateFromDict:(NSDictionary *)state {
    return [self resetStateFromDict:state andListName:@"scores"
                    andApplierBlock:^BOOL(NSString *itemId, NSDictionary *itemValuesDict) {
                        NSNumber *latestScore = itemValuesDict[@"latest"];
                        if (latestScore) {
                            [ScoreStorage setLatest:[latestScore doubleValue] toScore:itemId andNotify:NO];
                        }

                        NSNumber *recordScore = itemValuesDict[@"record"];
                        if (recordScore) {
                            [ScoreStorage setRecord:[recordScore doubleValue] toScore:itemId andNotify:NO];
                        }

                        return YES;
                    }];
}

+ (BOOL) resetStateFromDict:(NSDictionary *)state andListName:(NSString *)targetListName
            andApplierBlock:(BOOL (^)(NSString * itemId, NSDictionary *itemValuesDict))applierBlock{

    NSDictionary *itemsDict = state[targetListName];
    if (!itemsDict) {
        return YES;
    }

    LogDebug(TAG, ([NSString stringWithFormat:@"Resetting state for %@", targetListName]));

    for (NSString *itemId in itemsDict.allKeys) {
        NSDictionary *itemValuesDict = itemsDict[itemId];
        @try {
            if (!applierBlock(itemId, itemValuesDict)) {
                return NO;
            }
        }
        @catch (NSException *exception) {
            LogError(TAG, ([NSString stringWithFormat:@"Unable to apply state for %@. error: %@", itemId, exception.description]));
            return NO;
        }
    }

    return YES;
}

+ (void)addWorldObjectToWorlds:(NSMutableDictionary *)worlds worldToAdd:(NSDictionary *)worldDict {
    NSString *worldId = worldDict[@"itemId"];
    if (worldId) {
        worlds[worldId] = worldDict;
    }

    NSArray *worldsArray = worldDict[@"worlds"];
    if (worldsArray) {
        for (NSDictionary *innerWorldDict in worldsArray) {
            [self addWorldObjectToWorlds:worlds worldToAdd:innerWorldDict];
        }
    }
}

+ (NSMutableDictionary *)getListFromWorlds:(NSDictionary *)model andListName:(NSString *)listName {
    NSMutableDictionary *resultHash = [NSMutableDictionary dictionary];

    NSDictionary *worlds = [self getWorlds:model];
    for (NSString *worldId in worlds.allKeys) {
        NSDictionary *worldDict = worlds[worldId];
        NSArray *objectDicts = worldDict[listName];
        if (objectDicts) {
            for (NSDictionary *objectDict in objectDicts) {
                NSString *objectId = objectDict[@"itemId"];
                if (!IsStringEmpty(objectId)) {
                    resultHash[objectId] = objectDict;
                }
            }
        }
    }

    return resultHash;
}

+ (void)findInternalLists:(NSMutableDictionary *)objects andContainersList:(NSArray *)listClasses andListName:(NSString *)listName {
    for (NSString *objectId in objects.allKeys) {
        NSDictionary *objectDict = objects[objectId];
        [self findInternalLists:objects andContainersList:listClasses andListName:listName andCheckDict:objectDict];
    }
}

+ (void)findInternalLists:(NSMutableDictionary *)objects andContainersList:(NSArray *)listClasses andListName:(NSString *)listName andCheckDict:(NSDictionary *)checkDict {
    NSString *className = checkDict[@"className"];
    if (!IsStringEmpty(className)) {
        if ([listClasses indexOfObject:className] != NSNotFound) {
            // of the right type to contain more objects
            NSArray *internalList = checkDict[listName];
            if (internalList) {
                for (NSDictionary *targetObject in internalList) {
                    NSString *itemId = targetObject[@"itemId"];
                    if (!IsStringEmpty(itemId)) {
                        objects[itemId] = targetObject;
                        [self findInternalLists:objects andContainersList:listClasses andListName:listName andCheckDict:targetObject];
                    }
                }
            }
        }
    }
}

@end
