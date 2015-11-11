//
//  ViewController.m
//  TestShareSDK
//
//  Created by Lemon on 15/11/11.
//  Copyright © 2015年 LemonXia. All rights reserved.
//

#import "ViewController.h"
//ShareSDK头文件
#import <ShareSDK/ShareSDK.h>
#import "CustomActionSheet.h"
#import "LPAPI.h"

@interface ViewController ()<UIAlertViewDelegate,CustomActionSheetDelegate,UIActionSheetDelegate>
{
    CustomActionSheet *actionSheet;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加测试按钮
 
    [self addButtonWithName:NSLocalizedString(@"分享", nil) action:@selector(customizeShareContent:) index:0];
    [self addButtonWithName:NSLocalizedString(@"自定义", nil) action:@selector(shareInviteCode) index:1];
 
}

- (void)addButtonWithName:(NSString *)buttonName action:(SEL)action index:(NSInteger)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:buttonName forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.frame = CGRectMake(self.view.frame.size.width/2 - 150 , 50 + index * 50, 300, 40);
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}



// 自定义分享容器
- (void)customizeShareContent:(id)sender
{
    //1、构造分享内容
    //1.1、要分享的图片（以下分别是网络图片和本地图片的生成方式的示例）
    id<ISSCAttachment> remoteAttachment = [ShareSDKCoreService attachmentWithUrl:@"http://f.hiphotos.bdimg.com/album/w%3D2048/sign=df8f1fe50dd79123e0e09374990c5882/cf1b9d16fdfaaf51e6d1ce528d5494eef01f7a28.jpg"];
    //    id<ISSCAttachment> localAttachment = [ShareSDKCoreService attachmentWithPath:[[NSBundle mainBundle] pathForResource:@"shareImg" ofType:@"png"]];
    
    //1.2、以下参数分别对应：内容、默认内容、图片、标题、链接、描述、分享类型
    id<ISSContent> publishContent = [ShareSDK content:@"Test content of ShareSDK"
                                       defaultContent:nil
                                                image:remoteAttachment
                                                title:@"test title"
                                                  url:@"http://www.mob.com"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //1.3、自定义各个平台的分享内容(非必要)
    [self customizePlatformShareContent:publishContent];
    
    //1.4、自定义一个分享菜单项(非必要)
    id<ISSShareActionSheetItem> customItem = [ShareSDK shareActionSheetItemWithTitle:@"Custom"
                                                                                icon:[UIImage imageNamed:@"Icon.png"]
                                                                        clickHandler:^{
                                                                            UIAlertController *alert = [UIAlertController
                                                                                                        alertControllerWithTitle:@"Custom item"
                                                                                                        message:@"Custom item has been clicked"
                                                                                                                 
                                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                                                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                                                             style:UIAlertActionStyleDefault handler:nil];
                                                                            [alert addAction:action];
                                                                            [self presentViewController:alert animated:YES completion:nil];
                                                                        }];
    //1.5、分享菜单栏选项排列位置和数组元素index相关(非必要)
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeFacebook),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeSMS),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          SHARE_TYPE_NUMBER(ShareTypeCopy),
                          customItem,nil];
    
    //1+、创建弹出菜单容器（iPad应用必要，iPhone应用非必要）
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //2、展现分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:NO
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                NSLog(@"=== response state :%zi ",state);
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertController *alert = [UIAlertController
                                                                alertControllerWithTitle:@"Success"
                                                                message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                     style:UIAlertActionStyleDefault handler:nil];
                                    [alert addAction:action];
                                    [self presentViewController:alert animated:YES completion:nil];
                                    
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertController *alert = [UIAlertController
                                                                alertControllerWithTitle:@"Failed"
                                                                message:[NSString stringWithFormat:@"Error Description：%@",[error errorDescription]]
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                                                     style:UIAlertActionStyleDefault handler:nil];
                                    [alert addAction:action];
                                    [self presentViewController:alert animated:YES completion:nil];
                                
                                }
                            }];
}

- (void)customizePlatformShareContent:(id<ISSContent>)publishContent
{
    //定制QQ空间分享内容
    [publishContent addQQSpaceUnitWithTitle:@"The title of QQ Space."
                                        url:@"http://www.mob.com"
                                       site:nil
                                    fromUrl:nil
                                    comment:@"comment"
                                    summary:@"summary"
                                      image:nil
                                       type:@(4)
                                    playUrl:nil
                                       nswb:0];
    
    //定制邮件分享内容
    [publishContent addMailUnitWithSubject:@"The subject of Mail"
                                   content:@"The content of Mail."
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:nil
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    //定制新浪微博分享内容
    id<ISSCAttachment> localAttachment = [ShareSDKCoreService attachmentWithPath:[[NSBundle mainBundle] pathForResource:@"shareImg" ofType:@"png"]];
    [publishContent addSinaWeiboUnitWithContent:@"The content of Sina Weibo" image:localAttachment];
}
- (void)shareInviteCode {
    [self initCustomActionSheet];
    [actionSheet showInView:self.view];
    
}
#pragma mark - initCustomActionSheet
- (void)initCustomActionSheet {
    //    创建自定义actionsh eet
    actionSheet = [[CustomActionSheet alloc] initWithButtons:[NSArray arrayWithObjects:
                                                              [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_to_weixin_friends"] title:@"微信"],
                                                              [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"share_to_friends_circle"] title:@"朋友圈"],
                                                              [CustomActionSheetButton buttonWithImage:[UIImage imageNamed:@"copy_link"] title:@"复制链接"],
                                                              nil]];
    actionSheet.delegate =self;
}

- (void)buttonAction:(UIButton *)button  clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            [LPAPI shareToWeChat:8 image:nil url:nil obj:nil type:ShareTypeWeixiSession view:self.view];
            [actionSheet dissmiss];
        }
            break;
        case 1:
        {
            [LPAPI shareToWeChat:8 image:nil url:nil obj:nil type:ShareTypeWeixiTimeline view:self.view];
            [actionSheet dissmiss];
        }
            break;
        case 2:
        {
            
            [actionSheet dissmiss];
        }
            break;
        default:
            break;
    }
}

@end
