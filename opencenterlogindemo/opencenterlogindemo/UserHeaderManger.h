//
//  UserHeaderManger.h
//  puzzleApp
//
//  Created by admin on 14-9-26.
//  Copyright (c) 2014年 Allen Chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserHeaderManger : NSObject

+ (UserHeaderManger *)shareInstance;

- (id)init;




- (void)saveUserHeaderToLocal:(UIImage *)image;

- (UIImage*)userThumbImage;

@end
