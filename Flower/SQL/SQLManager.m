//
//  SQLManager.m
//  smallRedFlower
//
//  Created by yhq on 2018/5/2.
//  Copyright © 2018年 YHQ. All rights reserved.
//

#import "SQLManager.h"

@interface SQLManager()

@property(nonatomic,strong) NSMutableArray *modelArr;

//@property(nonatomic,strong
@end
@implementation SQLManager

#define kUserNameFile (@"Users.sqlite")

static SQLManager *manager = nil;
+(SQLManager *)shareManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc]init];
        [manager createUsersDataBaseTableIfNeed];
        [manager createWishDataBaseTableIfNeed];
        [manager createIconDataBaseTableIfNeed];
    });
    return manager;
}
//创建文件路径
-(NSString *)applicationDocumentsDirectoryFile{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path firstObject];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:kUserNameFile];
    return filePath;
}

#pragma mark    任务管理模块
//未完成的表的创建
-(void)createUsersDataBaseTableIfNeed{
    NSString *writeTablePath = [self applicationDocumentsDirectoryFile];
    NSLog(@"数据库的位置是%@",writeTablePath);
    if (sqlite3_open([writeTablePath UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }else{
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Users(idNum INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,unfinishTask CHAR(100) NOT NULL,isFinish INTEGER DEFAULT 0,flowerNum INTEGER NOT NULL,uiFirstColor CHAR(60)  NOT NULL ,uiLastColor CHAR(60)  NOT NULL,time TIMESTAMP default (datetime('now','localtime')),deadline date,totalNum INTEGER DEFAULT 0);"];
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err)!= SQLITE_OK) {
            sqlite3_close(db);
            NSAssert(NO, @"建表失败！%s",err);
        }
        sqlite3_close(db);
    }
}
//插入未完成任务的数据，并同时在另一个数据库中生成相应的记录
-(int)insertTask:(FinishTaskM *)model{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO Users(unfinishTask,flowerNum,uiFirstColor,uiLastColor,deadline)VALUES(%@,%@,%@,%@,%@);",model.finishiTask,model.flowerNum,model.firstColor,model.lastColor,model.deadline];
        sqlite3_stmt *statement;
        //预处理
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [model.finishiTask UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 1, [model.flowerNum UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 1, [model.firstColor UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 1, [model.lastColor UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 1, [model.deadline UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
}
//列出所有未完成任务
-(NSMutableArray *)listAllTheTask{
    NSString *path = [self applicationDocumentsDirectoryFile];
    self.modelArr = [NSMutableArray array];
    if (sqlite3_open([path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Users WHERE isFinish = 0;"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                //编号
                NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                //未完成
                char *unfinishTask = (char *)sqlite3_column_text(statement, 1);
                NSString *unfinishStr = [[NSString alloc]initWithUTF8String:unfinishTask];
           
                //小红花数量
                char *flowerNum = (char *)sqlite3_column_text(statement, 3);
                NSString *flowerStr = [[NSString alloc]initWithUTF8String:flowerNum];
                
                char *flag = (char *)sqlite3_column_text(statement, 2);
                NSString *flagStr = [[NSString alloc]initWithUTF8String:flag];
                
                //第一个颜色
                char *firstColor = (char *)sqlite3_column_text(statement, 4);
                NSString *fColorStr = [[NSString alloc]initWithUTF8String:firstColor];
                
                //第二个颜色
                char *lastColor = (char *)sqlite3_column_text(statement, 5);
                NSString *lColorStr = [[NSString alloc]initWithUTF8String:lastColor];
                
                //时间
                char *time = (char *)sqlite3_column_text(statement, 6);
                NSString *timeStr = [[NSString alloc]initWithUTF8String:time];
                
                //截止时间
                char *deadline = (char *)sqlite3_column_text(statement, 7);
                NSString *deadLineStr = [[NSString alloc]initWithUTF8String:deadline];
                
                FinishTaskM *Fmodel = [[FinishTaskM alloc]init];
                Fmodel.idNum = idNumStr;
                Fmodel.flowerNum = flowerStr;
                Fmodel.finishiTask = unfinishStr;
                Fmodel.time = timeStr;
                Fmodel.flag = flagStr;
                Fmodel.firstColor = fColorStr;
                Fmodel.lastColor = lColorStr;
                Fmodel.deadline = deadLineStr;
                [self.modelArr addObject:Fmodel];
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return _modelArr;
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}
//列出所有已完成的任务
-(NSMutableArray *)listAllTheFinishT{
    NSString *path = [self applicationDocumentsDirectoryFile];
    self.modelArr = [NSMutableArray array];
    if (sqlite3_open([path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Users WHERE isFinish = 1;"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                //编号
                NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                //未完成
                char *unfinishTask = (char *)sqlite3_column_text(statement, 1);
                NSString *unfinishStr = [[NSString alloc]initWithUTF8String:unfinishTask];
                //小红花数量
                char *flowerNum = (char *)sqlite3_column_text(statement, 3);
                NSString *flowerStr = [[NSString alloc]initWithUTF8String:flowerNum];
                //时间
                char *time = (char *)sqlite3_column_text(statement, 6);
                NSString *timeStr = [[NSString alloc]initWithUTF8String:time];
                
                //第一个颜色
                char *firstColor = (char *)sqlite3_column_text(statement, 4);
                NSString *fColorStr = [[NSString alloc]initWithUTF8String:firstColor];
                
                //第二个颜色
                char *lastColor = (char *)sqlite3_column_text(statement, 5);
                NSString *lColorStr = [[NSString alloc]initWithUTF8String:lastColor];
                
                char *deadLine = (char *)sqlite3_column_text(statement, 7);
                NSString *deadLineStr = [[NSString alloc]initWithUTF8String:deadLine];

                FinishTaskM *alFmodel = [[FinishTaskM alloc]init];
                alFmodel.idNum = idNumStr;
                alFmodel.flowerNum = flowerStr;
                alFmodel.finishiTask = unfinishStr;
                alFmodel.time = timeStr;
                alFmodel.firstColor = fColorStr;
                alFmodel.lastColor = lColorStr;
                alFmodel.deadline = deadLineStr;
                [self.modelArr addObject:alFmodel];
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return _modelArr;
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}
//任务完成后给任务添加相应的标示
-(int)updateTheisFinish:(NSString *)idNum{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据打开失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"UPDATE Users SET isFinish = 1 WHERE idNum = %@;",idNum];
        sqlite3_stmt *statement;
        //预处理
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [idNum UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"更新数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
}
-(int)updateToUnfinish{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据打开失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"UPDATE Users SET isFinish = 0 WHERE idNum != 0;"];
        sqlite3_stmt *statement;
        //预处理
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"更新数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
}
-(int)deleteTheTask:(NSString *)taskNum{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据更新失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM Users WHERE idNum = %@;",taskNum];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) != SQLITE_DONE) {
                 NSAssert(NO, @"更新数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
    
}
//按主键查询
-(FinishTaskM *)showTheTaskWith:(NSString *)idNum{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Users WHERE idNum = %@;",idNum];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                    char *idNum = (char *)sqlite3_column_text(statement, 0);
                    //编号
                    NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                    //未完成
                    char *unfinishTask = (char *)sqlite3_column_text(statement, 1);
                    NSString *unfinishStr = [[NSString alloc]initWithUTF8String:unfinishTask];
                    //小红花数量
                    char *flowerNum = (char *)sqlite3_column_text(statement, 3);
                    NSString *flowerStr = [[NSString alloc]initWithUTF8String:flowerNum];
                    //时间
                    char *time = (char *)sqlite3_column_text(statement, 4);
                    NSString *timeStr = [[NSString alloc]initWithUTF8String:time];
                
                   FinishTaskM *alFmodel = [[FinishTaskM alloc]init];
                   alFmodel.idNum = idNumStr;
                   alFmodel.flowerNum = flowerStr;
                   alFmodel.finishiTask = unfinishStr;
                   alFmodel.time = timeStr;
                   sqlite3_finalize(statement);
                   sqlite3_close(db);
                return alFmodel;
                }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
           sqlite3_finalize(statement);
           sqlite3_close(db);
    }
    return nil;
}
//按时间查询
-(NSMutableArray *)listTheFinishTWithNowDate{
    NSString *path = [self applicationDocumentsDirectoryFile];
    self.modelArr = [NSMutableArray array];
    if (sqlite3_open([path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Users WHERE deadline = date('now');"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                //编号
                NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                //未完成
                char *unfinishTask = (char *)sqlite3_column_text(statement, 1);
                NSString *unfinishStr = [[NSString alloc]initWithUTF8String:unfinishTask];
                //小红花数量
                char *flowerNum = (char *)sqlite3_column_text(statement, 3);
                NSString *flowerStr = [[NSString alloc]initWithUTF8String:flowerNum];
                //时间
                char *time = (char *)sqlite3_column_text(statement, 4);
                NSString *timeStr = [[NSString alloc]initWithUTF8String:time];
                
                //第一个颜色
                char *firstColor = (char *)sqlite3_column_text(statement, 5);
                NSString *fColorStr = [[NSString alloc]initWithUTF8String:firstColor];
                
                //第二个颜色
                char *lastColor = (char *)sqlite3_column_text(statement, 6);
                NSString *lColorStr = [[NSString alloc]initWithUTF8String:lastColor];
                
                char *deadLine = (char *)sqlite3_column_text(statement, 7);
                NSString *deadLineStr = [[NSString alloc]initWithUTF8String:deadLine];
                
                FinishTaskM *alFmodel = [[FinishTaskM alloc]init];
                alFmodel.idNum = idNumStr;
                alFmodel.flowerNum = flowerStr;
                alFmodel.finishiTask = unfinishStr;
                alFmodel.time = timeStr;
                alFmodel.firstColor = fColorStr;
                alFmodel.lastColor = lColorStr;
                alFmodel.deadline = deadLineStr;
                [self.modelArr addObject:alFmodel];
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return _modelArr;
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}

//update Users set totalNum  = totalNum + 1 WHERE idNum = 1;
-(int)countTheFinish:(NSString *)idNum{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据打开失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"update Users set totalNum  = totalNum + 1 WHERE idNum = %@;",idNum];
        sqlite3_stmt *statement;
        //预处理
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [idNum UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"更新数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
    return 0;
}

-(int)updateTheRecevalFinish:(NSString *)idNum{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据打开失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"UPDATE Users SET isFinish = 2 WHERE idNum = %@;",idNum];
        sqlite3_stmt *statement;
        //预处理
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [idNum UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"更新数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
}
#pragma mark 创建愿望的愿望表
-(void)createWishDataBaseTableIfNeed{
    NSString *writeTablePath = [self applicationDocumentsDirectoryFile];
    NSLog(@"数据库的地址是：%@",writeTablePath);
    if (sqlite3_open([writeTablePath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }else{
        char *err;
        //建表内容：愿望内容，小红花数量，时间，
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS WishList(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,wish CHAR(100) NOT NULL,flowerNum INTEGER NOT NULL,time TIMESTAMP default (datetime('now','localtime')));"];
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err)!= SQLITE_OK) {
            sqlite3_close(db);
            NSAssert(NO, @"建表失败%s",err);
        }
        sqlite3_close(db);
    }
}

-(int)insertWish:(WishModel *)model{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO WishList(wish,flowerNum)VALUES(%@,%@);",model.wish,model.flowerNum];
        sqlite3_stmt *statement;
        //预处理
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [model.wish UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 1, [model.flowerNum UTF8String], -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
}
-(NSString *)searchTheMaxNum
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }else{
        NSString *maxSql = @"SELECT max(ID) FROM Users;";
        sqlite3_stmt *statement;
        if (sqlite3_prepare(db, [maxSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) != SQLITE_ROW) {
                NSAssert(NO, @"寻找最大数据失败");
            }
            char *maxNum = (char *)sqlite3_column_text(statement, 0);
            NSString *max = [[NSString alloc]initWithUTF8String:maxNum];
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return max;
        }
    }
    
    return nil;
}
-(NSMutableArray *)listAllWish{
    NSString *path = [self applicationDocumentsDirectoryFile];
    self.modelArr = [NSMutableArray array];
    if (sqlite3_open([path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM WishList;"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                //编号
                NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                //未完成
                char *wish = (char *)sqlite3_column_text(statement, 1);
                NSString *wishStr = [[NSString alloc]initWithUTF8String:wish];
                //小红花数量
                char *flowerNum = (char *)sqlite3_column_text(statement, 2);
                NSString *flowerStr = [[NSString alloc]initWithUTF8String:flowerNum];
                //时间
                char *time = (char *)sqlite3_column_text(statement, 3);
                NSString *timeStr = [[NSString alloc]initWithUTF8String:time];
                WishModel *alWmodel = [[WishModel alloc]init];
                alWmodel.idNum= idNumStr;
                alWmodel.flowerNum = flowerStr;
                alWmodel.wish = wishStr;
                alWmodel.time = timeStr;
                [self.modelArr addObject:alWmodel];
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return _modelArr;
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}
-(int)deleteTheWish:(NSString *)WishNum{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据更新失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM WishList WHERE ID = %@;",WishNum];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"更新数据失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
}

#pragma mark   对记录内图片的管理
-(void)createIconDataBaseTableIfNeed{
    NSString *writeTablePath = [self applicationDocumentsDirectoryFile];
    NSLog(@"数据库的地址是：%@",writeTablePath);
    if (sqlite3_open([writeTablePath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }else{
        char *err;
        //建表内容：图片编号，图片相对应信息，图片对应任务获得的小红花数量，完成时间，
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS IconList(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,IconName CHAR(100) NOT NULL,flowerNum INTEGER NOT NULL,time TIMESTAMP default (datetime('now','localtime')),experience CHAR(100));"];
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err)!= SQLITE_OK) {
            sqlite3_close(db);
            NSAssert(NO, @"建表失败%s",err);
        }
        sqlite3_close(db);
    }
}

-(int)insertIcon:(IconInfoModel *)model{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO IconList(IconName,flowerNum,experience)VALUES(%@,%@,%@);",model.iconName,model.flowerNum,model.exp];
        sqlite3_stmt *statement;
        //预处理
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_text(statement, 1, [model.iconName UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 1, [model.flowerNum UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 1, [model.exp UTF8String], -1, NULL);
            NSLog(@"statement is %d",sqlite3_step(statement));
            sqlite3_step(statement);

            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
}
//列出所有图片信息
-(NSMutableArray *)listAllTheIconName{
    NSString *path = [self applicationDocumentsDirectoryFile];
    self.modelArr = [NSMutableArray array];
    if (sqlite3_open([path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM IconList"];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                //编号
                NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                //未完成
                char *iconName = (char *)sqlite3_column_text(statement, 1);
                NSString *iconNameStr = [[NSString alloc]initWithUTF8String:iconName];
                //小红花数量
                char *flowerNum = (char *)sqlite3_column_text(statement, 2);
                NSString *flowerStr = [[NSString alloc]initWithUTF8String:flowerNum];
                //时间
                char *time = (char *)sqlite3_column_text(statement, 3);
                NSString *timeStr = [[NSString alloc]initWithUTF8String:time];
                
                char *exp = (char *)sqlite3_column_text(statement, 4);
                NSString *expStr = [[NSString alloc]initWithUTF8String:exp];
                
                IconInfoModel *iconMd = [[IconInfoModel alloc]init];
                iconMd.idNum = idNumStr;
                iconMd.iconName = iconNameStr;
                iconMd.time = timeStr;
                iconMd.flowerNum = flowerStr;
                iconMd.exp = expStr;

                [self.modelArr addObject:iconMd];
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return _modelArr;
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}
-(IconInfoModel *)showTheIconInfoWith:(NSString *)idNum{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }else{
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM IconList WHERE ID = %@;",idNum];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *idNum = (char *)sqlite3_column_text(statement, 0);
                //编号
                NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                //未完成
                char *iconName = (char *)sqlite3_column_text(statement, 1);
                NSString *iconNameStr = [[NSString alloc]initWithUTF8String:iconName];
                //小红花数量
                char *flowerNum = (char *)sqlite3_column_text(statement, 2);
                NSString *flowerStr = [[NSString alloc]initWithUTF8String:flowerNum];
                //时间
                char *time = (char *)sqlite3_column_text(statement, 3);
                NSString *timeStr = [[NSString alloc]initWithUTF8String:time];
                
                char *exp = (char *)sqlite3_column_text(statement, 4);
                NSString *expStr = [[NSString alloc]initWithUTF8String:exp];
                
                IconInfoModel *iconMd = [[IconInfoModel alloc]init];
                iconMd.idNum = idNumStr;
                iconMd.iconName = iconNameStr;
                iconMd.time = timeStr;
                iconMd.flowerNum = flowerStr;
                iconMd.exp = expStr;
                
                sqlite3_finalize(statement);
                sqlite3_close(db);
                return iconMd;
                
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}
//根据idnum查询

-(NSString *)searchTheMAxInfo{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }else{
        NSString *maxSql = @"SELECT max(ID) FROM IconList;";
        sqlite3_stmt *statement;
        if (sqlite3_prepare(db, [maxSql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) != SQLITE_ROW) {
                NSAssert(NO, @"寻找最大数据失败");
            }
            char *maxNum = (char *)sqlite3_column_text(statement, 0);
            NSString *max = [[NSString alloc]initWithUTF8String:maxNum];
            sqlite3_finalize(statement);
            sqlite3_close(db);
            return max;
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}
//寻找最大的id
@end

