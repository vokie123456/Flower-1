//
//  HPTabBarButton.m
//  Test
//
//  Created by Jonathan Lu on 2018/5/24.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "HPTabBarButton.h"

@implementation HPTabBarButton

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // 图片居中
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2+5;
    self.imageView.center = center;
    
    // 文字居中
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = 24 + 10;
    newFrame.size.width = self.frame.size.width;
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
