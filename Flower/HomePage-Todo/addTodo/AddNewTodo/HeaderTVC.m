//
//  HeaderTVC.m
//  Test
//
//  Created by Jonathan Lu on 2018/7/12.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "HeaderTVC.h"
#import "UIView+frameAdjust.h"
#import <ChameleonFramework/UIColor+Chameleon.h>

@interface HeaderTVC()

@property (strong,nonatomic)UIButton * tmpBtn;

@end

@implementation HeaderTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    
    

    self.colorShowView.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.frame andColors:@[[UIColor flatYellowColor],[UIColor flatYellowColorDark]]];
    
    self.colorShowView.layer.cornerRadius=8.f;
    self.colorShowView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.colorShowView.layer.shadowOffset=CGSizeMake(0.3f, 0.3f);
    self.colorShowView.layer.shadowRadius=6.f;
    self.colorShowView.layer.shadowOpacity=0.25f;


    
    self.colorSelectScrollView.scrollEnabled=YES;
    self.colorSelectScrollView.alwaysBounceHorizontal=YES;
    self.colorSelectScrollView.contentSize =  CGSizeMake(640-self.colorSelectScrollView.width+32, 0);
    self.colorSelectScrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 640-self.colorSelectScrollView.width+32);
    self.colorSelectScrollView.showsHorizontalScrollIndicator = FALSE;
    [self buttonConfig:self.yellowButton color:[UIColor flatYellowColor] darkColor:[UIColor flatYellowColorDark] tag:1];
    
    self.redButton=[self buttonFrameConfig:self.redButton leftButtonFrame:self.yellowButton.frame];
    [self buttonConfig:self.redButton color:[UIColor flatRedColor] darkColor:[UIColor flatRedColorDark] tag:2];

    self.pinkButton=[self buttonFrameConfig:self.pinkButton leftButtonFrame:self.redButton.frame];
    [self buttonConfig:self.pinkButton color:[UIColor flatPinkColor] darkColor:[UIColor flatPinkColorDark] tag:3];

    self.skyBlueButton=[self buttonFrameConfig:self.skyBlueButton leftButtonFrame:self.pinkButton.frame];
    [self buttonConfig:self.skyBlueButton color:[UIColor flatSkyBlueColor] darkColor:[UIColor flatSkyBlueColorDark] tag:4];
    
    self.greenButton=[self buttonFrameConfig:self.greenButton leftButtonFrame:self.skyBlueButton.frame];
    [self buttonConfig:self.greenButton color:[UIColor flatGreenColor] darkColor:[UIColor flatGreenColorDark] tag:5];
    
    self.purpleButton=[self buttonFrameConfig:self.purpleButton leftButtonFrame:self.greenButton.frame];
    [self buttonConfig:self.purpleButton color:[UIColor flatPurpleColor] darkColor:[UIColor flatPurpleColorDark] tag:6];
    
    self.orangeButton=[self buttonFrameConfig:self.orangeButton leftButtonFrame:self.purpleButton.frame];
    [self buttonConfig:self.orangeButton color:[UIColor flatOrangeColor] darkColor:[UIColor flatOrangeColorDark] tag:7];
    
    self.maroonButton=[self buttonFrameConfig:self.maroonButton leftButtonFrame:self.orangeButton.frame];
    [self buttonConfig:self.maroonButton color:[UIColor flatMaroonColor] darkColor:[UIColor flatMaroonColorDark] tag:8];
    
    self.watermelonButton=[self buttonFrameConfig:self.watermelonButton leftButtonFrame:self.maroonButton.frame];
    [self buttonConfig:self.watermelonButton color:[UIColor flatWatermelonColor] darkColor:[UIColor flatWatermelonColorDark] tag:9];
    
    self.sandButton=[self buttonFrameConfig:self.sandButton leftButtonFrame:self.watermelonButton.frame];
    [self buttonConfig:self.sandButton color:[UIColor flatSandColor] darkColor:[UIColor flatSandColorDark] tag:10];
    
    self.blackButton=[self buttonFrameConfig:self.blackButton leftButtonFrame:self.sandButton.frame];
    [self buttonConfig:self.blackButton color:[UIColor flatBlackColor] darkColor:[UIColor flatBlackColorDark] tag:11];
    

    


    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)xibTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"HeaderTVC" owner:nil options:nil] lastObject];
}

-(void)buttonConfig:(UIButton *)button color:(UIColor *)color darkColor:(UIColor *)darkColor tag:(NSInteger )tag{
    
    button.layer.cornerRadius=20.f;
    button.layer.shadowColor=[UIColor blackColor].CGColor;
    button.layer.shadowOffset=CGSizeMake(0.3f, 0.3f);
    button.layer.shadowRadius=6.f;
    button.layer.shadowOpacity=0.15f;
    button.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.yellowButton.frame andColors:@[color,darkColor]];
    button.tag=tag;
    
    button.imageEdgeInsets=UIEdgeInsetsMake(10, 10, 10, 10);

    if(button!=self.yellowButton){
         [self.colorSelectScrollView addSubview:button];
    }
    button.tintColor=color;
    button.imageView.tintColor=darkColor;
    [button setImage:[UIImage imageNamed:@"颜色选择正确"] forState:UIControlStateSelected];
    
    button.tag=tag;
    
    if(button.tag==1){
        [button setSelected:YES];
    }
    else{
        [button setImage:nil forState:UIControlStateNormal];
    }
    
        [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(UIButton *)buttonFrameConfig:(UIButton *)button leftButtonFrame:(CGRect)frame{
    button=[[UIButton alloc]initWithFrame:CGRectMake(frame.origin.x+40+20, frame.origin.y, 40, 40)];
    return button;
}

-(void)clicked:(UIButton *)sender{
    self.colorShowView.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.colorShowView.frame andColors:@[sender.tintColor,sender.imageView.tintColor]];
    NSLog(@"第一个颜色%@,第二个颜色%@",sender.tintColor,sender.imageView.tintColor);
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:sender.tintColor,@"firstC",sender.imageView.tintColor,@"lastC",nil];
    NSNotification *notification = [NSNotification notificationWithName:@"colors" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
        if(sender.tag!=1){
            [self.yellowButton setSelected:NO];
        }
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
        
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }

}
/*浅色在button.tintcolor，深色在button.imageview.tintcolor*/
@end
