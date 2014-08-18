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

#import "GatesList.h"
#import "JSONConsts.h"
#import "LUJSONConsts.h"
#import "GatesListAND.h"
#import "GatesListOR.h"
#import "DictionaryFactory.h"
#import "SoomlaUtils.h"


// TODO: Document ABSTRACT class
@implementation GatesList

@synthesize gates, autoOpenBehavior;

static NSString* TAG = @"SOOMLA GatesList";
static DictionaryFactory* dictionaryFactory;

- (id)initWithGateId:(NSString *)oGateId {
    if (self = [super initWithGateId:oGateId]) {
        self.gates = [NSMutableArray array];
        
        // "fake" gates with 1 sub-gate are auto open
        self.autoOpenBehavior = YES;
    }
    return self;
}

- (id)initWithGateId:(NSString *)oGateId andSingleGate:(Gate *)oSingleGate {
    if (self = [super initWithGateId:oGateId]) {
        self.gates = [NSMutableArray array];
        [self addGate:oSingleGate];
        
        // "fake" gates with 1 sub-gate are auto open
        self.autoOpenBehavior = YES;
    }
    
    return self;
}

- (id)initWithGateId:(NSString *)oGateId andGates:(NSArray*)oGates {
    if (self = [super initWithGateId:oGateId]) {
        self.gates = [NSMutableArray arrayWithArray:oGates];
        self.autoOpenBehavior = NO;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        
        NSMutableArray* tmpGates = [NSMutableArray array];
        NSArray* gateDicts = dict[LU_GATES];

        // Iterate over all gates in the JSON array and for each one create
        // an instance according to the gate type
        for (NSDictionary* gateDict in gateDicts) {
            
            Gate* gate = [Gate fromDictionary:gateDict];
            if (gate) {
                [tmpGates addObject:gate];
            }
        }
        
        self.gates = tmpGates;
        if ([self.gates count] < 2) {
            
            // "fake" gates with 1 sub-gate are auto open
            self.autoOpenBehavior = YES;
        } else {
            self.autoOpenBehavior = NO;
        }
    }
    
    return self;
}

- (NSDictionary*)toDictionary {
    NSDictionary* parentDict = [super toDictionary];
    
    NSMutableArray* gatesArr = [NSMutableArray array];
    for (Gate* gate in self.gates) {
        [gatesArr addObject:[gate toDictionary]];
    }
    
    NSMutableDictionary* toReturn = [[NSMutableDictionary alloc] initWithDictionary:parentDict];
    [toReturn setObject:gatesArr forKey:LU_GATES];
    
    return toReturn;
}


// Static methods

+ (GatesList *)fromDictionary:(NSDictionary *)dict {
    return (GatesList *)[dictionaryFactory createObjectWithDictionary:dict];
}

+ (void)initialize {
    if (self == [GatesList self]) {
        dictionaryFactory = [[DictionaryFactory alloc] init];
    }
}


@end
