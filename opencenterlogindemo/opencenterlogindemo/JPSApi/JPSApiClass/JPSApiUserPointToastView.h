//
//  JPSApiUserPointToastView.h
//  puzzleApp
//
//  Created by admin on 16/3/21.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPSApiUserPointToastView : UIView

- (id)initWithFrame:(CGRect)frame  point:(NSString*)point  description:(NSString*)description ;
- (void)showToast;
- (void)showToastWithDuration:(NSTimeInterval)duration position:(CGPoint)point;

+ (void)showToastWithPoint:(NSString*)point description:(NSString*)description ;
+ (void)showToastWithPoint:(NSString*)point description:(NSString*)description position:(CGPoint)position  duration:(NSTimeInterval)duration;
+ (void)showToastWithDescription:(NSString*)description ;
@end
