//
//  AddNewTodoTVController.m
//  Test
//
//  Created by Jonathan Lu on 2018/7/12.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "AddNewTodoTVController.h"
#import "HeaderTVC.h"
#import "FlowerTVC.h"
#import "UIView+frameAdjust.h"
#import "SelectTimeTVController.h"
#import "HP_TodoViewController.h"
#import "SQLManager.h"
#import "FinishTaskM.h"
@interface AddNewTodoTVController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UIButton *confirmButton;
@property (nonatomic,strong)UITextField *nameTextField;
@property (nonatomic,strong)NSString *flowerStr;
@property(nonatomic,strong)NSString *fColorStr;
@property(nonatomic,strong)NSString *lColorStr;
@property(nonatomic,strong)NSString *dataSegtr;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)NSString *selectDays;
@end

@implementation AddNewTodoTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES;
    [self.navigationController.navigationBar setHidden:YES];
    
    
    self.tableView=[[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    
    self.backButton=[[UIButton alloc]initWithFrame:CGRectMake(40, self.view.height-60, 38, 38)];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"新添加模式返回"] forState:UIControlStateNormal];
    
    self.confirmButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-40-38, self.view.height-60, 38, 38)];
    [self.confirmButton setImage:[UIImage imageNamed:@"新添加模式确定"] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:self.backButton];
    [self.tableView addSubview:self.confirmButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(flowerNumDidchange:) name:@"flower" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(colorsDidChange:) name:@"colors" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChangeOneCI:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.nameTextField];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if(indexPath.section==0){
             HeaderTVC *cell=[HeaderTVC xibTableViewCell];
             cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    if(indexPath.section==1){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, self.view.width-30, 50)];
        self.nameTextField.placeholder=@"习惯名称";
        
        /*添加代码*/
        [cell.contentView addSubview:self.nameTextField];
        return cell;
    }
    if(indexPath.section==2){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.text=@"时间段";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.view.width-150-50, 0, 150, 50)];
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        [self.timeLabel setTextColor:[UIColor grayColor]];
        [cell addSubview:self.timeLabel];
        return cell;
    }
    
    if(indexPath.section==3){
        FlowerTVC *cell=[FlowerTVC xibTableViewCell];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    
    
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 260;
    }
    if(indexPath.section==3){
        return 100;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 30;
    }
    if(section==1){
        return 0;
    }
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
    [self.backButton removeFromSuperview];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    self.backButton.frame=CGRectMake(self.backButton.x, (self.tableView.frame.size.height - 80) + self.tableView.contentOffset.y, self.backButton.width, self.backButton.height);
    self.confirmButton.frame=CGRectMake(self.confirmButton.x, (self.tableView.frame.size.height - 80) + self.tableView.contentOffset.y, self.confirmButton.width, self.confirmButton.height);
}

-(void)confirmButtonClicked{
    
    if([self.nameTextField.text isEqual:@""] || self.flowerStr==nil || [self.dataSegtr isEqual:@""] || [self.flowerStr isEqual:@""] || self.dataSegtr==nil){
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"非法输入，请重新输入!" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }
                          ]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        
        
        /*添加代码，用于添加新的习惯模板并安排习惯*/
        NSLog(@"dai ma %@",_dataSegtr);
        
        FinishTaskM *taskMd = [[FinishTaskM alloc]init];
        taskMd.finishiTask = [NSString stringWithFormat:@"'%@'",self.nameTextField.text];
        taskMd.flowerNum = self.flowerStr;
        taskMd.firstColor = [NSString stringWithFormat:@"'%@'",self.fColorStr];
        taskMd.lastColor = [NSString stringWithFormat:@"'%@'",self.lColorStr];
        taskMd.deadline = self.dataSegtr;
        
        //    taskMd.deadline = [NSString]
        [[SQLManager shareManager]insertTask:taskMd];
        NSNotification *notification = [NSNotification notificationWithName:@"insert" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        [self dismissViewControllerAnimated:YES completion:nil];
    
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==2){
        SelectTimeTVController *tvc=[SelectTimeTVController new];
        tvc.returnValueBlock = ^(NSString *strValue) {
            self->_selectDays = strValue;
            self->_timeLabel.text=self->_selectDays;
            
            
            
            if ([strValue isEqualToString:@"每天"]) {
                self->_dataSegtr =  @"date('2006-10-17','+100 year')";
            }else if ([strValue isEqualToString:@"两周"]) {
                self->_dataSegtr = @"date('now','+14 day')";
            }else if ([strValue isEqualToString:@"一个月"]){
                self->_dataSegtr = @"date('now','+1 month')";
            }else if ([strValue isEqualToString:@"六个月"]){
                self->_dataSegtr = @"date('now','+6 month')";
            }else if ([strValue isEqualToString:@"一年"]){
                self->_dataSegtr = @"date('now','+1 year')";
            }else {
                self->_dataSegtr = strValue;
            }
        };
        [self.navigationController pushViewController:tvc animated:YES];
    }
}



-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    if(textfield==self.nameTextField){
         HeaderTVC *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.nameLabel.text=textfield.text;
    }

}
-(void)colorsDidChange:(NSNotification *)notification
{
    self.fColorStr = notification.userInfo[@"firstC"];
    self.lColorStr = notification.userInfo[@"lastC"];
    NSLog(@"%@",notification.userInfo);
}
-(void)flowerNumDidchange:(NSNotification *)notification{
    self.flowerStr = notification.userInfo[@"text"];
}

@end
