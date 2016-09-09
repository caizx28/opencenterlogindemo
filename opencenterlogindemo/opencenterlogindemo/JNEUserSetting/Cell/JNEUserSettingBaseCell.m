//
//  UserSettingBaseCell.m
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/15.
//  Copyright © 2016年 poco. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingBaseCell requires ARC support."
#endif

#import "JNEUserSettingBaseCell.h"


@interface JNEUserSettingBaseCell()

@property (nonatomic, strong) UIView *separatorLine;

@end

@implementation JNEUserSettingBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor clearColor]];
    CGFloat leftInset = 40 * LOCAL_VIEW_RATE;
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    CGFloat cellWidth = CGRectGetWidth(self.frame);
//    CGFloat labelWidth = cellWidth * 0.5;
//    CGFloat separatorLineHeight = 1;
    CGFloat separatorLineHeight = 0.5;
    [self.titleLabel sizeToFit];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    self.titleLabel.frame = CGRectMake(leftInset, cellHeight/4 + 10*ViewRateBaseOnIP6, self.titleLabel.frame.size.width, cellHeight/2.0);
    UIFont *font = [UIFont systemFontOfSize:13];
    self.titleLabel.font = font;
    self.titleLabel.frame = CGRectMake(20*ViewRateBaseOnIP6, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    [self.titleLabel setTextColor:[UIColor orangeColor]];
    self.titleLabel.alpha = 0.6;
    self.separatorLine.frame = CGRectMake(leftInset, cellHeight - separatorLineHeight, cellWidth - leftInset, separatorLineHeight);
}

- (void)configCellWithObject:(JNEUserSettingCellObject *)object {
    
    self.object = object;
    self.titleLabel.text = object.title;
    if (!object.shouldHideSeparatorLine) {
        [self addSubview:self.separatorLine];
    }
    [self setNeedsLayout];
}

#pragma mark - Setter & Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UIFont *font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = font;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRed:87.0 / 255.0 green:72.0 / 255.0 blue:75.0 / 255.0 alpha:1.0];
    }
    return _titleLabel;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.08];
    }
    return _separatorLine;
}

@end
