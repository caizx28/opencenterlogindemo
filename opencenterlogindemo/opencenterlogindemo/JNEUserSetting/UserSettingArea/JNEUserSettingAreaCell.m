//
//  UserSettingAreaCell.m
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/16.
//  Copyright © 2016年 poco. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingAreaCell requires ARC support."
#endif

#import "JNEUserSettingAreaCell.h"

#define LOCAL_VIEW_RATE 0.5

@interface JNEUserSettingAreaCell()

@property (nonatomic, strong) UILabel *areaNameLabel;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIImageView *disclosureIndicator;
@property (nonatomic, strong) UIImageView *chechMark;

@end

@implementation JNEUserSettingAreaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.separatorLine];
        [self.contentView addSubview:self.areaNameLabel];
        [self.contentView addSubview:self.disclosureIndicator];
        [self.contentView addSubview:self.chechMark];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat rightInset = 30 * LOCAL_VIEW_RATE;
    CGFloat indicatorWidth = 18 * LOCAL_VIEW_RATE;
    CGFloat checkMarkWidth = 42 * LOCAL_VIEW_RATE;
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    CGFloat leftInset = 40 * LOCAL_VIEW_RATE;
    CGFloat labelWidth = cellWidth - (rightInset + checkMarkWidth);
    CGFloat separatorLineHeight = 0.5;
    
    self.areaNameLabel.frame = CGRectMake(leftInset, 0, labelWidth, cellHeight);
    self.separatorLine.frame = CGRectMake(leftInset, cellHeight - separatorLineHeight, cellWidth - leftInset, separatorLineHeight);
    self.disclosureIndicator.frame = CGRectMake(cellWidth - (rightInset + indicatorWidth), 0, indicatorWidth, cellHeight);
    self.disclosureIndicator.hidden = !self.isZip;
    self.chechMark.frame = CGRectMake(cellWidth - (rightInset + checkMarkWidth), 0, checkMarkWidth, cellHeight);
    self.chechMark.hidden = !(self.isChoosen && !self.isZip);
}

- (void)configCellWithObject:(JNELocationObject *)object {
//    self.areaNameLabel.text = object.locationName;
//    self.zip = (BOOL)object.child.count;
    [self setNeedsLayout];
}

#pragma mark - Setter & Getter

- (UIImageView *)disclosureIndicator {
    if (!_disclosureIndicator) {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.image = [UIImage imageNamed:@"JNEUserSettingDisclosureIndicator"];
        _disclosureIndicator.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _disclosureIndicator;
}

- (UIImageView *)chechMark {
    if (!_chechMark) {
        _chechMark = [[UIImageView alloc] init];
        _chechMark.image = [UIImage imageNamed:@"JNEUserSettingCheckMark"];
        _chechMark.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _chechMark;
}

- (UILabel *)areaNameLabel {
    if (!_areaNameLabel) {
        UIFont *font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
        _areaNameLabel = [[UILabel alloc] init];
        _areaNameLabel.font = font;
        _areaNameLabel.textAlignment = NSTextAlignmentLeft;
        _areaNameLabel.textColor = [UIColor colorWithRed:87.0 / 255.0 green:72.0 / 255.0 blue:75.0 / 255.0 alpha:1.0];
    }
    return _areaNameLabel;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.08];
    }
    return _separatorLine;
}

@end
