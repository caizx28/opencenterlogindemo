/*
 *  UIViewController+MBProgressHUD.m
 *
 *  Created by Adam Duke on 10/20/11.
 *  Copyright 2011 appRenaissance, LLC. All rights reserved.
 *
 */

#import "MBProgressHUD.h"
#import "UIViewController+MBProgressHUD.h"
#import <objc/runtime.h>

/* This key is used to dynamically create an instance variable
 * within the MBProgressHUD category using objc_setAssociatedObject
 */
const void *progressHUDKey = &progressHUDKey;

/* This key is used to dynamically create an instance variable
 * within the MBProgressHUD category using objc_setAssociatedObject
 */
const void *finishedHandlerKey = &finishedHandlerKey;

@interface UIViewController (MBProgressHUD_Private)

@property (nonatomic, copy) HUDFinishedHandler finishedHandler;

@end

@implementation UIViewController (MBProgressHUD_Private)

- (HUDFinishedHandler)finishedHandler
{
    HUDFinishedHandler block = objc_getAssociatedObject(self, finishedHandlerKey);
    return block;
}

- (void)setFinishedHandler:(HUDFinishedHandler)completionBlock
{
    objc_setAssociatedObject(self, finishedHandlerKey, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UIViewController (MBProgressHUD)

- (MBProgressHUD *)progressHUD
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, progressHUDKey);
    if(!hud)
    {
        UIView *hudSuperView = self.view;
        hud = [[[MBProgressHUD alloc] initWithView:hudSuperView] autorelease];
        //hud.dimBackground = YES;
        hud.removeFromSuperViewOnHide = YES;
        [hudSuperView addSubview:hud];
        self.progressHUD = hud;
    }
    return hud;
}

- (void)setProgressHUD:(MBProgressHUD *)progressHUD
{
    objc_setAssociatedObject(self, progressHUDKey, progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_showHUDWithMessage:(NSString *)message
{
    self.progressHUD.labelText = message;
    if(self.progressHUD.taskInProgress)
    {
        return;
    }
    self.progressHUD.taskInProgress = YES;
    [self.progressHUD show:YES];
}

- (void)showHUD
{
    [self _showHUDWithMessage:nil];
}

- (void)showHUDWithMessage:(NSString *)message
{
    [self _showHUDWithMessage:message];
}

- (void)showHUDWithMessage:(NSString *)message detail:(NSString*)detailString
{
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeDeterminate;
    self.progressHUD.detailsLabelText = detailString;
    if(self.progressHUD.taskInProgress)
    {
        return;
    }
    self.progressHUD.taskInProgress = YES;
    [self.progressHUD show:YES];

}

- (void)showWithLabelDeterminate:(NSString *)message
{
    self.progressHUD.labelText = message;
    if(self.progressHUD.taskInProgress)
    {
        return;
    }
    self.progressHUD.taskInProgress = YES;
    [self.progressHUD show:YES];

}


- (void)showWithCustomView:(UIView*)view
{
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    self.progressHUD.customView = view;
    if(self.progressHUD.taskInProgress)
    {
        return;
    }
    self.progressHUD.taskInProgress = YES;
    [self.progressHUD show:YES];

}

- (void)hideHUD
{
    if(!self.progressHUD.taskInProgress)
    {
        return;
    }
    self.progressHUD.taskInProgress = NO;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
}

- (void)hideHUDWithCompletionMessage:(NSString *)message afterDelay:(NSTimeInterval)delay
{
    self.progressHUD.labelText = message;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:delay];
}

- (void)hideHUDWithCompletionMessage:(NSString *)message
{
    [self hideHUDWithCompletionMessage:message afterDelay:1];
}

- (void)hideHUDWithCompletionMessage:(NSString *)message finishedHandler:(HUDFinishedHandler)finishedHandler
{
    self.progressHUD.delegate = self;
    self.finishedHandler = finishedHandler;
    [self hideHUDWithCompletionMessage:message];
}

- (void)hideHUDWithCompletionMessage:(NSString *)message finishedHandler:(HUDFinishedHandler)finishedHandler  afterDelay:(NSTimeInterval)delay {
    self.progressHUD.delegate = self;
    self.finishedHandler = finishedHandler;
    [self hideHUDWithCompletionMessage:message afterDelay:delay];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if(self.finishedHandler)
    {
        self.finishedHandler();
        self.finishedHandler = nil;
    }
    self.progressHUD.delegate = nil;
}

@end
