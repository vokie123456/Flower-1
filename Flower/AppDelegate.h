//
//  AppDelegate.h
//  Test
//
//  Created by JonathanLu on 2018/5/7.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) HomePageTabBarViewController *tabBarController;

@end

