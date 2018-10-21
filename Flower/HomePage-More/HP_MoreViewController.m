//
//  HP_MoreViewController.m
//  Test
//
//  Created by Jonathan Lu on 2018/7/24.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "HP_MoreViewController.h"
#define backGround_COLOR [UIColor colorWithRed:(246 / 255.0) green:(246 / 255.0) blue:(246 / 255.0) alpha:1]
@interface HP_MoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *aboutTbv;

@property (nonatomic,strong)UILabel *textlabel;

@end

@implementation HP_MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"更多";
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:20.f] forKey:UITextAttributeFont];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    self.view.backgroundColor=backGround_COLOR;
    self.aboutTbv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) style:UITableViewStyleGrouped];
    self.aboutTbv.delegate = self;
    self.aboutTbv.dataSource = self;
    self.textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 180, self.view.bounds.size.width, 300)];
    self.textlabel.text = @"中南民族大学新思路团队（NewThread Team）是在2009年成立的，成立之初是由三个技术小白学长在帖老师的指导下， 经过对前端自学的一点点摸索，就此 ，自我学习、自我摸索也成为了新思路团队的一个核心理念。 在之后的数年时间内，团队成员们自我发掘兴趣志向，坚持自主钻研，相互协作；新思路团队更是在2014年夏受邀请到北京人民大会堂授勋“小平科技团队”的荣称。 ";
    [self.textlabel setLineBreakMode:NSLineBreakByWordWrapping]; //指定换行模式
    self.textlabel.numberOfLines = 9;
    self.textlabel.alpha = 0;
    [self.view addSubview:self.textlabel];
    
    [self.view addSubview:self.aboutTbv];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"关于我们";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        self.textlabel.alpha = 1;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
