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


@interface Range : Score {
    
    @private
    double low;
    double high;
}

@property (nonatomic) double low;
@property (nonatomic) double high;

- (id)initWithLow:(double)oLow andHigh:(double)oHigh;

@end





@interface RangeScore : Score {
    
    @private
    Range* range;
}


@property (strong, nonatomic) Range* range;


- (id)initWithScoreId:(NSString *)oScoreId andRange:(Range *)oRange;

- (id)initWithScoreId:(NSString *)oScoreId andName:(NSString *)oName andHigherBetter:(BOOL)oHigherBetter andRange:(Range *)oRange;

@end


