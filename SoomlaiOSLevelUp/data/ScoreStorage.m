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

#import "ScoreStorage.h"
#import "LevelUp.h"
#import "LevelUpEventHandling.h"
#import "KeyValueStorage.h"
#import "Score.h"

@implementation ScoreStorage

/** Latest Score **/

+ (void)setLatest:(double)latest toScore:(Score*)score {
    NSString* key = [self keyLatestScoreWithScoreId:score.ID];
    NSString* val = [[NSNumber numberWithDouble:latest] stringValue];
    
    [KeyValueStorage setValue:val forKey:key];
}

+ (double)getLatestScore:(Score *)score {
    NSString* key = [self keyLatestScoreWithScoreId:score.ID];
    NSString* val = [KeyValueStorage getValueForKey:key];

    return (![val length]) ? score.startValue : [val doubleValue];
}


/** Record Score **/

+ (void)setRecord:(double)record toScore:(Score*)score {
    NSString* key = [self keyRecordScoreWithScoreId:score.ID];
    NSString* val = [[NSNumber numberWithDouble:record] stringValue];
    
    [KeyValueStorage setValue:val forKey:key];
    
    [LevelUpEventHandling postScoreRecordChanged:score];
}

+ (double)getRecordScore:(Score *)score {
    NSString* key = [self keyRecordScoreWithScoreId:score.ID];
    NSString* val = [KeyValueStorage getValueForKey:key];
    
    return (![val length]) ? score.startValue : [val doubleValue];
}


/** Private methods **/

+ (NSString *)keyScoresWithScoreId:(NSString *)scoreId andPostfix:(NSString *)postfix {
    return [NSString stringWithFormat: @"%@scores.%@.%@", LU_DB_KEY_PREFIX, scoreId, postfix];
}

+ (NSString *)keyLatestScoreWithScoreId:(NSString *)scoreId {
    return [self keyScoresWithScoreId:scoreId andPostfix:@"latest"];
}

+ (NSString *)keyRecordScoreWithScoreId:(NSString *)scoreId {
    return [self keyScoresWithScoreId:scoreId andPostfix:@"record"];
}

@end
