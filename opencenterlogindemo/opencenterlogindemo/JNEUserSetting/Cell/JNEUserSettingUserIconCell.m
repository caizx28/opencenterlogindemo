//
//  UserSettingUserIconCell.m
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/15.
//  Copyright © 2016年 poco. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingUserIconCell requires ARC support."
#endif

#import "JNEUserSettingUserIconCell.h"
#import "JNEUserImageLoader.h"

@interface JNEUserSettingUserIconCell()

@property (nonatomic, strong) UIImageView *userIconImageView;
@property (nonatomic, strong) UIImageView *disclosureIndicator;

@end

@implementation JNEUserSettingUserIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.disclosureIndicator];
//        [self.contentView addSubview:self.userIconImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7]];
    CGFloat rightInset = 30 * LOCAL_VIEW_RATE;
    CGFloat indicatorWidth = 18 * LOCAL_VIEW_RATE;
    CGFloat indicatorPedding = 25 * LOCAL_VIEW_RATE;
    CGFloat userIconHeight = ceil(160 * LOCAL_VIEW_RATE);
    //去掉描边
//    CGFloat userIconBorderWidth = ceil(3 * LOCAL_VIEW_RATE);
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    self.disclosureIndicator.frame = CGRectMake(cellWidth - (rightInset + indicatorWidth), 0, indicatorWidth, cellHeight);
    self.userIconImageView.frame = CGRectMake((CGRectGetMinX(self.disclosureIndicator.frame)) - (userIconHeight + indicatorPedding), (cellHeight - userIconHeight) * 0.5, userIconHeight, userIconHeight);
    self.userIconImageView.layer.cornerRadius = ceil(userIconHeight * 0.5);
    //去掉描边
//    self.userIconImageView.layer.borderWidth = userIconBorderWidth;
//    self.userIconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userIconImageView.layer.masksToBounds = YES;
    UIFont *font = [UIFont systemFontOfSize:17];
    self.titleLabel.font = font;
    self.titleLabel.alpha = 1.0;
    self.titleLabel.frame = CGRectMake(40*ViewRateBaseOnIP6, self.titleLabel.frame.origin.y - 10*ViewRateBaseOnIP6, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
}

- (void)configCellWithObject:(JNEUserSettingCellObject *)object {
    [super configCellWithObject:object];
    if (!self.userIconImageView.superview) {
        [self.contentView addSubview:self.userIconImageView];
    } else {
        [JNEUserImageLoader refreshImageWithImageView:self.userIconImageView URLString:self.object.userIcon cacheKey:kHeadKey completion:nil];
    }
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

- (UIImageView *)userIconImageView {
    if (!_userIconImageView) {
        _userIconImageView = [JNEUserImageLoader getRefreshImageViewWithFrame:CGRectZero URLString:self.object.userIcon cacheKey:kHeadKey placeHolderImage:[UIImage imageNamed:@"DefaultUserHeader"] completion:nil];
        _userIconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userIconImageView;
}

@end
