//
//  AddGoodsView.h
//  Test
//
//  Created by Jonathan Lu on 2018/5/15.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
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

//- (void)declareAbnormalAlertView:(DeclareAbnormalAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)sendTheFlowerNum:(NSString *)flowerNum WithGoodsName:(NSString *)goodsName;
@end

@interface AddGoodsView : UIView
/** 这个弹窗对应的orderID */
@property (nonatomic,copy) NSString *orderID;
/*用户添加的商品名称*/
@property (nonatomic,strong) UITextField *titleTextField;
/*图标*/
@property (nonatomic,strong) UIImageView *iconView;
/*用户设置的小红花数*/
@property (nonatomic,strong) UITextField *setFlowersNumberTextField;

@property (nonatomic,weak) id<DeclareAbnormalAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title delegate:(id)delegate;

/** show出这个弹窗 */
- (void)show;
@end
