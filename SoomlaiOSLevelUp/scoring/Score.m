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
#import "RangeScore.h"
#import "VirtualItemScore.h"
#import "ScoreStorage.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"
#import "DictionaryFactory.h"


@implementation Score

@synthesize name, scoreId, startValue, tempScore, higherBetter;

static DictionaryFactory* dictionaryFactory;


- (id)initWithScoreId:(NSString *)oScoreId {
    if (self = [super init]) {
        self.scoreId = oScoreId;
        self.name = @"temp_score_name";
        self.startValue = 0;
        self.higherBetter = YES;

    }
    return self;
}

- (id)initWithScoreId:(NSString *)oScoreId andName:(NSString *)oName andHigherBetter:(BOOL)oHigherBetter {
    if (self = [super init]) {
        self.scoreId = oScoreId;
        self.name = oName;
        self.startValue = 0;
        self.higherBetter = oHigherBetter;
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.scoreId = dict[LU_SCORE_SCOREID];
        self.name = dict[LU_NAME];
        self.startValue = [dict[LU_SCORE_STARTVAL] doubleValue];
        self.higherBetter = [dict[LU_SCORE_HIGHBETTER] boolValue];
    }
    
    return self;
};

- (NSDictionary*)toDictionary {
    return @{
             SOOM_CLASSNAME: NSStringFromClass([self class]),
             LU_SCORE_SCOREID: self.scoreId,
             LU_NAME: self.name,
             LU_SCORE_STARTVAL: @(self.startValue),
             LU_SCORE_HIGHBETTER: @(self.higherBetter)
             };
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

