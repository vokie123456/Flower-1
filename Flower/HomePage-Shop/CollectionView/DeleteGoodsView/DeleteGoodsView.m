//
//  DeleteGoodsVC.m
//  Test
//
//  Created by Jonathan Lu on 2018/7/25.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "DeleteGoodsView.h"
#import "UIColor+Util.h"
#import "UIView+frameAdjust.h"
#import "TotalFlowerMNG.h"
#define TitleBackGround_COLOR [UIColor colorWithRed:(218 / 255.0) green:(63 / 255.0) blue:(61 / 255.0) alpha:1]
#define ContentViewBackGround_COLOR [UIColor colorWithRed:(246  / 255.0) green:(246 / 255.0) blue:(246 / 255.0) alpha:1]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface DeleteGoodsView()
/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;
/** 弹窗标题 */
@property (nonatomic,copy)   NSString *title;

@property (nonatomic,copy)   NSString *goodName;



@end

@implementation DeleteGoodsView

- (instancetype)initWithGoodName:(NSString *)goodName delegate:(id)delegate{
    if (self = [super init]) {
        
        self.delegate = delegate;

        self.goodName=goodName;
    }
    

    // 接收键盘显示隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // UI搭建
    [self setUpUI];
    
    return self;
}
- (void)setUpUI{
    
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.75];
    [self showAnimation];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake((SCREEN_WIDTH - 285) / 2, 150, 285, 215);
    
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = ContentViewBackGround_COLOR;
    self.contentView.layer.cornerRadius = 6;
    
    // 标题
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, 42)];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.contentView.width, 22)];
    [self.contentView addSubview:view];
    [view addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"删除提示";
    
    /*提示label*/
    self.tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(22, titleLabel.maxY +20, self.contentView.width-44, 72)];
    [self.contentView addSubview:self.tipLabel];
    self.tipLabel.textAlignment=NSTextAlignmentCenter;
    self.tipLabel.text=[NSString stringWithFormat:@"确定要删除“%@”的愿望吗？",self.goodName];
    self.tipLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.tipLabel.numberOfLines = 0;
    
    // 确认按钮
    UIButton *abnormalButton = [[UIButton alloc]initWithFrame:CGRectMake(0,self.contentView.bounds.origin.y+215-40+1.5, self.contentView.bounds.size.width/2, 41)];
    [self.contentView addSubview:abnormalButton];
    abnormalButton.backgroundColor = [UIColor colorWithHexString:@"d51619"];
    [abnormalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [abnormalButton setTitle:@"确定删除" forState:UIControlStateNormal];
    [abnormalButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:abnormalButton.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = abnormalButton.bounds;
    maskLayer1.path = maskPath1.CGPath;
    abnormalButton.layer.mask = maskLayer1;
    [abnormalButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 取消按钮
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.bounds.size.width/2, abnormalButton.minY, self.contentView.bounds.size.width/2, 41)];
    [self.contentView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:cancelButton.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = cancelButton.bounds;
    maskLayer2.path = maskPath2.CGPath;
    cancelButton.layer.mask = maskLayer2;
    
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //------- 调整弹窗高度和中心 -------//
    //    self.contentView.height = 300;
    //    self.contentView.center = self.center;
    
    
    
    
    
}
#pragma mark - 弹出此弹窗
/** 弹出此弹窗 */
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}
/*确认的点击事件*/
-(void)confirmButtonClicked:(UIButton *)sender{
    if (self.deleteBlovk) {
        self.deleteBlovk(YES);
    }
    
//
//        if ([self.delegate respondsToSelector:@selector(sendTheFlowerNum:WithTitleName:)]) {
//            NSString *goodsName = [NSString stringWithFormat:@"%@",self.goodName];
//            NSString *flowerNum = self.number;
//            [self.delegate sendTheFlowerNum:flowerNum WithTitleName:goodsName];
//
//
//        }
      /*添加删除代码*/
        
        [self hiddenAnimation];

}
/*取消的点击事件*/
-(void)cancelButtonClicked:(UIButton *)sender{
    
    
    
    
    [self hiddenAnimation];
    
}
/**
 *  键盘将要显示
 *
 *  @param notification 通知
 */
-(void)keyboardWillShow:(NSNotification *)notification
{
    // 获取到了键盘frame
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = frame.size.height;
    
    self.contentView.maxY = SCREEN_HEIGHT - keyboardHeight - 10;
}
/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
-(void)keyboardWillHidden:(NSNotification *)notification
{
    // 弹窗回到屏幕正中
    self.contentView.centerY = SCREEN_HEIGHT / 2;
    
}



/*动画淡出*/
-(void)hiddenAnimation
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha=0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];}];
    //        [UIView beginAnimations:nil context:nil];
    //        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //        [UIView setAnimationDuration:0.5];
    //        [UIView setAnimationDelay:1.0];
    //        self.alpha = 0.0;
    //        [UIView commitAnimations];
}
-(void)showAnimation{
    self.alpha=0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha=1.0;
    } completion:nil];
}
@end

