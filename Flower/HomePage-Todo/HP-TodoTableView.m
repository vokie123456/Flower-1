//
//  HP-TodoTableView.m
//  Test
//
//  Created by JonathanLu on 2018/5/7.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "HP-TodoTableView.h"


@interface HP_TodoTableView ()<UITableViewDataSource,UITableViewDelegate>
{

}
@property(strong,nonatomic)NSMutableArray *array;

@property(nonatomic,strong)NSIndexPath *selectPath;

@end

@implementation HP_TodoTableView

- (id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self) {
        // Initialization code   使用代理
        self.delegate   = self;
        self.dataSource = self;


    }
    return self;
}
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code   使用代理
        self.delegate   = self;
        self.dataSource = self;
        _array = [NSMutableArray array];
        _array = [[SQLManager shareManager]listAllTheTask];

    }
    
    return self;
}
-(void)setTableViewFrame:(CGRect)tableViewFrame
{
    self.frame = tableViewFrame;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 为其定义一个标识符，在重用机制中，标识符非常重要，这是系统用来匹配table各行cell的判断标准，在以后的学习中会体会到
    static NSString *cellIdentifier = @"cellIdentifier";
    
    // 从缓存队列中取出复用的cell
    // 从缓存队列中取出复用的cell
    TodoTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // 如果队列中cell为空，即无复用的cell，则对其进行初始化
    if (!cell) {
        // 初始化
        cell  = [TodoTableViewCell xibTableViewCell];
        for (FinishTaskM *model in _array) {
            cell.taskNameLb.text = model.finishiTask;
            cell.timeLabel.text = model.time;
            cell.numLabel.text = model.flowerNum;
            cell.idNum = model.idNum;
        }
        if (_selectPath == indexPath) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //-(int)updateTheisFinish:(FinishTaskM *)model; //给完成的任务添加相应的标示
    TodoTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    NSString *text = cell.idNum;
    NSLog(@"这个CELL的idNUm是%@",text);
    [tableView reloadData];
    [[SQLManager shareManager]updateTheisFinish:text];
    //    -(int)updateTheisFinish:(NSString *)idNum;
    int newRow = (int)[indexPath row];
    int oldRow = (int)(_selectPath != nil)?(int)[_selectPath row]: -1;
    if (newRow != oldRow) {
        UITableViewCell *newcell = [tableView cellForRowAtIndexPath:indexPath];
        newcell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldcell = [tableView cellForRowAtIndexPath:_selectPath];
        oldcell.accessoryType = UITableViewCellAccessoryNone;
        _selectPath = [indexPath copy];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

    @end
    
