//
//  JNEUserSettingSpaceCell.h
//  puzzleApp
//
//  Created by JiakaiNong on 16/3/24.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import "JNEUserSettingBaseCell.h"

@class JNEUserSettingUserSpaceCell;

@protocol JNEUserSettingUserSpaceCellDelegate <NSObject>

- (void)userSpaceCell:(JNEUserSettingUserSpaceCell *)cell didRefreshImage:(UIImage *)image;

@end

@interface JNEUserSettingUserSpaceCell : JNEUserSettingBaseCell

@property (nonatomic, weak) id<JNEUserSettingUserSpaceCellDelegate> delegate;

@end
