//
//  AddGoodsView.m
//  Test
//
//  Created by Jonathan Lu on 2018/5/15.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "AddGoodsView.h"
#import "UIColor+Util.h"
#import "UIView+frameAdjust.h"
#define TitleBackGround_COLOR [UIColor colorWithRed:(218 / 255.0) green:(63 / 255.0) blue:(61 / 255.0) alpha:1]
#define ContentViewBackGround_COLOR [UIColor colorWithRed:(246  / 255.0) green:(246 / 255.0) blue:(246 / 255.0) alpha:1]



#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface AddGoodsView() <UITextFieldDelegate>
/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;
/** 弹窗标题 */
@property (nonatomic,copy)   NSString *title;

@property (nonatomic,strong) UIScrollView *iconSelectView;


@end
@implementation AddGoodsView
- (instancetype)initWithTitle:(NSString *)title delegate:(id)delegate {
    if (self = [super init]) {
        self.title = title;
        self.delegate = delegate;
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
    //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake((SCREEN_WIDTH - 285) / 2, 150, 285, 260);
    //    self.contentView.center = self.center;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 6;
    
    // 标题
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, 42)];
    //    view.layer.cornerRadius=6;
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
    titleLabel.text = self.title;
    
    
    
    
//    self.iconSelectView=[[UIScrollView alloc]initWithFrame:CGRectMake(22, view.maxY, self.contentView.width-44, 100)];
//    self.iconSelectView.scrollEnabled=YES;
//    self.iconSelectView.alwaysBounceHorizontal=YES;
//    self.iconSelectView.contentSize=CGSizeMake(100*13+10+60+10, 0);
//    self.iconSelectView.contentInset=UIEdgeInsetsZero;
//    self.iconSelectView.showsHorizontalScrollIndicator = FALSE;
//
//    for(int i=0;i<14;i++){
//        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(10+i*60+i*40, 20, 60, 60)];
//        NSString *str=[NSString stringWithFormat:@"sale_%d",i];
//        imageV.image=[UIImage imageNamed:str];
//        [self.iconSelectView addSubview:imageV];
//
//
//    }
//
//    [self.contentView addSubview:self.iconSelectView];
    
    
    
    
    
    
    
    
    //填写事项标题的textField
    self.titleTextField=[[UITextField alloc]initWithFrame:CGRectMake(22, view.maxY + 20, self.contentView.width - 44, 46)];
    [self.contentView addSubview:self.titleTextField];
    self.titleTextField.layer.cornerRadius=6;
    self.titleTextField.placeholder=@"添加商品标题";
    self.titleTextField.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    self.titleTextField.font = [UIFont systemFontOfSize:18];
    [self.titleTextField becomeFirstResponder];
    
    
    /*用户设定的小花数*/
    UIImageView *flowerimage=[[UIImageView alloc]initWithFrame:CGRectMake(66, self.titleTextField.maxY + 30,56, 56)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(flowerimage.maxX+10, flowerimage.minY, 56, 56)];
    label.text=@"x";
    [self.contentView addSubview:label];
    flowerimage.image=[UIImage imageNamed:@"6"];
    [self.contentView addSubview:flowerimage];
    
    self.setFlowersNumberTextField=[[UITextField alloc]initWithFrame:CGRectMake(label.minX+20, flowerimage.minY, 82, 56)];
    self.setFlowersNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.setFlowersNumberTextField.delegate=self;
    self.setFlowersNumberTextField.backgroundColor=[UIColor colorWithHexString:@"e0e0e0"];
    self.setFlowersNumberTextField.layer.cornerRadius=6;
    self.setFlowersNumberTextField.textAlignment=NSTextAlignmentCenter;
    self.setFlowersNumberTextField.font=[UIFont boldSystemFontOfSize:23.f];

    [self.contentView addSubview:self.setFlowersNumberTextField];
    
    
    // 确认按钮
    UIButton *abnormalButton = [[UIButton alloc]initWithFrame:CGRectMake(0,self.contentView.height-40+1.5, self.contentView.bounds.size.width/2, 41)];
    [self.contentView addSubview:abnormalButton];
    abnormalButton.backgroundColor = [UIColor colorWithHexString:@"d51619"];
    [abnormalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [abnormalButton setTitle:@"确认" forState:UIControlStateNormal];
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
    
    
    
}
#pragma mark - 弹出此弹窗
/** 弹出此弹窗 */
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}
/*确认的点击事件*/
-(void)confirmButtonClicked:(UIButton *)sender{
    
    if(![self.titleTextField.text isEqual:@""] && ![self.setFlowersNumberTextField.text isEqual:@""]){
        if ([self.delegate respondsToSelector:@selector(sendTheFlowerNum:WithGoodsName:)]) {
            NSString *goodsName = [NSString stringWithFormat:@"%@",self.titleTextField.text];
            NSString *flowerNum = self.setFlowersNumberTextField.text;
            [self.delegate sendTheFlowerNum:flowerNum WithGoodsName:goodsName];
            self.titleTextField.text = @"";
            self.setFlowersNumberTextField.text = @"";
        }
        [self hiddenAnimation];
    }

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.titleTextField resignFirstResponder];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    if (textField == self.setFlowersNumberTextField){
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 5) return NO;//限制长度
        return YES;
    }else{
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if ( proposedNewLength > 5) return NO;//限制长度
        return YES;
    }
}
@end

