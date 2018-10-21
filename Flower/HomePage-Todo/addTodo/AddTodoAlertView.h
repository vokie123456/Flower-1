//
//  AddTodoAlertView.h
//  Test
//
//  Created by JonathanLu on 2018/5/12.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishModel.h"
#import "SQLManager.h"
/**
 弹窗上的按钮
 
 - AlertButtonLeft: 左边的按钮
 - AlertButtonRight: 右边的按钮
 */
typedef NS_ENUM(NSUInteger, AbnormalButton) {
    AlertButtonLeft = 0,
    AlertButtonRight
};


#pragma mark - 协议

@class DeclareAbnormalAlertView;

@protocol DeclareAbnormalAlertViewDelegate <NSObject>

-(void)sendTheFlowerNum:(NSString *)flowerNum WithTitle:(NSString *)title;

@end

@interface AddTodoAlertView : UIView
/** 这个弹窗对应的orderID */
@property (nonatomic,copy) NSString *orderID;
/** 用户填写的textField */
@property (nonatomic,strong) UITextField *titleTextField;
/*用户设置的时间*/
@property (nonatomic,strong) UIPickerView *timeSetView;

/*用户设置的红花数*/
@property (nonatomic,strong) UITextField *flowersNumberSet;

@property (nonatomic,weak) id<DeclareAbnormalAlertViewDelegate> delegate;


-(instancetype)initWithTitle:(NSString *)title delegate:(id)delegate leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

/** show出这个弹窗 */
- (void)show;

@end
