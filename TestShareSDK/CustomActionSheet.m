//
//  ViewController.m
//  demo
//
//  Created by mac on 14-2-24.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "CustomActionSheet.h"

#define intervalWithButtonsX 10
#define intervalWithButtonsY 30
#define buttonCountPerRow 4
#define headerHeight 20+20
#define bottomHeight 8
#define cancelButtonHeight 40


#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@implementation CustomActionSheet
@synthesize buttons;
@synthesize backgroundImageView;
@synthesize titleLabel;
@synthesize separateLabel;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithButtons:(NSArray *)buttonArray
{
    self = [super init];
    self.buttons = buttonArray;
    if (self) {
        // Initialization code
        coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        coverView.backgroundColor = [UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:0.6f];
        coverView.hidden = YES;
        coverView.userInteractionEnabled = YES;
        UIGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)];
        [coverView addGestureRecognizer:singleTap];
        
        //背景图
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"share_action_background"] stretchableImageWithLeftCapWidth:1 topCapHeight:300]];
        self.backgroundImageView.alpha = 1.0f;
        [self addSubview:self.backgroundImageView];
        
        //标题
        titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"分享到";
        titleLabel.textColor = HEXCOLOR(0x666666);
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        //分割线
        separateLabel = [[UILabel alloc]init];
        separateLabel.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        [self addSubview:separateLabel];
        
        //新建分享按钮
        for (int i = 0; i < [self.buttons count]; i++) {
            CustomActionSheetButton * button = [self.buttons objectAtIndex:i];
            button.imgButton.tag = i;
            [button.imgButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: button];
        }
        
        //取消按钮
        cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
    }
    return self;
}


-(void)dealloc
{
    self.buttons = nil;
    self.backgroundImageView = nil;
}

//设置按钮位置
-(void)setPositionInView:(UIView *)view
{
    if([self.buttons count] == 0)
    {
        return;
    }
    //获取自定义分享button的长宽
    float buttonWidth = ((CustomActionSheetButton *)[self.buttons objectAtIndex:0]).frame.size.width;
    float buttonHeight = ((CustomActionSheetButton *)[self.buttons objectAtIndex:0]).frame.size.height;
    
    //根据按钮数量设置界面大小
    self.frame = CGRectMake(0.0f, view.frame.size.height, view.frame.size.width, cancelButtonHeight + bottomHeight + headerHeight + (buttonHeight + intervalWithButtonsY)*(([self.buttons count]-1)/buttonCountPerRow + 1));
    self.backgroundImageView.frame = CGRectMake(0.0f, 0.0f, screenWidth, self.frame.size.height);
    
    //标题起始位置
    self.titleLabel.frame = CGRectMake(20.0f, 10.0f, screenWidth-40, 20);
    
    //按钮起始位置
    float beginX = 0;
    if ([self.buttons count] > buttonCountPerRow) {
        beginX = (self.frame.size.width - buttonWidth * buttonCountPerRow)/(buttonCountPerRow+1);
    }
    else{
        beginX = (self.frame.size.width - buttonWidth * [self.buttons count])/([self.buttons count]+1);
    }
    //按钮位置
    for (int i = 0; i < [self.buttons count]; i++) {
        CustomActionSheetButton * button = [self.buttons objectAtIndex:i];
        button.frame = CGRectMake(beginX + i%buttonCountPerRow*(buttonWidth + beginX),
                                  headerHeight + i/buttonCountPerRow*(buttonHeight + intervalWithButtonsY), buttonWidth, buttonHeight);
    }
    //分割线位置
    self.separateLabel.frame = CGRectMake(30,
                                          (intervalWithButtonsY + buttonHeight) * (([self.buttons count]-1)/buttonCountPerRow + 1) + headerHeight-5,
                                          screenWidth - 60, 1);
    //取消按钮位置
    cancelButton.frame = CGRectMake(beginX,
                                    (intervalWithButtonsY + buttonHeight) * (([self.buttons count]-1)/buttonCountPerRow + 1) + headerHeight,
                                    self.frame.size.width - beginX * 2, cancelButtonHeight);

}

//显示分享界面
-(void)showInView:(UIView *)view
{
    [self setPositionInView:view];
    [view addSubview:coverView];
    [view addSubview:self];
    //开始准备动画
    [UIView beginAnimations:@"ShowCustomActionSheet" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
//    self.frame = CGRectMake(0.0f, self.frame.origin.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    self.frame = CGRectMake(0.0f, screenHeight - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    coverView.hidden = NO;
    //运行动画
    [UIView commitAnimations];
}


-(void)dissmiss
{
    [UIView beginAnimations:@"DismissCustomActionSheet" context:nil];
    self.frame = CGRectMake(0.0f, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(sheetDidDismissed)];
    coverView.hidden = YES;
    [UIView commitAnimations];
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetDissmiss)]) {
        [self.delegate actionSheetDissmiss];
    }
}

-(void)sheetDidDismissed
{
    [coverView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)buttonAction:(UIButton *)button
{
    NSLog(@"index:%ld",(long)button.tag);
    [self.delegate buttonAction:button clickedButtonAtIndex:button.tag];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end


@implementation CustomActionSheetButton
@synthesize imgButton;
@synthesize titleLabel;
-(id)init
{
    if(self)
    {
        self = nil;
    }
    self = [[[NSBundle mainBundle] loadNibNamed:@"CustomActionSheetButton" owner:self options:nil] objectAtIndex:0];
    for (id obj in self.subviews) {
        if([obj isKindOfClass:[UIButton class]])
        {
            self.imgButton = obj;
        }
        else if([obj isKindOfClass:[UILabel class]])
        {
            self.titleLabel = obj;
        }
    }
    return self;
}

+(CustomActionSheetButton *)buttonWithImage:(UIImage *)image title:(NSString *)title
{
    CustomActionSheetButton * button = [[CustomActionSheetButton alloc] init];
    [button.imgButton setContentHorizontalAlignment: UIControlContentHorizontalAlignmentCenter];
    [button.imgButton setContentVerticalAlignment: UIControlContentVerticalAlignmentTop];
    [button.imgButton setImage:image forState:UIControlStateNormal];
    button.titleLabel.text = title;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = HEXCOLOR(0x999999);
    return button;
}

-(void)dealloc
{
    self.titleLabel = nil;
    self.imgButton = nil;
}
@end