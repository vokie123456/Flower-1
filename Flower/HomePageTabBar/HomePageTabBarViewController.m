//
//  HomePageTabBarViewController.m
//  KidsGrowDemo
//
//  Created by Jonathan Lu on 2018/5/4.
//  Copyright © 2018年 Jonathan Lu. All rights reserved.
//

#import "HomePageTabBarViewController.h"
#import "HP_TodoViewController.h"
#import "HP-ShopViewController.h"
#import "HP-RecordViewController.h"
#import "HP_MoreViewController.h"
#import "UIView+frameAdjust.h"
#import "HPCustomTabBar.h"
#import "TotalFlowerMNG.h"
#import "CountVC.h"
#define Global_tintColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:0.85]

@interface HomePageTabBarViewController () <HPTabBarViewDelegate>
@property (nonatomic,assign) NSInteger  indexFlag;

@property(nonatomic,readonly)HPCustomTabBar *hometabBar;


@end

@implementation HomePageTabBarViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    _hometabBar =[[HPCustomTabBar alloc]init];
    _hometabBar.tabBarView.viewDelegate=self;
    [self setValue:_hometabBar forKey:@"tabBar"];
    TotalFlowerMNG *numMG = [[TotalFlowerMNG alloc]init];
    int flonum = [[numMG readingFile]intValue];
    _hometabBar.tabBarView.countingLb.method = UILabelCountingMethodLinear;
    _hometabBar.tabBarView.countingLb.format = @"%d";
    [_hometabBar.tabBarView.countingLb countFrom:0 to:flonum withDuration:3.0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:@"flonum" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(declineNum:) name:@"decline" object:nil];
    [self loadViewControllers];
}
-(void)change:(NSNotification *)notification{
    NSString *name = [notification name];
    NSString *object = [notification object];
    int flonum = [object intValue];
    NSLog(@"值改变啦%@",name);
    NSLog(@"object is %@",object);
    _hometabBar.tabBarView.countingLb.method = UILabelCountingMethodLinear;
    _hometabBar.tabBarView.countingLb.format = @"%d";
    [_hometabBar.tabBarView.countingLb countFrom:0 to:flonum withDuration:2.0];
}
-(void)declineNum:(NSNotification *)notifi{
    NSString *object = [notifi object];
    NSLog(@"object is %@",object);
    int flonum = [object intValue];
    _hometabBar.tabBarView.countingLb.method = UILabelCountingMethodLinear;
    _hometabBar.tabBarView.countingLb.format = @"%d";
    [_hometabBar.tabBarView.countingLb countFrom:0 to:flonum withDuration:2.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    [self removeObserver:self forKeyPath:@"formatBlock"];
    // Dispose of any resources that can be recreated.
}
-(void)loadViewControllers {

    HP_TodoViewController* todoVC=[HP_TodoViewController new];
    UINavigationController *todoNC=[[UINavigationController alloc]initWithRootViewController:todoVC];
    todoVC.title=@"好习惯";
    [self addChildViewController:todoNC];

    
    HP_RecordViewController *recordVC=[HP_RecordViewController new];
    UINavigationController *recordNC=[[UINavigationController alloc]initWithRootViewController:recordVC];
    recordVC.title=@"记录";
    [self addChildViewController:recordNC];
    
    HP_ShopViewController *shopVC=[HP_ShopViewController new];
    UINavigationController *shopNC=[[UINavigationController alloc]initWithRootViewController:shopVC];
    shopVC.title=@"愿望池";
    [self addChildViewController:shopNC];

    HP_MoreViewController *view=[HP_MoreViewController new];
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:view];
    view.title=@"统计";
    [self addChildViewController:nc];

    

    
}


- (void)HPTabBarView:(HPTabBarView *)view didSelectItemAtIndex:(NSInteger)index
{

    self.selectedIndex = index;
}
    
-(void)dealloc{
    NSLog(@"观察者销毁了");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



//}









@end
