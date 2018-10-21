//
//  ConfirmGoodsView.h
//  Test
//
//  Created by JonathanLu on 2018/5/16.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 协议

@class DeclareAbnormalAlertView;

@protocol ConfirmGoodsDelegate <NSObject>
-(void)sendTheFlowerNum:(NSString *)flowerNum WithTitleName:(NSString *)goodsName;

//- (void)declareAbnormalAlertView:(DeclareAbnormalAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface ConfirmGoodsView : UIView
/** 这个弹窗对应的orderID */
@property (nonatomic,copy) NSString *orderID;

/*提示的label*/
@property (nonatomic,strong) UILabel *tipLabel;


@property (nonatomic,weak) id<ConfirmGoodsDelegate> delegate;


- (instancetype)initWithGoodName:(NSString *)goodName flowersNumber:(NSString *)number delegate:(id)delegate;

/** show出这个弹窗 */
- (void)show;

@end
