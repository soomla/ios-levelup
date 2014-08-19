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

#import "RecordGate.h"
#import "LUJSONConsts.h"
#import "SoomlaUtils.h"

@implementation RecordGate

@synthesize associatedScoreId, desiredRecord;

static NSString* TAG = @"SOOMLA RecordGate";

// TODO: Override other constructors and throw exceptions, since they don't have the associated item ID and desired balance


- (id)initWithGateId:(NSString *)oGateId andScoreId:(NSString *)oScoreId andDesiredRecord:(double)oDesiredRecord {
    if (self = [super initWithGateId:oGateId]) {
        self.associatedScoreId = oScoreId;
        self.desiredRecord = oDesiredRecord;
    }
    
    return self;
}


- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.associatedScoreId = dict[LU_ASSOCSCOREID];
        self.desiredRecord = [dict[LU_DESIRED_RECORD] doubleValue];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:self.associatedScoreId forKey:LU_ASSOCSCOREID];
    [toReturn setObject:[NSNumber numberWithDouble:self.desiredRecord] forKey:LU_DESIRED_RECORD];
    
    return toReturn;
}

@end
