//
//  UIAlertViewAddition.h.h
//  DoubanAlbum
//
//  Created by Tonny on 12-12-10.
//  Copyright (c) 2012年 SlowsLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIAlertView (Addition)
    
+(void) showAlertViewWithTitle:(NSString *)title message:(NSString *)message;
+(void)showAlertViewWithTitle:(NSString *)title message:(NSString  *)message delegete:(id)delegate cancelButtonTitle:(NSString *)cancelTitle otherTitle:(NSString *)bntTitle tag:(int)tag;
//+(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle
//             otherButtonTitle:(NSString *)otherButtonTitle tag:(int)tag completionBlock:(UIAlertViewBBlock)block;
@end
