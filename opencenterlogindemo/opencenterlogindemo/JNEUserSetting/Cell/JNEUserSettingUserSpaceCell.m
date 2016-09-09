//
//  JNEUserSettingSpaceCell.m
//  puzzleApp
//
//  Created by JiakaiNong on 16/3/24.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingUserSpaceCell requires ARC support."
#endif

#import "JNEUserSettingUserSpaceCell.h"
#import "JNEUserImageLoader.h"

@interface JNEUserSettingUserSpaceCell()

@property (nonatomic, strong) UIImageView *userSpaceImageView;

@end

@implementation JNEUserSettingUserSpaceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.userSpaceImageView];
        //        [self.contentView addSubview:self.userIconImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    
    self.userSpaceImageView.frame = CGRectMake(0, 0, cellWidth, cellHeight);
}

- (void)configCellWithObject:(JNEUserSettingCellObject *)object {
    [super configCellWithObject:object];
    if (!self.userSpaceImageView.superview) {
        [self.contentView addSubview:self.userSpaceImageView];
    } else {
        [JNEUserImageLoader refreshImageWithImageView:self.userSpaceImageView URLString:self.object.userSpace cacheKey:kCoverKey completion:^{
            if ([self.delegate respondsToSelector:@selector(userSpaceCell:didRefreshImage:)]) {
                [self.delegate userSpaceCell:self didRefreshImage:self.userSpaceImageView.image];
            }
        }];
    }
    [self setNeedsLayout];
}

#pragma mark - Setter & Getter

- (UIImageView *)userSpaceImageView {
    if (!_userSpaceImageView) {
        _userSpaceImageView = [JNEUserImageLoader getRefreshImageViewWithFrame:CGRectZero URLString:self.object.userSpace cacheKey:kCoverKey placeHolderImage:[UIImage imageNamed:@"JNEUserSettingCover"] completion:^{
            [JNEUserImageLoader refreshImageWithImageView:self.userSpaceImageView URLString:self.object.userSpace cacheKey:kCoverKey completion:^{
                if ([self.delegate respondsToSelector:@selector(userSpaceCell:didRefreshImage:)]) {
                    [self.delegate userSpaceCell:self didRefreshImage:self.userSpaceImageView.image];
                }
            }];
        }];
        _userSpaceImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userSpaceImageView.clipsToBounds = YES;
    }
    return _userSpaceImageView;
}

@end
