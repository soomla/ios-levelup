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

#import "BalanceMission.h"
#import "BalanceGate.h"


@implementation BalanceMission


- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
    andAssociatedItemId:(NSString *)oAssociatedItemId andDesiredBalance:(int)oDesiredBalance {
    
    if (self = [super initWithMissionId:oMissionId
                                andName:oName
                       andGateClassName:NSStringFromClass([BalanceGate class])
                      andGateInitParams:@[oAssociatedItemId, @(oDesiredBalance)]]) {
    
    }
    
    return self;
}

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
             andRewards:(NSArray *)oRewards andAssociatedItemId:(NSString *)oAssociatedItemId andDesiredBalance:(int)oDesiredBalance{
    
    if (self = [super initWithMissionId:oMissionId
                                andName:oName
                             andRewards:oRewards
                       andGateClassName:NSStringFromClass([BalanceGate class])
                      andGateInitParams:@[oAssociatedItemId, @(oDesiredBalance)]]) {
        
    }
    
    return self;
}

@end
