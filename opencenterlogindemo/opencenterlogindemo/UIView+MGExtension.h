//
//  UIView+MGExtension.h
//  xiomeiBGMtest
//
//  Created by 蔡宗杏 on 16/8/14.
//  Copyright © 2016年 蔡宗杏. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class CALayer,DMPageView;
@interface UIView (MGExtension)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */


/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */


/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */


/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */

/**
 * Shortcut for layer.transfrom
 */


-(void)removeAllSubviews;
-(void)removeViewWithTag:(NSInteger)tag;
-(void)removeViewWithTags:(NSArray *)tagArray;
-(void)removeViewWithTagLessThan:(NSInteger)tag;
-(void)removeViewWithTagGreaterThan:(NSInteger)tag;
- (UIViewController *)selfViewController;
-(UIView *)subviewWithTag:(NSInteger)tag;


@end
