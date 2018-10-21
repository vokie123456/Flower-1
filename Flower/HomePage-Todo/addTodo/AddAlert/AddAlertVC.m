//
//  AddAlertTVC.m
//  Test
//
//  Created by Jonathan Lu on 2018/7/10.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "AddAlertVC.h"
#import "AddAlertCell.h"
#import "UIView+frameAdjust.h"
#import "AddNewTodoTVController.h"

#import <ChameleonFramework/Chameleon.h>
@interface AddAlertVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation AddAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    self.title=@"创建习惯";

    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];


    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=NO;
    [self.view addSubview:self.tableView];
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x-38/2,self.view.maxY-20-38,38, 38)];
    [cancelButton setImage:[UIImage imageNamed:@"添加模式删除"] forState:UIControlStateNormal];

    cancelButton.backgroundColor=[UIColor clearColor];

    [self.view addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"AddAlertCell";
 //去缓存池找名叫reuseIdentifier的cell
 AddAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//如果缓存池中没有,那么创建一个新的cell
 if (!cell) {
    cell = [AddAlertCell xibTableViewCell];
     cell.layer.cornerRadius=8.f;
     
     
     cell.layer.shadowColor=[UIColor blackColor].CGColor;
     cell.layer.shadowOffset=CGSizeMake(0.3f, 0.3f);
     cell.layer.shadowRadius=6.f;
     cell.layer.shadowOpacity=0.3f;
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     if(indexPath.section==0){
         cell.cellTextLabel.text=@"创建新的习惯模板";
         cell.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, self.view.width-44, cell.height) andColors:@[[UIColor flatBlueColor],[UIColor flatBlueColorDark]]];
         cell.iconView.image=[UIImage imageNamed:@"星星"];
     }
     else{
         cell.cellTextLabel.text=@"使用现有的模板";
         cell.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, self.view.width-44, cell.height) andColors:@[[UIColor flatGreenColor],[UIColor flatGreenColorDark]]];
         cell.iconView.image=[UIImage imageNamed:@"星系"];
     }


 }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 150;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(void)cancelButtonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        AddNewTodoTVController *tvc=[AddNewTodoTVController new];
        [self.navigationController pushViewController:tvc animated:YES];
    }
}


@end
