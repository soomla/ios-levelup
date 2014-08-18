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

#import "RangeScore.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"


@implementation Range

@synthesize low, high;

- (id)initWithLow:(double)oLow andHigh:(double)oHigh {
    if (self = [super init]) {
        self.low = oLow;
        self.high = oHigh;
        if (self.low >= self.high) {
            @throw [NSException exceptionWithName:NSRangeException
                                           reason:@"Error, range low value can't be equal or higher than high value." userInfo:nil];
        }
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.low = [dict[LU_SCORE_RANGE_LOW] doubleValue];
        self.high = [dict[LU_SCORE_RANGE_HIGH] doubleValue];
        if (self.low >= self.high) {
            @throw [NSException exceptionWithName:NSRangeException
                                           reason:@"Error, range low value can't be equal or higher than high value." userInfo:nil];
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    return @{
             LU_SCORE_RANGE_LOW: @(self.low),
             LU_SCORE_RANGE_HIGH: @(self.high)
             };
}


@end





@implementation RangeScore

@synthesize range;

- (id)initWithScoreId:(NSString *)oScoreId andRange:(Range *)oRange {
    if (self = [super initWithScoreId:oScoreId]) {
        self.range = oRange;
    }
    return self;
}

- (id)initWithScoreId:(NSString *)oScoreId andName:(NSString *)oName andHigherBetter:(BOOL)oHigherBetter andRange:(Range *)oRange {
    if (self = [super initWithScoreId:oScoreId andName:oName andHigherBetter:oHigherBetter]) {
        self.range = oRange;
        
        // if the score is descending, the start value should be
        // the high value, otherwise it's very confusing that the initial
        // score is the lowest
        if (!self.higherBetter) {
            self.startValue = range.high;
        }
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.scoreId = dict[LU_SCORE_SCOREID];
        self.name = dict[LU_NAME];
        self.higherBetter = [dict[LU_SCORE_HIGHBETTER] boolValue];
        self.range = [[Range alloc] initWithDictionary:dict[LU_SCORE_RANGE]];

        // if the score is descending, the start value should be
        // the high value, otherwise it's very confusing that the initial
        // score is the lowest
        if (!self.higherBetter) {
            self.startValue = range.high;
        }
    }
    return self;
}
    
- (NSDictionary*)toDictionary {
    NSDictionary* parent = [super toDictionary];
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parent];
    [toReturn setObject:[self.range toDictionary] forKey:LU_SCORE_RANGE];
    return toReturn;
}

@end
