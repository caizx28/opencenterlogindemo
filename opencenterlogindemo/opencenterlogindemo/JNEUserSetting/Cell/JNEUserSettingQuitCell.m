//
//  UserSettingQuitCell.m
//  NJKUserSettingDemo
//
//  Created by JiakaiNong on 16/3/16.
//  Copyright © 2016年 poco. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEUserSettingQuitCell requires ARC support."
#endif

#import "JNEUserSettingQuitCell.h"

#define LOCAL_VIEW_RATE 0.5

@interface JNEUserSettingQuitCell()

@property (nonatomic, strong) UILabel *quitLabel;

@end

@implementation JNEUserSettingQuitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.quitLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.quitLabel sizeToFit];
    self.quitLabel.center = self.contentView.center;
}

#pragma mark - Setter & Getter

- (UILabel *)quitLabel {
    if (!_quitLabel) {
        UIFont *font = [UIFont systemFontOfSize:34 * LOCAL_VIEW_RATE];
        _quitLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _quitLabel.font = font;
        _quitLabel.text = NSLocalizedString(@"退出登录",nil);
        _quitLabel.textAlignment = NSTextAlignmentCenter;
        _quitLabel.textColor = [UIColor colorWithRed:92.0 / 255.0 green:89.0 / 255.0 blue:89.0 / 255.0 alpha:1];
    }
    return _quitLabel;
}

@end
