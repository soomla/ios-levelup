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

@interface WorldStorage : NSObject

+ (void)initLevelUp;

+ (void)setCompleted:(BOOL)completed forWorld:(NSString *)worldId;

+ (void)setCompleted:(BOOL)completed forWorld:(NSString *)worldId andNotify:(BOOL)notify;

+ (BOOL)isWorldCompleted:(NSString *)worldId;

+ (void)setReward:(NSString*)rewardId forWorld:(NSString *)worldId;

+ (void)setReward:(NSString*)rewardId forWorld:(NSString *)worldId andNotify:(BOOL)notify;

+ (NSString*)getAssignedReward:(NSString *)worldId;

+ (void)setLastCompletedInnerWorld:(NSString*)innerWorldId forWorld:(NSString *)worldId;

+ (void)setLastCompletedInnerWorld:(NSString*)innerWorldId forWorld:(NSString *)worldId andNotify:(BOOL)notify;

+ (NSString*)getLastCompletedInnerWorld:(NSString *)worldId;

+ (BOOL)isLevel:(NSString *)worldId;

+ (NSString *)keyWorldPrefix;

@end
