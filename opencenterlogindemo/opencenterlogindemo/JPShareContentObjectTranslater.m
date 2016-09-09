//
//  JPShareContentObjectTranslater.m
//  JanePlus
//
//  Created by admin on 15/12/21.
//  Copyright © 2015年 beautyInformation. All rights reserved.
//

#import "JPShareContentObjectTranslater.h"
#import "JPShareContentObject.h"

@implementation JPShareBaseObjectTranslater

- (JPShareContentObject*)tranlateWithContentObject:(JPShareContentObject*)contentObject {
    switch (contentObject.type) {
        case JPShareTypeInstagram:{
            if (contentObject.mediaType == ShareWeb) {
                contentObject.shareContent = [NSString stringWithFormat:@"%@ ~%@",contentObject.shareContent,contentObject.shareURL];
            }
            break;
        }
        case JPShareTypeWechatTimeline: {
            contentObject.Title = [NSString stringWithFormat:@"%@",contentObject.shareContent];
            break;
        }
        case JPShareTypeWechatSession: {
            NSString * title = contentObject.Title;
            if(title == nil){
                title = @"";
            }
            contentObject.Title = title;
             break;
        }
        case JPShareTypeSina:{
            if (contentObject.mediaType == ShareWeb) {
                contentObject.shareContent = [NSString stringWithFormat:@"%@ %@ ~ %@",contentObject.shareContent,contentObject.shareURL,@"#简拼#"];
            }else {
                if (!contentObject.shareURL) {
                    NSString * shareURL  = AboutDefaultShareUrl;
                    contentObject.shareContent = [NSString stringWithFormat:@"%@ %@ ~ %@",contentObject.shareContent,shareURL,@"#简拼#"];
                }
            }
            break;
        }
        case JPShareTypeTwitter:{
            if (contentObject.mediaType == ShareWeb) {
                contentObject.shareContent = [NSString stringWithFormat:@"%@ ~ %@",contentObject.shareContent,contentObject.shareURL];
            }
            break;
        }
        case JPShareTypeQQZone:
        case JPShareTypeQQ:{
            NSString * title = contentObject.Title;
            if(title == nil||[title isEqualToString:@""]){
                title = @"来自简拼";
            }
            contentObject.Title = title;
            break;
        }
        case JPShareTypeFaceBook:
        default:
            break;
    }
    return contentObject;
}

@end

@implementation JPShareContentObjectAppRecommondTranslater

- (JPShareContentObject*)tranlateWithContentObject:(JPShareContentObject*)contentObject {
    switch (contentObject.type) {
        case JPShareTypeInstagram:{
            if (contentObject.mediaType == ShareWeb) {
                contentObject.shareContent = [NSString stringWithFormat:@"%@ ~ %@",contentObject.shareContent,contentObject.shareURL];
            }
            break;
        }
        case JPShareTypeWechatTimeline: {
            contentObject.Title = [NSString stringWithFormat:@"%@",contentObject.shareContent];
            break;
        }
        case JPShareTypeWechatSession: {
            NSString * title = contentObject.Title;
            if(title == nil){
                title = @"";
            }
            contentObject.Title = title;
             break;
        }
        case JPShareTypeSina:{
            if (contentObject.mediaType == ShareWeb) {
                contentObject.shareContent = [NSString stringWithFormat:@"%@ ~ %@",contentObject.shareContent,contentObject.shareURL];
            }
            break;
        }
        case JPShareTypeTwitter:{
            if (contentObject.mediaType == ShareWeb) {
                contentObject.shareContent = [NSString stringWithFormat:@"%@ ~ %@",contentObject.shareContent,contentObject.shareURL];
            }
            break;
        }
        case JPShareTypeQQZone:
        case JPShareTypeQQ:{
            
            NSString * title = contentObject.Title;
            if(title == nil||[title isEqualToString:@""]){
                title = @"来自简拼";
            }
            contentObject.Title = title;
            break;
        }
        case JPShareTypeFaceBook:
        default:
            break;
    }
    return contentObject;
}
@end

