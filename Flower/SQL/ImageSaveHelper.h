//
//  ImageSaveHelper.h
//  Test
//
//  Created by YangHQ on 2018/7/9.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSaveHelper : NSObject
+(void)saveImageArray:(NSMutableArray *)Array andArrayName:(NSString *)fileNname;

+(NSMutableArray *)getImageArrayWithName:(NSString *)fileName;

+(BOOL)deleteImageName:(NSString *)imageName withFileName:(NSString *)fileName;
@end
