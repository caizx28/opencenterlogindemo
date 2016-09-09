//
//  JNEPersonalInformationCell.m
//  puzzleApp
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEPersonalInformationCell requires ARC support."
#endif

#import "JNEPersonalInformationCell.h"
#import "JNEUserImageLoader.h"

@interface JNEPersonalInformationCell()

@property (nonatomic, strong) UIImageView *userIconImageView;
@property (nonatomic, strong) UIImageView *disclosureIndicator;

@end

@implementation JNEPersonalInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.disclosureIndicator];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor whiteColor]];
    CGFloat rightInset = 30 * LOCAL_VIEW_RATE;
    CGFloat indicatorWidth = 18 * LOCAL_VIEW_RATE;
    CGFloat indicatorPedding = 25 * LOCAL_VIEW_RATE;
    CGFloat userIconHeight = ceil(120*ViewRateBaseOnIP6);
    //去掉描边
    //    CGFloat userIconBorderWidth = ceil(3 * LOCAL_VIEW_RATE);
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    self.disclosureIndicator.frame = CGRectMake(cellWidth - (rightInset + indicatorWidth), 0, indicatorWidth, cellHeight);
    self.userIconImageView.frame = CGRectMake(20*ViewRateBaseOnIP6, (cellHeight - userIconHeight) * 0.5, userIconHeight, userIconHeight);
    self.userIconImageView.layer.cornerRadius = ceil(userIconHeight * 0.5);
    //去掉描边
    //    self.userIconImageView.layer.borderWidth = userIconBorderWidth;
    //    self.userIconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userIconImageView.layer.masksToBounds = YES;
    self.titleLabel.frame = CGRectMake(self.userIconImageView.frame.origin.x + self.userIconImageView.frame.size.width + indicatorPedding,self.titleLabel.frame.origin.y - 10*ViewRateBaseOnIP6,self.titleLabel.frame.size.width,self.titleLabel.frame.size.height);
    UIFont *font = [UIFont systemFontOfSize:17];
    self.titleLabel.font = font;
    self.titleLabel.alpha = 1.0;
}

- (void)configCellWithObject:(JNEUserSettingCellObject *)object {
    [super configCellWithObject:object];
    if (!self.userIconImageView.superview) {
        [self.contentView addSubview:self.userIconImageView];
    } else {
        NSLog(@"self.object.userIcon:%@",self.object.userIcon);
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
