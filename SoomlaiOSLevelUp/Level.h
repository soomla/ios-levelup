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

typedef NS_ENUM(NSInteger, LevelState) {
    IDLE,
    RUNNING,
    PAUSED,
    ENDED,
    COMPLETED
};

@interface Level : World {

    @private
    long long startTime;
    long long currentTime;
    long long elapsed;
    LevelState state;
}

@property LevelState state;

- (int)getTimesStarted;

- (int)getTimesPlayed;

- (double)getSlowestDuration;

- (double)getFastestDuration;

- (double)getPlayDuration;

- (BOOL)start;

- (void)pause;

- (void)resume;

- (void)end:(BOOL)completed;

@end
