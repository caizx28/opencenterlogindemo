/*
 *  UIViewController+MBProgressHUD.h
 *
 *  Created by Adam Duke on 10/20/11.
 *  Copyright 2011 appRenaissance, LLC. All rights reserved.
 *
 */

#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>

@interface UIViewController (MBProgressHUD) <MBProgressHUDDelegate>

typedef void (^HUDFinishedHandler)();

/*
 * The current instance of MBProgressHUD
 * This will allow creation of the HUD and setting
 * it's available properties before calling showHUD
 */
@property (nonatomic, readonly) MBProgressHUD *progressHUD;

/*
 * Shows an MBProgressHUD with the default spinner
 * The HUD is added as a subview to this view
 * controller's parentViewController.view.
 */
- (void)showHUD;

/*
 * Shows an MBProgressHUD with the default spinner
 * and sets the label text beneath the spinner
 * to the given message. The HUD is added as a subview
 * to this view controller's parentViewController.view.
 */
- (void)showHUDWithMessage:(NSString *)message;

- (void)showHUDWithMessage:(NSString *)message detail:(NSString*)detailString;

- (void)showWithLabelDeterminate:(NSString *)message ;

- (void)showWithCustomView:(UIView*)view;

/*
 * Dismisses the currently displayed HUD.
 */
- (void)hideHUD;

/*
 * Changes the currently displayed HUD's label text to
 * the given message and then dismisses the HUD after a
 * short delay.
 */
- (void)hideHUDWithCompletionMessage:(NSString *)message;
/*
 * Changes the currently displayed HUD's label text to
 * the given message and then dismisses the HUD after
 * the given delay.
 */
- (void)hideHUDWithCompletionMessage:(NSString *)message afterDelay:(NSTimeInterval)delay;

/*
 * Changes the currently displayed HUD's label text to
 * the given message and then dismisses the HUD after a
 * short delay. Additionally, runs the given completion
 * block after the HUD hides.
 */
- (void)hideHUDWithCompletionMessage:(NSString *)message finishedHandler:(HUDFinishedHandler)finishedHandler;

- (void)hideHUDWithCompletionMessage:(NSString *)message finishedHandler:(HUDFinishedHandler)finishedHandler  afterDelay:(NSTimeInterval)delay;

@end
