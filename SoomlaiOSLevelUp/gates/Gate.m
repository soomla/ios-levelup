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

#import "Gate.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"
#import "GateStorage.h"
#import "DictionaryFactory.h"
#import "BalanceGate.h"
#import "GatesListAND.h"
#import "GatesListOR.h"
#import "PurchasableGate.h"
#import "RecordGate.h"
#import "WorldCompletionGate.h"


@implementation Gate

@synthesize gateId;

static DictionaryFactory* dictionaryFactory;


- (id)initWithGateId:(NSString *)oGateId {
    self = [super init];
    if ([self class] == [Gate class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.gateId = oGateId;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if ([self class] == [Gate class]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Error, attempting to instantiate AbstractClass directly." userInfo:nil];
    }
    
    if (self) {
        self.gateId = dict[LU_GATE_GATEID];
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    return @{
             SOOM_CLASSNAME: NSStringFromClass([self class]),
             LU_GATE_GATEID: self.gateId
             };
}


// Static methods

+ (Gate *)fromDictionary:(NSDictionary *)dict {
    return (Gate *)[dictionaryFactory createObjectWithDictionary:dict];
}

+ (void)initialize {
    if (self == [Gate self]) {
        dictionaryFactory = [[DictionaryFactory alloc] init];
    }
}


@end
