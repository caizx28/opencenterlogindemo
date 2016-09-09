//
//  JPSApiSequencer.m
//  JanePlus
//
//  Created by admin on 16/2/25.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import "JPSApiSequencer.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error " JPSApiSequencer (JPSApi_EasyCopy) requires ARC support."
#endif

@interface JPSApiSequencer ()
@property (nonatomic, strong) NSMutableArray *steps;
@end

@implementation JPSApiSequencer

- (NSMutableArray *)operations {
    if (!_operations) {
        _operations = [NSMutableArray new];
    }
    return _operations;
}

- (NSMutableArray *)steps {
    if (!_steps) {
        _steps = [NSMutableArray new];
    }
    return _steps;
}

- (void)run
{
    [self runNextStepWithResult:nil error:nil];
}

- (void)enqueueStep:(JPSApiSequencerStep)step
{
    [self.steps addObject:[step copy]];
}

- (JPSApiSequencerStep)dequeueNextStep
{
    JPSApiSequencerStep step = [self.steps objectAtIndex:0];
    [self.steps removeObjectAtIndex:0];
    return step;
}

- (void)runNextStepWithResult:(id)result  error:(NSError*)error
{
    if ([self.steps count] <= 0) {
        return;
    }
    
    JPSApiSequencerStep step = [self dequeueNextStep];
    
    step(result, ^(id nextRresult,NSError * error){
        [self runNextStepWithResult:nextRresult error:error];
    });
}

- (void)cancel {
    [self.steps removeAllObjects];
}

@end
