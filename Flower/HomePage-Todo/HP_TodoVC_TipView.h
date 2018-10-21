//
//  HP_TodoVC_TipView.h
//  Test
//
//  Created by Jonathan Lu on 2018/7/7.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLManager.h"
#import "TodoTableViewCell.h"

typedef NS_ENUM(NSInteger, Mode) {
    TipMode,
    GeneralMode,
};
typedef void (^ReturnValueBlock) (BOOL str);

typedef void (^ConfirmDeleBlo) (BOOL str);

typedef void (^RecycleBlo) (BOOL str);
#pragma mark - 协议

@class DeclareAbnormalAlertView;

@protocol DeclareAbnormalAlertViewDelegate <NSObject>

-(void)sendTheFlowerNum:(NSString *)flowerNum WithTitle:(NSString *)title;

@end

@interface TipAlertView : UIView



/** 这个弹窗对应的orderID */
@property (nonatomic,copy) NSString *orderID;

@property (nonatomic,weak) id<DeclareAbnormalAlertViewDelegate> delegate;

@property(nonatomic, copy) ReturnValueBlock returnValueBlock;

@property(nonatomic,copy)ConfirmDeleBlo confirmDeleBlock;

@property(nonatomic,copy)RecycleBlo recycleBlock;



-(instancetype)initWithTitle:(NSString *)title delegate:(id)delegate mode:(Mode)mode leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle tipText:(NSString *)text selectedCell:(TodoTableViewCell *)cell;
/** show出这个弹窗 */
- (void)show;

@end

