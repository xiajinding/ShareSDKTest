//
//  LPAPI.m
//  ShuaLian
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 EvanCai. All rights reserved.
//

#import "LPAPI.h"


@implementation LPAPI


//微信
+ (void)shareToWeChat:(ShareFrom)shareFrom image:(UIImage *)image url:(NSString *)url obj:(id)obj type:(ShareType)type view:(UIView *)view
{
    NSString *shareTitle;
    NSString *shareContent;
    NSString *shareUrl;
    id shareImage;
    switch (shareFrom) {
        case ShareInviteCode://邀请码
        {
            shareContent = @"点击领取邀请码，注册刷脸，在这里可以认识更多的老板，快来加入刷脸吧！";
            shareTitle = @"邀请您加入刷脸开启生意时代";
            UIImage *image = [UIImage imageNamed:@"icon.png"];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            shareImage = [ShareSDK imageWithData:imageData fileName:@"share" mimeType:@"jpg"];
        }
            break;
        case ShareAddWeChatFriend://加好友
        {
        }
            break;
        case ShareWeb://网页
        {
        }
            break;
            
        default:
            break;
    }

   
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareContent
                                       defaultContent:@"分享内容"
                                                image:shareImage
                                                title:shareTitle
                                                  url:shareUrl
                                          description:@"优惠券"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:view arrowDirect:UIPopoverArrowDirectionUp];
    
    
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:nil
              shareOptions:nil
             statusBarTips:NO
                   targets:nil
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
                        if (state == SSResponseStateSuccess)
                        {
                            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                        }
                        else if (state == SSResponseStateFail)
                        {
                            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                        }
                    }];

}


+ (void)textShareToWeChat:(NSString *)shareStr inView:(UIView *)view
{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:shareStr
                                       defaultContent:nil
                                                image:nil
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:view arrowDirect:UIPopoverArrowDirectionUp];
    
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiSession
               authOptions:nil
              shareOptions:nil
             statusBarTips:NO
                   targets:nil
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
                        if (state == SSResponseStateSuccess)
                        {
                            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                        }
                        else if (state == SSResponseStateFail)
                        {
                            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                        }
                    }];
}

+ (void)imageShareToWeChat:(UIImage *)shareImage inView:(UIView *)view
{
    NSData *imageData = UIImageJPEGRepresentation(shareImage, 1);
    id image = [ShareSDK imageWithData:imageData fileName:@"share" mimeType:@"jpg"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:nil
                                       defaultContent:nil
                                                image:image
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeImage];
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:view arrowDirect:UIPopoverArrowDirectionUp];
    
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeWeixiSession
               authOptions:nil
              shareOptions:nil
             statusBarTips:NO
                   targets:nil
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end){
                        if (state == SSResponseStateSuccess)
                        {
                            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                        }
                        else if (state == SSResponseStateFail)
                        {
                            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                        }
                    }];
}

@end
