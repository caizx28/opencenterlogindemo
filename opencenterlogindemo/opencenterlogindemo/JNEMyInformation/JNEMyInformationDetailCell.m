//
//  JNEMyInformationDetailCell.m
//  puzzleApp
//
//  Created by admin on 16/8/24.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEMyInformationDetailCell requires ARC support."
#endif

#import "JNEMyInformationDetailCell.h"

@interface JNEMyInformationDetailCell ()
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *disclosureIndicator;
@end

@implementation JNEMyInformationDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.disclosureIndicator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7]];
    CGFloat rightInset = 30 * LOCAL_VIEW_RATE;
    CGFloat indicatorWidth = 18 * LOCAL_VIEW_RATE;
    CGFloat indicatorPedding = 25 * LOCAL_VIEW_RATE;
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    self.disclosureIndicator.frame = CGRectMake(cellWidth - (rightInset + indicatorWidth), 0, indicatorWidth, cellHeight);
    CGFloat labelWidth = CGRectGetMinX(self.disclosureIndicator.frame) - CGRectGetMaxX(self.titleLabel.frame) - indicatorPedding;
    self.detailLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, labelWidth, cellHeight);
    UIFont *font = [UIFont systemFontOfSize:17];
    self.titleLabel.font = font;
    self.titleLabel.frame = CGRectMake(40*ViewRateBaseOnIP6, self.titleLabel.frame.origin.y - 10*ViewRateBaseOnIP6, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    self.titleLabel.alpha = 1.0;
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

- (UIImageView *)disclosureIndicator {
    if (!_disclosureIndicator) {
        _disclosureIndicator = [[UIImageView alloc] init];
        _disclosureIndicator.image = [UIImage imageNamed:@"JNEUserSettingDisclosureIndicator"];
        _disclosureIndicator.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _disclosureIndicator;
}



@end

