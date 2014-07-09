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
#import "JSONConsts.h"
#import "LUJSONConsts.h"
#import "StoreEventHandling.h"
#import "VirtualCurrency.h"
#import "VirtualGood.h"


@implementation BalanceMission

@synthesize associatedItemId, desiredBalance;



- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
    andAssociatedItemId:(NSString *)oAssociatedItemId andDesiredBalance:(int)oDesiredBalance {
    
    if (self = [super initWithMissionId:oMissionId andName:oName]) {
        self.associatedItemId = oAssociatedItemId;
        self.desiredBalance = oDesiredBalance;
    }
    
    [self observeNotifications];
    return self;
}

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
             andRewards:(NSArray *)oRewards andAssociatedItemId:(NSString *)oAssociatedItemId andDesiredBalance:(int)oDesiredBalance{
    
    if (self = [super initWithMissionId:oMissionId andName:oName andRewards:oRewards]) {
        self.associatedItemId = oAssociatedItemId;
        self.desiredBalance = oDesiredBalance;
    }
    
    [self observeNotifications];
    return self;
}



- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedItemId = dict[LU_ASSOCITEMID];
        self.desiredBalance = [dict[LU_DESIRED_BALANCE] intValue];
    }
    
    [self observeNotifications];
    return self;
}


- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:self.associatedItemId forKey:LU_ASSOCITEMID];
    [toReturn setObject:[NSNumber numberWithInt:self.desiredBalance] forKey:LU_DESIRED_BALANCE];
    
    return toReturn;
}



// Private Methods

- (void)checkBalance:(int)balance forItemId:(NSString*)itemId {
    if ([itemId isEqualToString:self.associatedItemId] && balance >= self.desiredBalance) {
        [self setCompleted:YES];
    }
}

- (void)currencyBalanceChanged:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    VirtualCurrency* currency = userInfo[DICT_ELEMENT_CURRENCY];
    int balance = [userInfo[DICT_ELEMENT_BALANCE] intValue];
    
    [self checkBalance:balance forItemId:currency.itemId];
}

- (void)goodBalanceChanged:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    VirtualGood* good = userInfo[DICT_ELEMENT_GOOD];
    int balance = [userInfo[DICT_ELEMENT_BALANCE] intValue];
    
    [self checkBalance:balance forItemId:good.itemId];
}

- (void)observeNotifications {
    if (![self isCompleted]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currencyBalanceChanged:) name:EVENT_CURRENCY_BALANCE_CHANGED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodBalanceChanged:) name:EVENT_GOOD_BALANCE_CHANGED object:nil];
    }
}

- (void)stopObservingNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_CURRENCY_BALANCE_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_GOOD_BALANCE_CHANGED object:nil];
}


@end
