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

#import "RecordMission.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"
#import "Score.h"
#import "LevelUpEventHandling.h"

@implementation RecordMission

@synthesize associatedScoreId, desiredRecord;


- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
   andAssociatedScoreId:(NSString *)oAssociatedScoreId andDesiredRecord:(int)oDesiredRecord {
    
    if (self = [super initWithMissionId:oMissionId andName:oName]) {
        self.associatedScoreId = oAssociatedScoreId;
        self.desiredRecord = oDesiredRecord;
    }
    
    [self observeNotifications];
    return self;
}

- (id)initWithMissionId:(NSString *)oMissionId andName:(NSString *)oName
             andRewards:(NSArray *)oRewards andAssociatedScoreId:(NSString *)oAssociatedScoreId andDesiredRecord:(int)oDesiredRecord {
    
    if (self = [super initWithMissionId:oMissionId andName:oName andRewards:oRewards]) {
        self.associatedScoreId = oAssociatedScoreId;
        self.desiredRecord = oDesiredRecord;
    }
    
    [self observeNotifications];
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedScoreId = dict[LU_ASSOCSCOREID];
        self.desiredRecord = [dict[LU_DESIRED_RECORD] doubleValue];
    }
    
    if (![self isCompleted]) {
        [self observeNotifications];
    }
    
    [self observeNotifications];
    return self;
}


- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:self.associatedScoreId forKey:LU_ASSOCSCOREID];
    [toReturn setObject:[NSNumber numberWithDouble:self.desiredRecord] forKey:LU_DESIRED_RECORD];
    
    return toReturn;
}


// Private

- (void)scoreRecordChanged:(NSNotification *)notification {
    
    NSDictionary* userInfo = notification.userInfo;
    Score* score = userInfo[DICT_ELEMENT_SCORE];
    
    if ([score.scoreId isEqualToString:self.associatedScoreId] && [score hasRecordReachedScore:self.desiredRecord]) {
        [self setCompleted:YES];
    }
};

- (void)observeNotifications {
    if (![self isCompleted]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreRecordChanged:) name:EVENT_SCORE_RECORD_CHANGED object:nil];
    }
}

- (void)stopObservingNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_SCORE_RECORD_CHANGED object:nil];
}


@end
