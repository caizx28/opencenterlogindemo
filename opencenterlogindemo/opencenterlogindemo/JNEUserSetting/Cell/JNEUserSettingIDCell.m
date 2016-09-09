//
//  UserSettingIDCell.m
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/15.
//  Copyright © 2016年 poco. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingIDCell requires ARC support."
#endif

#import "JNEUserSettingIDCell.h"

@interface JNEUserSettingIDCell()

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation JNEUserSettingIDCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.detailLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7]];
    CGFloat rightInset = 30 * LOCAL_VIEW_RATE;
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    CGFloat labelWidth = cellWidth - CGRectGetMaxX(self.titleLabel.frame) - rightInset;
    self.detailLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, labelWidth, cellHeight);
    UIFont *font = [UIFont systemFontOfSize:17];
    self.titleLabel.font = font;
    self.titleLabel.alpha = 1.0;
    self.titleLabel.frame = CGRectMake(40*ViewRateBaseOnIP6, self.titleLabel.frame.origin.y - 10*ViewRateBaseOnIP6, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
}

- (void)configCellWithObject:(JNEUserSettingCellObject *)object {
    [super configCellWithObject:object];
    self.detailLabel.text = object.detail;
    [self setNeedsLayout];
}

#pragma mark - Setter & Getter

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UIFont *font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = font;
        _detailLabel.textAlignment = NSTextAlignmentRight;
        _detailLabel.textColor = [UIColor colorWithRed:179.0 / 255.0 green:179.0 / 255.0 blue:179.0 / 255.0 alpha:1.0];
    }
    return _detailLabel;
}

@end
