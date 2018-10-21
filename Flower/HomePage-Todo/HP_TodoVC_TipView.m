//
//  HP_TodoVC_TipView.m
//  Test
//
//  Created by Jonathan Lu on 2018/7/7.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "HP_TodoVC_TipView.h"
#import "UIColor+Util.h"
#import "UIView+frameAdjust.h"
#import "SharePhotoViewController.h"

#define TitleBackGround_COLOR [UIColor colorWithRed:(218 / 255.0) green:(63 / 255.0) blue:(61 / 255.0) alpha:1]
#define ContentViewBackGround_COLOR [UIColor colorWithRed:(246  / 255.0) green:(246 / 255.0) blue:(246 / 255.0) alpha:1]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface TipAlertView ()

/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;
/** 弹窗标题 */
@property (nonatomic,copy)   NSString *title;
/** 左边按钮title */
@property (nonatomic,copy)   NSString *leftButtonTitle;
/** 右边按钮title */
@property (nonatomic,copy)   NSString *rightButtonTitle;
/**选中的cell*/
@property (nonatomic,strong) TodoTableViewCell *cell;
/**提示文本*/
@property (nonatomic,copy) NSString *tipText;


@property NSInteger mode;


@end

@implementation TipAlertView{
}
/*修改代码,适应多种界面参数*/
-(instancetype)initWithTitle:(NSString *)title delegate:(id)delegate mode:(Mode)mode leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle  tipText:(NSString *)text selectedCell:(TodoTableViewCell *)cell{
    if (self = [super init]) {
        self.title = title;
        self.delegate = delegate;
        self.leftButtonTitle = leftButtonTitle;
        self.rightButtonTitle = rightButtonTitle;
        self.cell = cell;
        self.mode = mode;
        self.tipText=text;
    }

    // UI搭建
    [self setUpUI];
    
    return self;
}
/** UI搭建 */
- (void)setUpUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45];
    
    
    [self showAnimation];
    
    //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake((SCREEN_WIDTH - 293) / 2, SCREEN_HEIGHT/2-210/2-20, 293, 210);
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = ContentViewBackGround_COLOR;
    self.contentView.layer.cornerRadius = 8;
    
    // 标题
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, 42)];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
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
    
    //正文内容
    UILabel *cellMsgLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 42, self.contentView.width-40, 60)];
    cellMsgLabel.text=[NSString stringWithFormat:@"该习惯名称为：%@",_cell.taskNameLb.text];
    cellMsgLabel.textAlignment = NSTextAlignmentCenter;
    cellMsgLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
    [self.contentView addSubview:cellMsgLabel];
    
    UILabel *tipTextLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 97.5, self.contentView.width-40, 60)];
    tipTextLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tipTextLabel];
    tipTextLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15];
    
    

    /*添加代码*/
    [tipTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    tipTextLabel.numberOfLines=2;
    tipTextLabel.text = self.tipText;
    
    
    // 确认按钮
    UIButton *abnormalButton = [[UIButton alloc]initWithFrame:CGRectMake(0,self.contentView.bounds.origin.y+210-40+1.5, self.contentView.bounds.size.width/2, 41)];
    [self.contentView addSubview:abnormalButton];
    abnormalButton.backgroundColor = [UIColor colorWithHexString:@"d51619"];
    [abnormalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [abnormalButton setTitle:_leftButtonTitle forState:UIControlStateNormal];
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
    [cancelButton setTitle:_rightButtonTitle forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithHexString:@"c8c8c8"];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];

    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:cancelButton.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = cancelButton.bounds;
    maskLayer2.path = maskPath2.CGPath;
    cancelButton.layer.mask = maskLayer2;
    
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    //------- 调整弹窗高度和中心 -------//
//    self.contentView.height = 300;

    
}
#pragma mark - 弹出此弹窗
/** 弹出此弹窗 */
- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:self];
}


-(void)confirmButtonClicked:(UIButton *)sender{
    if (self.returnValueBlock) {
        self.returnValueBlock(YES);
    }
    if(self.confirmDeleBlock){
        self.confirmDeleBlock(YES);
    }
    if (self.recycleBlock) {
        self.recycleBlock(YES);
    }
    
    /*添加代码*/
    [self hiddenAnimation];
}
-(void)cancelButtonClicked:(UIButton *)sender{
    
    [self hiddenAnimation];
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
