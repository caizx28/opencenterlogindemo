//
//  JNEPersonCenterSettingSwitchCell.h
//  puzzleApp
//
//  Created by admin on 16/4/22.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JNEPersonCenterSettingModel;
@interface JNEPersonCenterSettingSwitchCell : UITableViewCell
@property (nonatomic,retain) JNEPersonCenterSettingModel * model;
@property (nonatomic,readonly) UISwitch * switchControl;

@end
