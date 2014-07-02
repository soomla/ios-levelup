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

@class Score;

// TODO: Document
@interface ScoreStorage : NSObject

/** Latest Score **/

/**
 Saves a new value for the given score
 
 @param score the score to change
 @param latest the latest value to save
 */
+ (void)setLatest:(double)latest toScore:(Score*)score;

/**
 Gets the most recently saved value of the given score.
 
 @param score the score to examine
 @return the last saved value
 */
+ (double)getLatestScore:(Score *)score;


/** Record Score **/

/**
 Sets a new record for the given score.
 
 @param score the score who's record to change
 @param record the new record value
 */
+ (void)setRecord:(double)record toScore:(Score*)score;

/**
 Retrieves the record of the given score
 
 @param score the score to examine
 @return the record of the given score
 */
+ (double)getRecordScore:(Score *)score;

@end
