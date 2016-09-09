//
//  JPShareConstant.m
//  JanePlus
//
//  Created by admin on 15/8/21.
//  Copyright (c) 2015年 Allen Chen. All rights reserved.
//

#import "JPShareConstant.h"


@implementation JPShareConstant

+ (UIImage *)resizeThumImage:(UIImage *)image{
    CGSize sizetmp= image.size;

    if (sizetmp.width>640||sizetmp.height>640) {
        sizetmp.width = sizetmp.width / 3;
        sizetmp.height = sizetmp.height/3;
        
    }else{
        sizetmp.width = sizetmp.width / 2;
        sizetmp.height = sizetmp.height/2;
    }
    
    sizetmp.width = sizetmp.width *0.9;
    sizetmp.height = sizetmp.height*0.9;

//    UIImage * min_img= [image resizedImage:sizetmp interpolationQuality:kCGInterpolationDefault];
    return image;
}

@end
