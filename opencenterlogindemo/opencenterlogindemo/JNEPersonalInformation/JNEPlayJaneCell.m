//
//  JNEPlayJaneCell.m
//  puzzleApp
//
//  Created by admin on 16/8/12.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "JNEPlayJaneCell requires ARC support."
#endif

#import "JNEPlayJaneCell.h"

@interface JNEPlayJaneCell ()

@property (nonatomic, strong) UIImageView *pnewFunctionHintImageView;
@property (nonatomic, strong) UIImageView *disclosureIndicator;

@end

@implementation JNEPlayJaneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.disclosureIndicator];
        [self.contentView addSubview:self.pnewFunctionHintImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor whiteColor]];
    CGFloat rightInset = 30 * LOCAL_VIEW_RATE;
    CGFloat indicatorWidth = 18 * LOCAL_VIEW_RATE;
    CGFloat indicatorPedding = 25 * LOCAL_VIEW_RATE;
    CGFloat pnewFunctionHintHeight = ceil(12*ViewRateBaseOnIP6);
    
    CGFloat cellHeight = CGRectGetHeight(self.frame);
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    self.disclosureIndicator.frame = CGRectMake(cellWidth - (rightInset + indicatorWidth), 0, indicatorWidth, cellHeight);
    
    self.pnewFunctionHintImageView.frame = CGRectMake((CGRectGetMinX(self.disclosureIndicator.frame)) - (pnewFunctionHintHeight + indicatorPedding), (cellHeight - pnewFunctionHintHeight) * 0.5, pnewFunctionHintHeight, pnewFunctionHintHeight);
    self.pnewFunctionHintImageView.layer.cornerRadius = ceil(pnewFunctionHintHeight * 0.5);
    self.pnewFunctionHintImageView.layer.masksToBounds = YES;
    
    UIFont *font = [UIFont systemFontOfSize:17];
    self.titleLabel.font = font;
    self.titleLabel.alpha = 1.0;
    self.titleLabel.frame = CGRectMake(40*ViewRateBaseOnIP6, self.titleLabel.frame.origin.y - 10*ViewRateBaseOnIP6, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
}

- (void)configCellWithObject:(JNEUserSettingCellObject *)object {
    [super configCellWithObject:object];
    
    BOOL ishidden = [[NSUserDefaults standardUserDefaults] boolForKey:@"playJaneKey"];
    if (ishidden) {
        self.pnewFunctionHintImageView.hidden = YES;
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

- (UIImageView *)pnewFunctionHintImageView {
    if (!_pnewFunctionHintImageView) {
        _pnewFunctionHintImageView = [[UIImageView alloc] init];
        _pnewFunctionHintImageView.image = [UIImage imageNamed:@"JNEUserSettingNewFunction"];
        _pnewFunctionHintImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pnewFunctionHintImageView;
}

@end
