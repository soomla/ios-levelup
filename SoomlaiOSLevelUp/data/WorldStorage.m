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

#import "WorldStorage.h"
#import "LevelUp.h"
#import "LevelUpEventHandling.h"
#import "KeyValueStorage.h"
#import "SoomlaUtils.h"

@implementation WorldStorage

static NSString *DB_WORLD_KEY_PREFIX;

+(void)initialize {
    DB_WORLD_KEY_PREFIX = [NSString stringWithFormat:@"%@worlds.", LU_DB_KEY_PREFIX];
}

+ (void)initLevelUp {
    [LevelUpEventHandling postLevelUpInitialized];
}

+ (void)setCompleted:(BOOL)completed forWorld:(NSString *)worldId {
    [self setCompleted:completed forWorld:worldId andNotify:YES];
}

+ (void)setCompleted:(BOOL)completed forWorld:(NSString *)worldId andNotify:(BOOL)notify {
    
    NSString* key = [self keyWorldCompletedWithWorldId:worldId];
    
    if (completed) {
        [KeyValueStorage setValue:@"yes" forKey:key];
        
        if (notify) {
            [LevelUpEventHandling postWorldCompleted:worldId];
        }
    } else {
        [KeyValueStorage deleteValueForKey:key];
    }
}

+ (BOOL)isWorldCompleted:(NSString *)worldId {
    NSString* key = [self keyWorldCompletedWithWorldId:worldId];
    NSString* val = [KeyValueStorage getValueForKey:key];
    return (val && [val length] > 0);
}

+ (void)setReward:(NSString*)rewardId forWorld:(NSString *)worldId {
    [self setReward:rewardId forWorld:worldId andNotify:YES];
}

+ (void)setReward:(NSString*)rewardId forWorld:(NSString *)worldId andNotify:(BOOL)notify {
    NSString* key = [self keyRewardWithWorldId:worldId];
    
    if (!IsStringEmpty(rewardId)) {
        [KeyValueStorage setValue:rewardId forKey:key];
    } else {
        [KeyValueStorage deleteValueForKey:key];
    }
    
    if (notify) {
        // Notify world was assigned a reward
        [LevelUpEventHandling postWorldRewardAssigned:worldId];
    }
}

+ (NSString*)getAssignedReward:(NSString *)worldId {
    NSString* key = [self keyRewardWithWorldId:worldId];
    return [KeyValueStorage getValueForKey:key];
}

+ (void)setLastCompletedInnerWorld:(NSString*)innerWorldId forWorld:(NSString *)worldId {
    [self setLastCompletedInnerWorld:innerWorldId forWorld:worldId andNotify:YES];
}

+ (void)setLastCompletedInnerWorld:(NSString*)innerWorldId forWorld:(NSString *)worldId andNotify:(BOOL)notify {
    NSString* key = [self keyLastCompletedInnerWorldWithWorldId:worldId];
    
    if (!IsStringEmpty(innerWorldId)) {
        [KeyValueStorage setValue:innerWorldId forKey:key];
    } else {
        [KeyValueStorage deleteValueForKey:key];
    }
    
    if (notify) {
        // Notify world had inner level complete
        [LevelUpEventHandling postLastCompletedInnerWorldChanged:worldId andInnerWorld:innerWorldId];
    }
}

+ (NSString*)getLastCompletedInnerWorld:(NSString *)worldId {
    NSString* key = [self keyLastCompletedInnerWorldWithWorldId:worldId];
    return [KeyValueStorage getValueForKey:key];
}

+ (BOOL)isLevel:(NSString *)worldId {
    NSDictionary *model = [LevelUp getLevelUpModel];
    if (model) {
        NSDictionary *worlds = [LevelUp getWorlds:model];
        NSDictionary *world = worlds[worldId];
        if (world) {
            NSString *itemId = world[@"itemId"];
            if (itemId && [itemId isEqualToString:worldId]) {
                NSString *className = world[@"className"];
                return [className isEqualToString:@"Level"];
            }
        }
    }
    
    return NO;
}

+ (NSString *)keyWorldPrefix {
    return DB_WORLD_KEY_PREFIX;
}

// Private
+ (NSString *)keyWorldsWithWorldId:(NSString *)worldId andPostfix:(NSString *)postfix {
    return [NSString stringWithFormat: @"%@%@.%@", DB_WORLD_KEY_PREFIX, worldId, postfix];
}

+ (NSString *)keyWorldCompletedWithWorldId:(NSString *)worldId {
    return [self keyWorldsWithWorldId:worldId andPostfix:@"completed"];
}

+ (NSString *)keyRewardWithWorldId:(NSString *)worldId {
    return [self keyWorldsWithWorldId:worldId andPostfix:@"assignedReward"];
}

+ (NSString *)keyLastCompletedInnerWorldWithWorldId:(NSString *)worldId {
    return [self keyWorldsWithWorldId:worldId andPostfix:@"lastCompletedInnerWorld"];
}

@end
