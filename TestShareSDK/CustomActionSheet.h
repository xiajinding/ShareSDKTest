//
//  ViewController.m
//  demo
//
//  Created by mac on 14-2-24.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomActionSheetDelegate <NSObject>
@optional
-(void)choseAtIndex:(int)index;
- (void)buttonAction:(UIButton *)button  clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)actionSheetDissmiss;

@end

@interface CustomActionSheet : UIView<UIActionSheetDelegate,CustomActionSheetDelegate>
{
    UIButton * cancelButton;
    UIView * coverView;
}
@property(nonatomic,strong)NSArray * buttons;
@property(nonatomic,strong)UIImageView * backgroundImageView;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)UILabel *separateLabel;
@property(nonatomic,assign)id<CustomActionSheetDelegate,UIActionSheetDelegate> delegate;
- (id)initWithButtons:(NSArray *)buttons;
-(void)showInView:(UIView *)view;
-(void)dissmiss;
@end


@interface CustomActionSheetButton : UIView
@property(nonatomic,strong)UIButton * imgButton;
@property(nonatomic,strong)UILabel * titleLabel;
+(CustomActionSheetButton *)buttonWithImage:(UIImage *)image title:(NSString *)title;
@end