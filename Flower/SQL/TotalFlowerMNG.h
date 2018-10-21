//
//  TotalFlowerMNG.h
//  Test
//
//  Created by YangHQ on 2018/5/21.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TotalFlowerMNG : NSObject

//@property(nonatomic,assign)int flonum;

-(void)writeToFile:(NSString *)flowerNum;
-(NSString *)readingFile;
-(void)declineTheNum:(NSString *)flowerNum;
@end
