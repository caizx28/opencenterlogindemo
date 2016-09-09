//
//  JPSApiSequencer.h
//  JanePlus
//
//  Created by admin on 16/2/25.
//  Copyright © 2016年 beautyInformation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JPSApiSequencerCompletion)(id result,NSError * error);
typedef void(^JPSApiSequencerStep)(id result, JPSApiSequencerCompletion completion);

@interface JPSApiSequencer : NSObject
@property (nonatomic,retain) NSMutableArray * operations;
- (void)run;
- (void)cancel;
- (void)enqueueStep:(JPSApiSequencerStep)step;

@end
