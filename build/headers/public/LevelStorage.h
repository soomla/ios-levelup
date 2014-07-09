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

#import <Foundation/Foundation.h>

@class Level;

@interface LevelStorage : NSObject

+ (void)setSlowestDuration:(double)duration forLevel:(Level *)level;

+ (double)getSlowestDurationForLevel:(Level *)level;

+ (void)setFastestDuration:(double)duration forLevel:(Level *)level;

+ (double)getFastestDurationforLevel:(Level *)level;

+ (int)incTimesStartedForLevel:(Level *)level;

+ (int)decTimesStartedForLevel:(Level *)level;

+ (int)getTimesStartedForLevel:(Level *)level;

+ (int)incTimesPlayedForLevel:(Level *)level;

+ (int)decTimesPlayedForLevel:(Level *)level;

+ (int)getTimesPlayedForLevel:(Level *)level;

@end