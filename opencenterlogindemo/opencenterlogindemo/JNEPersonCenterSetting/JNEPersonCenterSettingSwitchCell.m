//
//  JNEPersonCenterSettingSwitchCell.m
//  puzzleApp
//
//  Created by admin on 16/4/22.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import "JNEPersonCenterSettingSwitchCell.h"
#import "JNEPersonCenterSettingModel.h"


@interface JNEPersonCenterSettingSwitchCell ()
@property (nonatomic,retain) UILabel * titlLabel;
@property (nonatomic,retain) UISwitch * switchControl;
@property (nonatomic,retain) UIView * bgView;
@property (nonatomic,retain) UIImageView *lineView;
@end

@implementation JNEPersonCenterSettingSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView * bgView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
         bgView.alpha = 0.7;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        self.bgView = bgView;
        
        
        UILabel *tipsLable = [[UILabel new] autorelease];
        
        [tipsLable setBackgroundColor:[UIColor clearColor]];
        [tipsLable setFont:[UIFont systemFontOfSize:32*ViewRateBaseOnIP6]];
        [tipsLable setTextAlignment:NSTextAlignmentCenter];
        
        self.titlLabel = tipsLable;
        [self addSubview:tipsLable];
        
        UISwitch *tmpSwitch = [[[UISwitch  alloc] initWithFrame:CGRectMake(0, 0, 106*ViewRateBaseOnIP6, 70*ViewRateBaseOnIP6)] autorelease];
        tmpSwitch.onTintColor = [UIColor grayColor];
        [tmpSwitch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = tmpSwitch;
        self.switchControl = tmpSwitch;
        
        UIImageView *lineView = [[UIImageView new] autorelease];
        lineView.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.08];
        lineView.height = 0.5;
        lineView.hidden = YES;
        [self addSubview:lineView];
        self.lineView =lineView;
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    [self refresh];
}

- (void)setModel:(JNEPersonCenterSettingModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    [self refresh];
}

- (void)refresh {
    if (self.model) {
        
        self.lineView.hidden = NO;
        self.lineView.width = self.size.width-35*ViewRateBaseOnIP6*2;
//        [self.lineView centerHorizontallyInSuperview];
//        [self.lineView alignToTopInSuperviewWithInset:self.height];
        
        self.titlLabel.text = self.model.title;
        [self.titlLabel sizeToFit];
        self.titlLabel.textColor = [UIColor orangeColor];
        
//        [self.switchControl alignToRightInSuperviewWithInset:30*ViewRateBaseOnIP6];
//        [self.switchControl centerVerticallyInSuperview];
        
        if ([self.model.content isKindOfClass:[NSNumber class]]) {
            NSNumber * flag = (NSNumber*)self.model.content;
            [self.switchControl setOn:[flag boolValue] animated:NO];
        }
        
        if (self.model.isHeader) {
//            [self.titlLabel alignToLeftInSuperviewWithInset:35*ViewRateBaseOnIP6];
//            [self.titlLabel centerVerticallyInSuperview];
        }else {
//            [self.titlLabel alignToLeftInSuperviewWithInset:56*ViewRateBaseOnIP6];
//            [self.titlLabel centerVerticallyInSuperview];
        }
    }
}

- (void)dealloc {
    self.bgView = nil;
    
    self.titlLabel = nil;
    self.switchControl = nil;
    self.lineView = nil;
    self.model = nil;
    [super dealloc];
}

- (void)switchValueChange:(UISwitch*)Switch {
//    if (self.swichValueChangeBlock) {
//        self.swichValueChangeBlock(self.model,Switch);
//    }
}
@end
