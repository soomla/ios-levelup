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

@interface Score : NSObject {
    
    @private
    NSString*   name;
    NSString*   scoreId;
    double      startValue;
    double      tempScore;
    BOOL        higherBetter;
}

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* scoreId;
@property (nonatomic) double startValue;
@property (nonatomic) double tempScore;
@property (nonatomic) BOOL higherBetter;


- (id)initWithScoreId:(NSString *)oScoreId;

- (id)initWithScoreId:(NSString *)scoreId andName:(NSString *)oName andHigherBetter:(BOOL)oHigherBetter;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSDictionary*)toDictionary;

- (BOOL)isHigherBetter;

- (void)incBy:(double)amount;

- (void)decBy:(double)amount;

- (void)saveAndReset;

- (void)reset;

- (BOOL)hasTempScoreReached:(double)scoreVal;

- (BOOL)hasRecordReachedScore:(double)scoreVal;

- (void)performSaveActions;

- (double)getRecord;

- (double)getLatest;

// Static methods

+ (Score *)fromDictionary:(NSDictionary *)dict;

@end

