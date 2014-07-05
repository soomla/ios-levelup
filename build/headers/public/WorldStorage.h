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

@class World;

@interface WorldStorage : NSObject

+ (void)setCompleted:(BOOL)completed forWorld:(World *)world;

+ (void)setCompleted:(BOOL)completed forWorld:(World *)world andNotify:(BOOL)notify;

+ (BOOL)isWorldCompleted:(World *)world;

+ (void)setReward:(NSString*)rewardId forWorld:(World *)world;

+ (NSString*)getAssignedReward:(World *)world;

@end