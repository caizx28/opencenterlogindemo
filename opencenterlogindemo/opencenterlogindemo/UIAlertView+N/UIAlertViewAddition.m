//
//  UIAlertViewAddition.h
//  DoubanAlbum
//
//  Created by Tonny on 12-12-10.
//  Copyright (c) 2012年 SlowsLab. All rights reserved.
//

#import "UIAlertViewAddition.h"

@implementation UIAlertView (Addition)

+(void) showAlertViewWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertView *alert  = [[[UIAlertView alloc] initWithTitle:title message:message  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

+(void)showAlertViewWithTitle:(NSString *)title message:(NSString  *)message delegete:(id)delegate cancelButtonTitle:(NSString *)cancelTitle otherTitle:(NSString *)bntTitle tag:(int)tag{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:bntTitle, nil];
    alert.tag=tag;
    [alert show];
    [alert release];
}

//+(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle
//             otherButtonTitle:(NSString *)otherButtonTitle tag:(int)tag completionBlock:(UIAlertViewBBlock)block {
//
//    UIAlertView * albert = [[UIAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelTitle otherButtonTitle:otherButtonTitle completionBlock:block];
//    albert.tag = tag;
//    [albert show];
//    [albert release];
//}


@end