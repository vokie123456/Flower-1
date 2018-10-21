//
//  FinishTaskM.h
//  smallRedFlower
//
//  Created by yhq on 2018/5/2.
//  Copyright © 2018年 YHQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinishTaskM : NSObject

//编号
@property(strong,nonatomic)NSString *idNum;

//任务名称
@property(strong,nonatomic)NSString *finishiTask;

//时间
@property(strong,nonatomic)NSString *time;

//小花数目
@property(strong,nonatomic)NSString *flowerNum;

//标志位
@property(strong,nonatomic)NSString *flag;

//第一种颜色
@property(strong,nonatomic)NSString *firstColor;

//第二种颜色
@property(strong,nonatomic)NSString *lastColor;

//截止时间
@property(strong,nonatomic)NSString *deadline;

@end

