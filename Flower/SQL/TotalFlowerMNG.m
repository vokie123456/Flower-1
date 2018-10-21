//
//  TotalFlowerMNG.m
//  Test
//
//  Created by YangHQ on 2018/5/21.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "TotalFlowerMNG.h"

@implementation TotalFlowerMNG

-(NSString *)applicationFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths firstObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"FlowerNum.txt"];
    return filePath;
}

-(void)writeToFile:(NSString *)flowerNum{
    NSString *numString = [NSString stringWithContentsOfFile:[self applicationFile] encoding:NSUTF8StringEncoding error:nil];
    if (numString == nil) {
        int numflower = [flowerNum intValue];
        NSString *num = [NSString stringWithFormat:@"%d",numflower];
        [num writeToFile:[self applicationFile] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"%@",[self applicationFile]);
        return;
    }
    int befoNum = [numString intValue];
    int floNum = [flowerNum intValue];
    NSString *totalStr = [NSString stringWithFormat:@"%d",befoNum + floNum];
    [totalStr writeToFile:[self applicationFile] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
-(NSString *)readingFile{
    NSString *path = [self applicationFile];
    NSString *numString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",numString);
    return numString;
}
-(void)declineTheNum:(NSString *)flowerNum{
    NSString *numString = [NSString stringWithContentsOfFile:[self applicationFile] encoding:NSUTF8StringEncoding error:nil];
    if (numString == nil) {
        int numflower = [flowerNum intValue];
        NSString *num = [NSString stringWithFormat:@"%d",numflower];
        [num writeToFile:[self applicationFile] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"%@",[self applicationFile]);
        return;
    }
    int befoNum = [numString intValue];
    int flowNum = [flowerNum intValue];
    if ((befoNum - flowNum)<=0) {
        NSLog(@"小于0了，不能购买");
        return ;
    }
    NSString *totalStr = [NSString stringWithFormat:@"%d",befoNum - flowNum];
    [totalStr writeToFile:[self applicationFile] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end
