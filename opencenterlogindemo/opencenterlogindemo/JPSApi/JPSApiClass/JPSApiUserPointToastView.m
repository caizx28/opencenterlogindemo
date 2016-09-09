//
//  JPSApiUserPointToastView.m
//  puzzleApp
//
//  Created by admin on 16/3/21.
//  Copyright © 2016年 Allen Chen. All rights reserved.
//

#import "JPSApiUserPointToastView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error " JPSApiUserPointToastView requires ARC support."
#endif

static const NSString * JPSApiUserToastTimerKey         = @"JPSApiUserToastTimerKey";
#define kJPSApiViewRateBaseOnIP6      [UIScreen mainScreen].bounds.size.width/750.0
#define kJPSApiAppDelegate     ((AppDelegate*)TheApp.delegate)

@implementation JPSApiUserPointToastView

- (id)initWithFrame:(CGRect)frame  point:(NSString*)point  description:(NSString*)description {
    self = [super initWithFrame:frame];
    if (self) {
        
            self.frame = CGRectMake(0, 0, self.frame.size.width,  62*kJPSApiViewRateBaseOnIP6);
            UIImageView * bgView = [UIImageView new];
            bgView.backgroundColor = [UIColor blackColor];
            bgView.frame = CGRectMake(0, 0, bgView.frame.size.width,  62*kJPSApiViewRateBaseOnIP6);
            bgView.layer.cornerRadius = bgView.frame.size.height/2.0;
            [self addSubview:bgView];
    
            UILabel * descriptionLabbel = [UILabel new];
            [descriptionLabbel setBackgroundColor:[UIColor clearColor]];
            [descriptionLabbel setFont:[UIFont systemFontOfSize:18*kJPSApiViewRateBaseOnIP6]];
            [descriptionLabbel setTextAlignment:NSTextAlignmentCenter];
            [descriptionLabbel setText:description];
            [descriptionLabbel setTextColor:[UIColor whiteColor]];
            [descriptionLabbel sizeToFit];
            [self addSubview:descriptionLabbel];
    
            UILabel * pointLabbel = [UILabel new];
            [pointLabbel setBackgroundColor:[UIColor clearColor]];
            [pointLabbel setFont:[UIFont systemFontOfSize:24*kJPSApiViewRateBaseOnIP6]];
            [pointLabbel setTextAlignment:NSTextAlignmentCenter];
            [pointLabbel setTextColor:[UIColor whiteColor]];
            [pointLabbel setText:[NSString stringWithFormat:@"%@",point]];
            [pointLabbel sizeToFit];
            [self addSubview:pointLabbel];
    
            self.frame = CGRectMake(0, 0, descriptionLabbel.frame.size.width+pointLabbel.frame.size.width+48*kJPSApiViewRateBaseOnIP6+8*kJPSApiViewRateBaseOnIP6, bgView.frame.size.height);
            bgView.frame = self.frame ;
    
            descriptionLabbel.frame = CGRectMake(24*kJPSApiViewRateBaseOnIP6, (self.frame.size.height-descriptionLabbel.frame.size.height)/2.0, descriptionLabbel.frame.size.width, descriptionLabbel.frame.size.height);
        
            pointLabbel.frame = CGRectMake(CGRectGetMaxX(descriptionLabbel.frame)+8*kJPSApiViewRateBaseOnIP6, (self.frame.size.height-pointLabbel.frame.size.height)/2.0, pointLabbel.frame.size.width, pointLabbel.frame.size.height);
    }
    return self;
}

- (void)showToast {
    
    [kJPSApiAppDelegate.window addSubview:self];
    
    self.frame = CGRectMake((kJPSApiAppDelegate.window.frame.size.width-self.frame.size.width)/2.0, 188*kJPSApiViewRateBaseOnIP6, self.frame.size.width, self.frame.size.height);
    
    self.alpha = 0.0;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToastTapped:)];
    [self addGestureRecognizer:recognizer];
    self.userInteractionEnabled = YES;
    self.exclusiveTouch = YES;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(toastTimerDidFinish:) userInfo:self repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (self, &JPSApiUserToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}

- (void)showToastWithDuration:(NSTimeInterval)duration position:(CGPoint)point {
    
    [kJPSApiAppDelegate.window addSubview:self];
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
    
    self.alpha = 0.0;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToastTapped:)];
    [self addGestureRecognizer:recognizer];
    self.userInteractionEnabled = YES;
    self.exclusiveTouch = YES;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(toastTimerDidFinish:) userInfo:self repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (self, &JPSApiUserToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
    
}

- (void)toastTimerDidFinish:(NSTimer *)timer {
    [self hideToast:(UIView *)timer.userInfo];
}

- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &JPSApiUserToastTimerKey);
    [timer invalidate];
    
    [self hideToast:recognizer.view];
}

- (void)hideToast:(UIView *)toast {
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

+ (void)showToastWithPoint:(NSString*)point description:(NSString*)description {
    JPSApiUserPointToastView * toast = [[JPSApiUserPointToastView alloc]initWithFrame:CGRectZero point:point description:description];
    [toast showToast];
}

+ (void)showToastWithPoint:(NSString*)point description:(NSString*)description position:(CGPoint)position  duration:(NSTimeInterval)duration{
    JPSApiUserPointToastView * toast = [[JPSApiUserPointToastView alloc]initWithFrame:CGRectZero point:point description:description];
    [toast showToastWithDuration:duration position:position];
}

+ (void)showToastWithDescription:(NSString*)description  {
    JPSApiUserPointToastView * toast = [[JPSApiUserPointToastView alloc]initWithFrame:CGRectZero point:@"" description:description];
    [toast showToast];
}

@end
