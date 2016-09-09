//
//  JNEPersonCenterSettingTableViewCell.m
//  puzzleApp
//
//  Created by admin on 16/4/22.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import "JNEPersonCenterSettingTableViewCell.h"
#import "JNEPersonCenterSettingModel.h"

@interface JNEPersonCenterSettingTableViewCell ()
@property (nonatomic,retain) UILabel * titlLabel;
@property (nonatomic,retain) UILabel * contentLabel;
@property (nonatomic,retain) UIImageView * arrowView;
@property (nonatomic,retain) UIView * bgView;
@property (nonatomic,retain) UIImageView *lineView;
@end

@implementation JNEPersonCenterSettingTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        UIView * bgView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        bgView.alpha = 0.7;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        self.bgView = bgView;
        
        UILabel *tipsLable = [[UILabel new] autorelease];
        
        [tipsLable setBackgroundColor:[UIColor clearColor]];
        [tipsLable setFont:[UIFont systemFontOfSize:30*ViewRateBaseOnIP6]];
        [tipsLable setTextAlignment:NSTextAlignmentCenter];
        
        self.titlLabel = tipsLable;
        [self addSubview:tipsLable];
        
        tipsLable = [[UILabel new] autorelease];
        //tipsLable.alpha = 0.5;
        [tipsLable setBackgroundColor:[UIColor clearColor]];
        [tipsLable setFont:[UIFont systemFontOfSize:32*ViewRateBaseOnIP6]];
        [tipsLable setTextAlignment:NSTextAlignmentCenter];
        
        self.contentLabel = tipsLable;
        [self addSubview:tipsLable];
        
        UIImageView *arrowView = [[UIImageView new] autorelease];
        [arrowView setImage:[UIImage imageNamed:@"JNEUserSettingDisclosureIndicator"]];
        arrowView.width = 14*VIEW_MATERIAL_BASE_RATE;
        arrowView.height = 28*VIEW_MATERIAL_BASE_RATE;
        [self addSubview:arrowView];
        self.arrowView = arrowView;
        
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
        
//        [self.arrowView alignToRightInSuperviewWithInset:30*ViewRateBaseOnIP6];
//        [self.arrowView centerVerticallyInSuperview];
        
        
        if ([self.model.content isKindOfClass:[NSString class]]) {
            self.contentLabel.textColor = [UIColor lightGrayColor];
            self.contentLabel.font = [UIFont systemFontOfSize:32*ViewRateBaseOnIP6];
            self.contentLabel.text = self.model.content;
            [self.contentLabel sizeToFit];
        }

        if (self.model.isHeader) {
            self.arrowView.hidden = YES;
            self.contentLabel.hidden = YES;
            self.titlLabel.textColor = [UIColor orangeColor];
            self.titlLabel.alpha = 0.8;
            self.titlLabel.font = [UIFont systemFontOfSize:25*ViewRateBaseOnIP6];
            self.titlLabel.text = self.model.title;
            [self.titlLabel sizeToFit];
//            [self.titlLabel alignToLeftInSuperviewWithInset:30*ViewRateBaseOnIP6];
//            [self.titlLabel alignToBottomInSuperviewWithInset:16*ViewRateBaseOnIP6];
            self.bgView.backgroundColor = [UIColor clearColor];
        }else {
            
            self.arrowView.hidden = NO;
            self.contentLabel.hidden = NO;
             self.titlLabel.alpha = 1.0;
            self.titlLabel.textColor = [UIColor orangeColor];
            self.titlLabel.font = [UIFont systemFontOfSize:32*ViewRateBaseOnIP6];
            self.titlLabel.text = self.model.title;
            [self.titlLabel sizeToFit];
//            [self.titlLabel alignToLeftInSuperviewWithInset:56*ViewRateBaseOnIP6];
//            [self.titlLabel centerVerticallyInSuperview];
            
//            [self.contentLabel alignToRightInSuperviewWithInset:71*ViewRateBaseOnIP6];
//            [self.contentLabel centerVerticallyInSuperview];
            self.bgView.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)dealloc {
    self.lineView = nil;
    self.bgView = nil;
    self.titlLabel = nil;
    self.contentLabel = nil;
    self.arrowView = nil;
    self.model = nil;
    [super dealloc];
}


@end
