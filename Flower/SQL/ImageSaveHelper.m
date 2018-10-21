//
//  ImageSaveHelper.m
//  Test
//
//  Created by YangHQ on 2018/7/9.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "ImageSaveHelper.h"
#import <UIKit/UIKit.h>

@implementation ImageSaveHelper
+(void)saveImageArray:(NSMutableArray *)array andArrayName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths[0] stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (int i = 0; i< array.count; i++) {
        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png",fileName,i]];
        [UIImagePNGRepresentation(array[i])writeToFile:filePath atomically:YES];
    }
    NSLog(@"保存成功，地址在%@",path);
}

+(NSMutableArray *)getImageArrayWithName:(NSString *)fileName{
    NSMutableArray *imageArray = [NSMutableArray array];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths[0]stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]){
        return imageArray;
    }
    NSArray *filesNameArray = [[NSFileManager defaultManager]subpathsOfDirectoryAtPath:path error:nil];
    if (filesNameArray && filesNameArray.count !=0 ) {
        for (int i = 0 ; i<filesNameArray.count; i++) {
        UIImage * image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:filesNameArray[i]]];
        [imageArray addObject:image];
        }
    }
       return imageArray;
}
+(BOOL)deleteImageName:(NSString *)imageName withFileName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString * path = [paths[0]stringByAppendingPathComponent:fileName];
    NSString * pathFull = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
    if([[NSFileManager defaultManager] fileExistsAtPath:pathFull]){
        return  [[NSFileManager defaultManager]removeItemAtPath:pathFull error:nil];
    }
    return NO;
}
@end
