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

// Abstract (not because of unimplemented methods, but in the sense that
// the developer should not instantiate this class directly but only sub-classes)
#import "SoomlaEntity.h"

@class Schedule;
@class Gate;

@interface Mission : SoomlaEntity {
    
    @private
    NSArray* rewards;
    Schedule* schedule;
    Gate* gate;
}

@property (strong, nonatomic) NSArray* rewards;
@property (strong, nonatomic) Schedule* schedule;
@property (strong, nonatomic) Gate* gate;


- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName;

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName andRewards:(NSArray *)oRewards;

- (id)initWithMissionId:(NSString *)oMissionId
                andName:(NSString *)oName
       andGateClassName:(NSString *)oClassame
      andGateInitParams:(NSArray *)oGateInitParams;

- (id)initWithMissionId:(NSString *)oMissionId
                andName:(NSString *)oName
             andRewards:(NSArray *)oRewards
       andGateClassName:(NSString *)oClassName
      andGateInitParams:(NSArray *)oGateInitParams;


// Static methods

+ (Mission *)fromDictionary:(NSDictionary *)dict;

@end
