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

#import "Score.h"
#import "LUJSONConsts.h"
#import "DictionaryFactory.h"


@implementation Score

@synthesize startValue, higherBetter;

static DictionaryFactory* dictionaryFactory;


- (id)initWithScoreId:(NSString *)oScoreId {
    return [self initWithScoreId:oScoreId andName:@"" andHigherBetter:YES];
}

- (id)initWithScoreId:(NSString *)oScoreId andName:(NSString *)oName andHigherBetter:(BOOL)oHigherBetter {
    if (self = [super initWithName:oName andDescription:@"" andID:oScoreId]) {
        self.startValue = 0;
        self.higherBetter = oHigherBetter;
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.startValue = [dict[LU_SCORE_STARTVAL] doubleValue];
        self.higherBetter = [dict[LU_SCORE_HIGHBETTER] boolValue];
    }
    
    return self;
};

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:@(self.startValue) forKey:LU_SCORE_STARTVAL];
    [toReturn setObject:@(self.higherBetter) forKey:LU_SCORE_HIGHBETTER];
    
    return toReturn;
}



- (BOOL)isHigherBetter {
    return higherBetter;
}


// Static methods

+ (Score *)fromDictionary:(NSDictionary *)dict {
    return (Score *)[dictionaryFactory createObjectWithDictionary:dict];
}

+ (void)initialize {
    if (self == [Score self]) {
        dictionaryFactory = [[DictionaryFactory alloc] init];
    }
}


@end

