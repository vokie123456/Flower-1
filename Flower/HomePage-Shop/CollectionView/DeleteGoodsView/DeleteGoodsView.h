//
//  DeleteGoodsVC.h
//  Test
//
//  Created by Jonathan Lu on 2018/7/25.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 协议

@class DeclareAbnormalAlertView;

typedef void (^ConfirmDeleBlo) (BOOL str);

@protocol DeleteGoodsDelegate <NSObject>
-(void)sendTheFlowerNum:(NSString *)flowerNum WithTitleName:(NSString *)goodsName;

//- (void)declareAbnormalAlertView:(DeclareAbnormalAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface DeleteGoodsView : UIView
/** 这个弹窗对应的orderID */
@property (nonatomic,copy) NSString *orderID;

/*提示的label*/
@property (nonatomic,strong) UILabel *tipLabel;


@property (nonatomic,weak) id<DeleteGoodsDelegate> delegate;

@property(nonatomic,copy)ConfirmDeleBlo deleteBlovk;


- (instancetype)initWithGoodName:(NSString *)goodName delegate:(id)delegate;

/** show出这个弹窗 */
- (void)show;

@end
