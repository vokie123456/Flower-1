//
//  SelectTimeTVController.m
//  Test
//
//  Created by Jonathan Lu on 2018/7/13.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "SelectTimeTVController.h"

@interface SelectTimeTVController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIDatePicker *datePicker;
@property NSIndexPath *oldIndexPath;
@property NSDate *selectDate;
@property UIButton *button;
@property NSDate *currentDate;

@end

@implementation SelectTimeTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentDate=[NSDate date];
    self.navigationItem.hidesBackButton=YES;
    self.oldIndexPath=nil;
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked)];
    backBtn.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    [self.navigationController.navigationBar setHidden:NO];
    self.tableView=[[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    


    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *id=@"UITableViewCell";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id];

    if(indexPath.section==0){
        cell.textLabel.text=@"每天";
    }
    if(indexPath.section==1){
        cell.textLabel.text=@"两周";
    }
    if(indexPath.section==2){
        cell.textLabel.text=@"一个月";
    }
    if(indexPath.section==3){
        cell.textLabel.text=@"六个月";
    }
    if(indexPath.section==4){
        cell.textLabel.text=@"一年";
    }
    if(indexPath.section==5){
        cell.textLabel.text=@"自定义";
        
    }

    // Configure the cell...
    
    return cell;
}

-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController.navigationBar setHidden:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 30;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    NSIndexPath *oldIndex = [tableView indexPathForSelectedRow];
    
    [tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.section!=5){
          [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
  
    

    

    return indexPath;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if(self.oldIndexPath==nil){
        if(indexPath.section==5){
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5]];
            cell.frame=CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, 260);
            cell.textLabel.text=@"";
            UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(16, 0, cell.frame.size.width-32, 50)];
            titleLabel.text=@"自定义";
            [cell addSubview:titleLabel];

            self.datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, cell.frame.origin.y+50, cell.frame.size.width, 150)];
            self.datePicker.backgroundColor=[UIColor clearColor];
            [self.datePicker setDatePickerMode:UIDatePickerModeDate];
            [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
            NSDate *minDate = [NSDate date];
            self.datePicker.minimumDate=minDate;
            [self.view addSubview:self.datePicker];
            [self.datePicker addTarget:self action:@selector(dateChange:)forControlEvents:UIControlEventValueChanged];
            
            self.button=[[UIButton alloc]initWithFrame:CGRectMake(self.datePicker.frame.size.width-100,self.datePicker.frame.origin.y+ self.datePicker.frame.size.height+10, 80, 40)];
            [_button setTitle:@"确定" forState:UIControlStateNormal];

            _button.backgroundColor=[UIColor grayColor];
            _button.layer.opacity=0.8f;
            _button.layer.cornerRadius=8.f;
            _button.layer.shadowColor=[UIColor blackColor].CGColor;
            _button.layer.shadowRadius=6.f;
            _button.layer.shadowOpacity=0.1f;
            _button.layer.shadowOffset=CGSizeMake(0.3f, 0.3f);
            [_button addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
            _button.enabled=NO;
            [self.view addSubview:_button];
            
        }
        else{
            UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"%@",cell.textLabel.text);

            if (self.returnValueBlock) {
                //将自己的值传出去，完成传值
                self.returnValueBlock(cell.textLabel.text);
                 NSLog(@"%@",cell.textLabel.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController.navigationBar setHidden:YES];
        }
        self.oldIndexPath=indexPath;
    }
    if(_oldIndexPath.section!=indexPath.section){
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];

        if (self.returnValueBlock) {
            //将自己的值传出去，完成传值
            self.returnValueBlock(cell.textLabel.text);
            NSLog(@"%@",cell.textLabel.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController.navigationBar setHidden:YES];
    }

}
- (void)dateChange:(UIDatePicker *)date
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateString = [dateFormatter stringFromDate:self.currentDate];
    NSDate *currentdate=[dateFormatter dateFromString:currentDateString];
    self.selectDate=date.date;
    if(_selectDate!=currentdate){
        _button.backgroundColor=[UIColor redColor];
        _button.layer.opacity=0.6f;
        self.button.enabled=YES;
    }
    else{
        self.button.enabled=NO;
        _button.backgroundColor=[UIColor grayColor];
        _button.layer.opacity=0.8f;

    }
}
-(void)confirm{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:self.selectDate];
    NSString *string =[[NSString alloc]initWithFormat:@"date('%@')",dateString];
    if (self.returnValueBlock) {
        //将自己的值传出去，完成传值
        self.returnValueBlock(string);
        NSLog(@"%@",string);


    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController.navigationBar setHidden:YES];
}
@end
