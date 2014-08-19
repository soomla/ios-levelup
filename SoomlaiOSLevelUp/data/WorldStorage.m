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
#import "World.h"
#import "LevelUp.h"
#import "LevelUpEventHandling.h"
#import "StorageManager.h"
#import "KeyValueStorage.h"

@implementation WorldStorage

+ (void)setCompleted:(BOOL)completed forWorld:(World *)world {
    [self setCompleted:completed forWorld:world andNotify:YES];
}

+ (void)setCompleted:(BOOL)completed forWorld:(World *)world andNotify:(BOOL)notify {
    
    BOOL currentStatus = [self isWorldCompleted:world];
    if (currentStatus == completed) {
        
        // we don't need to set the status of a world to the same status over and over again.
        // couldn't only cause trouble.
        return;
    }
    
    
    NSString* key = [self keyWorldCompletedWithWorldId:world.ID];
    
    if (completed) {
        [KeyValueStorage setValue:@"yes" forKey:key];
        
        if (notify) {
            [LevelUpEventHandling postWorldCompleted:world];
        }
    } else {
        [KeyValueStorage deleteValueForKey:key];
    }
}

+ (BOOL)isWorldCompleted:(World *)world {
    NSString* key = [self keyWorldCompletedWithWorldId:world.ID];
    NSString* val = [KeyValueStorage getValueForKey:key];
    return (val && [val length] > 0);
}

+ (void)setReward:(NSString*)rewardId forWorld:(World *)world {
    NSString* key = [self keyRewardWithWorldId:world.ID];
    
    if (rewardId && [rewardId length] > 0) {
        [KeyValueStorage setValue:rewardId forKey:key];
    } else {
        [KeyValueStorage deleteValueForKey:key];
    }
    
    // Notify world was assigned a reward
    [LevelUpEventHandling postWorldRewardAssigned:world];
}

+ (NSString*)getAssignedReward:(World *)world {
    NSString* key = [self keyRewardWithWorldId:world.ID];
    return [KeyValueStorage getValueForKey:key];
}

// Private
+ (NSString *)keyWorldsWithWorldId:(NSString *)worldId andPostfix:(NSString *)postfix {
    return [NSString stringWithFormat: @"%@worlds.%@.%@", LU_DB_KEY_PREFIX, worldId, postfix];
}

+ (NSString *)keyWorldCompletedWithWorldId:(NSString *)worldId {
    return [self keyWorldsWithWorldId:worldId andPostfix:@"completed"];
}

+ (NSString *)keyRewardWithWorldId:(NSString *)worldId {
    return [self keyWorldsWithWorldId:worldId andPostfix:@"assignedReward"];
}

@end
