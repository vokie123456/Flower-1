//
//  SQLManager.h
//  smallRedFlower
//
//  Created by yhq on 2018/5/2.
//  Copyright © 2018年 YHQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "FinishTaskM.h"
#import "WishModel.h"
#import "IconInfoModel.h"
@interface SQLManager : NSObject{
    sqlite3 *db;
}

+(SQLManager *)shareManager;
#pragma mark 对任务的管理
-(int)insertTask:(FinishTaskM *)model;//插入用户

-(NSMutableArray *)listAllTheTask; //列出所有未完成用户

-(NSMutableArray *)listAllTheFinishT;//列出所有完成的任务

-(int)updateTheisFinish:(NSString *)idNum; //给完成的任务添加相应的标示

-(int)updateToUnfinish;  //给完成的任务改变标示

-(int)deleteTheTask:(NSString *)taskNum;

-(FinishTaskM *)showTheTaskWith:(NSString *)idNum;//根据idNum查询

-(NSMutableArray *)listTheFinishTWithNowDate;     //每天查询看是否有过期的任务

-(int)countTheFinish:(NSString *)idNum;          //给完成的任务计数一次

-(int)updateTheRecevalFinish:(NSString *)idNum;  //给收回的任务改变标示
#pragma mark 对愿望的管理
-(int)insertWish:(WishModel *)model; //插入愿望

-(NSMutableArray *)listAllWish; //列出所有愿望

-(int)deleteTheWish:(NSString *)WishNum; //删除制定的愿望

-(NSString *)searchTheMaxNum; //寻找最大的用户id
#pragma mark 对图片的管理
-(int)insertIcon:(IconInfoModel *)model; //插入图片

-(NSMutableArray *)listAllTheIconName; //列出所有图片名称

-(IconInfoModel *)showTheIconInfoWith:(NSString *)idNum;    //根据idnum查询

-(NSString *)searchTheMAxInfo;  //寻找最大的id
@end

