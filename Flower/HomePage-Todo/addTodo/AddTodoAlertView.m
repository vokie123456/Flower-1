//
//  AddTodoAlertView.m
//  Test
//
//  Created by JonathanLu on 2018/5/12.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "AddTodoAlertView.h"
#import "UIColor+Util.h"
#import "UIView+frameAdjust.h"

#define TitleBackGround_COLOR [UIColor colorWithRed:(218 / 255.0) green:(63 / 255.0) blue:(61 / 255.0) alpha:1]
#define ContentViewBackGround_COLOR [UIColor colorWithRed:(246  / 255.0) green:(246 / 255.0) blue:(246 / 255.0) alpha:1]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface AddTodoAlertView ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
   @property(nonatomic,strong) NSMutableArray *hours_array;
   @property(nonatomic,strong) NSMutableArray *minutes_array;

/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;
/** 弹窗标题 */
@property (nonatomic,copy)   NSString *title;
/** 左边按钮title */
@property (nonatomic,copy)   NSString *leftButtonTitle;
/** 右边按钮title */
@property (nonatomic,copy)   NSString *rightButtonTitle;

@end

@implementation AddTodoAlertView{
        UILabel *label;
}

-(instancetype)initWithTitle:(NSString *)title delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle{
    if (self = [super init]) {
        self.title = title;
        self.delegate = delegate;
        self.leftButtonTitle = leftButtonTitle;
        self.rightButtonTitle = rightButtonTitle;
    }
    //接收键盘显示隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    // UI搭建
    [self setUpUI];
    
    return self;
}
/** UI搭建 */
- (void)setUpUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.75];
    [self showAnimation];
    
     //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake((SCREEN_WIDTH - 285) / 2, 150, 285, 135);
//    self.contentView.center = self.center;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = ContentViewBackGround_COLOR;
    self.contentView.layer.cornerRadius = 6;
    
    // 标题
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, 42)];
    view.backgroundColor=TitleBackGround_COLOR;
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
    
    
    //填写事项标题的textField
    self.titleTextField=[[UITextField alloc]initWithFrame:CGRectMake(22, titleLabel.maxY + 20, self.contentView.width - 44, 46)];
    [self.contentView addSubview:self.titleTextField];
    self.titleTextField.layer.cornerRadius=6;
    self.titleTextField.placeholder=@"添加标题";
    self.titleTextField.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    self.titleTextField.font = [UIFont systemFontOfSize:18];
    [self.titleTextField becomeFirstResponder];
    self.titleTextField.delegate = self;
    /*用户设置的时间*/
    self.timeSetView=[[UIPickerView alloc]initWithFrame:CGRectMake(22, _titleTextField.maxY + 10,self.contentView.width - 44, 56)];
    self.timeSetView.backgroundColor=ContentViewBackGround_COLOR;
    self.timeSetView.layer.cornerRadius=6;

    
    [self setupPickerView:self.timeSetView];

    /*用户设定的小花数*/
    
    UIImageView *flowerimage=[[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.x/2, self.timeSetView.maxY + 10,56, 56)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(flowerimage.maxX+10, flowerimage.minY, 56, 56)];
    label.text=@"x";
    [self.contentView addSubview:label];
    
    flowerimage.image=[UIImage imageNamed:@"6"];
    [self.contentView addSubview:flowerimage];
    
    self.flowersNumberSet=[[UITextField alloc]initWithFrame:CGRectMake(label.minX+20, self.timeSetView.maxY+10, 56, 56)];
    self.flowersNumberSet.keyboardType=UIKeyboardTypeNumberPad;
    self.flowersNumberSet.delegate=self;
    self.flowersNumberSet.backgroundColor=[UIColor colorWithHexString:@"e0e0e0"];
    self.flowersNumberSet.layer.cornerRadius=6;
    [self.contentView addSubview:self.flowersNumberSet];
 

    // 确认按钮
    UIButton *abnormalButton = [[UIButton alloc]initWithFrame:CGRectMake(22, self.contentView.bounds.origin.y+220+20, 100, 40)];
    [self.contentView addSubview:abnormalButton];
    abnormalButton.backgroundColor = [UIColor colorWithHexString:@"d51619"];
    [abnormalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [abnormalButton setTitle:@"确认" forState:UIControlStateNormal];
    [abnormalButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    abnormalButton.layer.cornerRadius = 6;
    [abnormalButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    // 取消按钮
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(titleLabel.maxX-abnormalButton.width-22, abnormalButton.minY, 100, 40)];
    [self.contentView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    cancelButton.layer.cornerRadius = 6;
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    //------- 调整弹窗高度和中心 -------//
    self.contentView.height = 300;
//    self.contentView.center = self.center;
    
}
#pragma mark - 弹出此弹窗
/** 弹出此弹窗 */
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    [keyWindow addSubview:self];
}


-(void)setupPickerView:(UIPickerView *)pickerview{
    pickerview.backgroundColor=[UIColor whiteColor];
    pickerview.delegate=self;
    pickerview.dataSource=self;
    [pickerview reloadAllComponents];
    [self.contentView addSubview:pickerview];
    
    self.hours_array=[NSMutableArray new];
    self.minutes_array=[NSMutableArray new];
    for(int i=0;i<=24;i++){
        [self.hours_array addObject:[NSString stringWithFormat:@"%d h",i]];
    }

    for(int i=0;i<60;i++){
        [self.minutes_array addObject:[NSString stringWithFormat:@"%d min",i+1]];
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    if(component==0){
        return [self.hours_array count];
    }
    return [self.minutes_array count];
    
}
//返回指定列，行的高度，就是自定义行的高度

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 56.0f;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (!view){
        
        view = [[UIView alloc]init];
        
        
        UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _timeSetView.frame.size.width/2, 56)];
        
        text.textAlignment = NSTextAlignmentCenter;
        text.backgroundColor=[UIColor clearColor];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"addAttribute:NSForegroundColorAttributeName"];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 13)];
        text.attributedText=string;
        if(component==0){
            text.text = [self.hours_array objectAtIndex:row];
        }
        else{
            text.text = [self.minutes_array objectAtIndex:row];
        }
        [view addSubview:text];
        
        
    }
    
    return view;
}
-(void)confirmButtonClicked:(UIButton *)sender{
    NSInteger row1 = [self.timeSetView selectedRowInComponent:0];
    NSString *hourStr = [self.hours_array objectAtIndex:row1];
    NSInteger row2 = [self.timeSetView selectedRowInComponent:1];
    NSString *miniteStr = [self.minutes_array objectAtIndex:row2];
    NSString *limiteTime = [NSString stringWithFormat:@"%@:%@",hourStr,miniteStr];
    
    NSLog(@"%@",limiteTime);
    
    if ([self.delegate respondsToSelector:@selector(sendTheFlowerNum:WithTitle:)]) {
        NSString *title = [NSString stringWithFormat:@"'%@'",self.titleTextField.text];
        NSString *flowerNum = self.flowersNumberSet.text;
        [self.delegate sendTheFlowerNum:flowerNum WithTitle:title];
        self.titleTextField.text = @"";
        self.flowersNumberSet.text = @"";
    }
    [self hiddenAnimation];
}
-(void)cancelButtonClicked:(UIButton *)sender{
    [self hiddenAnimation];
    NSLog(@"%f",self.alpha);
}
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
-(void)hiddenAnimation
{
    
    [UIView animateWithDuration:0.45 animations:^{
        self.alpha=0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];}];
}
-(void)showAnimation{
    self.alpha=0.0;
    [UIView animateWithDuration:0.45 animations:^{
        self.alpha=1.0;
    } completion:nil];
}
@end
