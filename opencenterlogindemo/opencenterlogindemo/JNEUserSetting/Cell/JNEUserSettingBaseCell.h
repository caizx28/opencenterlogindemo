//
//  UserSettingBaseCell.h
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/15.
//  Copyright © 2016年 poco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNEUserSettingCellObject.h"

#define LOCAL_VIEW_RATE 0.5

@interface JNEUserSettingBaseCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JNEUserSettingCellObject *object;
- (void)configCellWithObject:(JNEUserSettingCellObject *)object;

@end
