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

@implementation ScoreStorage

static NSString *DB_SCORE_KEY_PREFIX;

+(void)initialize {
    DB_SCORE_KEY_PREFIX = [NSString stringWithFormat:@"%@scores.", LU_DB_KEY_PREFIX];
}

/** Latest Score **/

+ (void)setLatest:(double)latest toScore:(NSString *)scoreId {
    [self setLatest:latest toScore:scoreId andNotify:YES];
}
+ (void)setLatest:(double)latest toScore:(NSString *)scoreId andNotify:(BOOL)notify {
    NSString* key = [self keyLatestScoreWithScoreId:scoreId];
    NSString* val = [[NSNumber numberWithDouble:latest] stringValue];
    
    [KeyValueStorage setValue:val forKey:key];
    
    if (notify) {
        [LevelUpEventHandling postScoreLatestChanged:scoreId];
    }
}

+ (double)getLatestScore:(NSString *)scoreId {
    NSString* key = [self keyLatestScoreWithScoreId:scoreId];
    NSString* val = [KeyValueStorage getValueForKey:key];

    return (![val length]) ? -1 : [val doubleValue];
}


/** Record Score **/

+ (void)setRecord:(double)record toScore:(NSString *)scoreId {
    [self setRecord:record toScore:scoreId andNotify:YES];
}

+ (void)setRecord:(double)record toScore:(NSString *)scoreId andNotify:(BOOL)notify {
    NSString* key = [self keyRecordScoreWithScoreId:scoreId];
    NSString* val = [[NSNumber numberWithDouble:record] stringValue];
    
    [KeyValueStorage setValue:val forKey:key];
    
    if (notify) {
        [LevelUpEventHandling postScoreRecordChanged:scoreId];
    }
}

+ (double)getRecordScore:(NSString *)scoreId {
    NSString* key = [self keyRecordScoreWithScoreId:scoreId];
    NSString* val = [KeyValueStorage getValueForKey:key];
    
    return (![val length]) ? -1 : [val doubleValue];
}

+ (NSString *)keyScorePrefix {
    return DB_SCORE_KEY_PREFIX;
}


/** Private methods **/

+ (NSString *)keyScoresWithScoreId:(NSString *)scoreId andPostfix:(NSString *)postfix {
    return [NSString stringWithFormat: @"%@%@.%@", DB_SCORE_KEY_PREFIX, scoreId, postfix];
}

+ (NSString *)keyLatestScoreWithScoreId:(NSString *)scoreId {
    return [self keyScoresWithScoreId:scoreId andPostfix:@"latest"];
}

+ (NSString *)keyRecordScoreWithScoreId:(NSString *)scoreId {
    return [self keyScoresWithScoreId:scoreId andPostfix:@"record"];
}

@end
