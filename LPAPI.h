//
//  LPAPI.h
//  ShuaLian
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 EvanCai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"


typedef enum {
    ShareShop = 1,      //分享店铺
    ShareGoods = 2,     //分享商品
    ShareCoupon = 3,    //分享优惠劵
    ShareVisitCard = 4, //分享名片
    ShareGroupQrcode = 5,       //分享群二维码
    SharePersonalQrcode = 6,    //分享个人二维码
    ShareRecruitQrcode = 7,     //分享招募分店二维码
    ShareInviteCode = 8,        //分享邀请码
    ShareAddWeChatFriend = 9,   //分享添加微信好友
    ShareWeb = 10,              //分享网页
} ShareFrom;

@interface LPAPI : NSObject


/**
 *  分享到微信好友
 *
 *  @param ShareFrom    分享来源
 *  @param title        分享标题
 *  @param content      分享内容
 *  @param imageUrl     分享图片
 *  @param obj          分享对象
 */
+ (void)shareToWeChat:(ShareFrom)shareFrom image:(UIImage *)image url:(NSString *)url obj:(id)obj type:(ShareType)type view:(UIView *)view;

+ (void)textShareToWeChat:(NSString *)shareStr inView:(UIView *)view;
+ (void)imageShareToWeChat:(UIImage *)shareImage inView:(UIView *)view;


@end
