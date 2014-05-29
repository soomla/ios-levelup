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

#import "Reward.h"

@interface VirtualItemReward : Reward {
    
    @private
    int amount;
    NSString* associatedItemId;
}

@property (strong, nonatomic) NSString* associatedItemId;
@property int amount;

- (id)initWithRewardId:(NSString *)oRewardId andName:(NSString *)oName andAmount:(int)oAmount andAssociatedItemId:(NSString *)oAssociatedItemId;

@end
