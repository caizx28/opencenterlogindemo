//
//  UserSettingAreaCell.h
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/16.
//  Copyright © 2016年 poco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JNELocationObject;

@interface JNEUserSettingAreaCell : UITableViewCell

@property (nonatomic, assign, getter = isZip) BOOL zip;
@property (nonatomic, assign, getter = isChoosen) BOOL choosen;
- (void)configCellWithObject:(JNELocationObject *)object;

@end
