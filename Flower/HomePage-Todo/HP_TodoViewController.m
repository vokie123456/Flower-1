//
//  HP_TodoViewControllerTableViewController.m
//  Test
//
//  Created by JonathanLu on 2018/5/7.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "HP_TodoViewController.h"
#import "SharePhotoViewController.h"
#import "HexColors.h"
#import "UIView+frameAdjust.h"
#import "TotalFlowerMNG.h"
#import "HomePageTabBarViewController.h"
#import "HP_TodoVC_TipView.h"
#import "CountVC.h"
#import "AddAlertVC.h"
#import <ChameleonFramework/Chameleon.h>
#import "ZYGSegment.h"
#define backGround_COLOR [UIColor colorWithRed:(221 / 255.0) green:(80 / 255.0) blue:(68 / 255.0) alpha:1]
@interface HP_TodoViewController ()<UITableViewDataSource,UITableViewDelegate,DeclareAbnormalAlertViewDelegate,ZYGSegmentControlDelegate>
@property(nonatomic,strong) UITableView *todoTableView;

@property (strong, nonatomic) NSIndexPath* editingIndexPath;  //当前左滑cell的index，在代理方法中设置

@property (nonatomic, strong) UIImageView *addTodoView;

@property(strong,nonatomic)NSMutableArray *array;

@property(nonatomic,strong)NSIndexPath *selectPath;

@property(nonatomic,strong)UITableView *finishTaskView;

@property(strong,nonatomic)NSMutableArray *finishArr;


@end

@implementation HP_TodoViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.editingIndexPath)
    {
        [self configSwipeButtons];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [NSMutableArray array];
    _array = [[SQLManager shareManager]listAllTheTask];
    _finishArr = [NSMutableArray array];
    _finishArr = [[SQLManager shareManager]listAllTheFinishT];
    
    
    self.navigationController.navigationBar.barTintColor= [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;

    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:20.f] forKey:UITextAttributeFont];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    
    UIBarButtonItem *recordButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"折线图"] style:UIBarButtonItemStylePlain target:self action:@selector(recordButtonClicked)];
    recordButtonItem.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem=recordButtonItem;
    
    UIBarButtonItem *addTodoButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"添加"] style:UIBarButtonItemStylePlain target:self action:@selector(addTodo)];
    addTodoButtonItem.tintColor=[UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem=addTodoButtonItem;



    self.view.backgroundColor=[UIColor colorWithRed:(250/255.0) green:(250/255.0) blue:(250/255.0) alpha:1];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 0.6)];
    lineView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:lineView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-60, lineView.center.y-10, 120, 20)];
    label.backgroundColor=self.view.backgroundColor;
    label.textColor=[UIColor blackColor];
    /*获取当前时间*/
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    label.text = currentDateStr;
    label.textAlignment=NSTextAlignmentCenter;
    label.textAlignment=NSTextAlignmentCenter;

    [self.view addSubview:label];
    
    //todoTableView的设置
    _todoTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 75, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-lineView.maxY-49)  style:UITableViewStyleGrouped];
    _todoTableView.backgroundColor=[UIColor colorWithHexString:@"#FFFFFF"];
    _todoTableView.delegate = self;
    _todoTableView.dataSource = self;
    _todoTableView.separatorStyle=NO;
    if (_array.count == 0) {
        UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
        [backImageView setImage:[UIImage imageNamed:@"page_1"]];
        _todoTableView.backgroundView = backImageView;
    }
    _addTodoView=[[UIImageView alloc]initWithFrame:CGRectMake(300, 450, 52, 52)];
    _addTodoView.userInteractionEnabled = YES;//打开用户交互
    _addTodoView.image=[UIImage imageNamed:@"addTodo"];
    [_todoTableView addSubview:_addTodoView];
    UITapGestureRecognizer *addTodoTouch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTodo)];
    
    [_addTodoView addGestureRecognizer:addTodoTouch];
    
    //finishTaskView的设置
    _finishTaskView = [[UITableView alloc]initWithFrame:CGRectMake(0, 75, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-lineView.maxY-49)  style:UITableViewStyleGrouped];
    _finishTaskView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _finishTaskView.delegate = self;
    _finishTaskView.dataSource = self;
    _finishTaskView.separatorStyle=NO;
    if (_finishArr.count == 0) {
        UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
        [backImageView setImage:[UIImage imageNamed:@"page_2"]];
        _finishTaskView.backgroundView = backImageView;
    }
    [self setupTheSegment];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(insertCell) name:@"insert" object:nil];
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:_todoTableView]) {
         return _array.count;
    }else if ([tableView isEqual:_finishTaskView])
        return _finishArr.count;
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_todoTableView]) {
        
    TodoTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        
    
    // 1.弹框提醒
        TipAlertView *TAV=[[TipAlertView alloc]initWithTitle:@"提示" delegate:self mode:TipMode leftButtonTitle:@"确认" rightButtonTitle:@"取消" tipText:@"确认是否已经完成" selectedCell:cell];
        [TAV show];
        
        __weak typeof(self)weakself = self;
        TAV.returnValueBlock = ^(BOOL str){
            if(str==YES){
                NSString *text = cell.idNum;
                NSLog(@"这个CELL的idNUm是%@",text);
                [[SQLManager shareManager]updateTheisFinish:text];
                [[SQLManager shareManager]countTheFinish:text];
                weakself.array = [[SQLManager shareManager]listAllTheTask];
                [UIView animateWithDuration:1 animations:^{
                    /*添加照片view*/
                    SharePhotoViewController
                    *shareView=[SharePhotoViewController new];
                    [weakself presentViewController:shareView animated:YES completion:nil];
                    shareView.taskName = cell.taskNameLb.text;
                    shareView.taskIdNum = cell.idNum;
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } completion:^(BOOL finished) {
                    [weakself.todoTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                    
                }];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                TotalFlowerMNG *numMG = [[TotalFlowerMNG alloc]init];
                [numMG writeToFile:cell.numLabel.text];
                NSLog(@"total num is %@",[numMG readingFile]);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"flonum" object:[numMG readingFile]];
                UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
                backImageView.backgroundColor = [UIColor whiteColor];
                self.finishTaskView.backgroundView = backImageView;
                if (self.array.count == 0) {
                    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
                    [backImageView setImage:[UIImage imageNamed:@"page_1"]];
                    self.todoTableView.backgroundView = backImageView;
                }
            }
        };

    }
}
-(void)sendTheFlowerNum:(NSString *)flowerNum WithTitle:(NSString *)title{
    
    FinishTaskM *fModel = [[FinishTaskM alloc]init];
    fModel.flowerNum = flowerNum;
    fModel.finishiTask = title;
    [[SQLManager shareManager]insertTask:fModel];
    _array = [[SQLManager shareManager]listAllTheTask];
    [self.todoTableView beginUpdates];
    [self.todoTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.todoTableView endUpdates];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_todoTableView]) {
    // 为其定义一个标识符，在重用机制中，标识符非常重要，这是系统用来匹配table各行cell的判断标准，在以后的学习中会体会到
    static NSString *cellIdentifier = @"cellIdentifier";
    

    TodoTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // 如果队列中cell为空，即无复用的cell，则对其进行初始化
    if (!cell) {
        
        // 初始化
        cell  = [TodoTableViewCell xibTableViewCell];
        cell.layer.cornerRadius=8.f;

        cell.layer.shadowColor=[UIColor blackColor].CGColor;
        cell.layer.shadowOffset=CGSizeMake(0.3f, 0.3f);
        cell.layer.shadowRadius=6.f;
        cell.layer.shadowOpacity=0.3f;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for (int i =0; i<[_array count]; i++) {
            if (indexPath.section == i) {
                FinishTaskM *model = [[FinishTaskM alloc]init];
                model = [_array objectAtIndex:[_array count] - i -1];
                cell.taskNameLb.text = model.finishiTask;
                cell.timeLabel.text = model.time;
                cell.numLabel.text = model.flowerNum;
                cell.idNum = model.idNum;
                //提取出颜色的RGB值
                NSArray *fColorArr = [model.firstColor componentsSeparatedByString:@" "];
                NSArray *lColorArr = [model.lastColor componentsSeparatedByString:@" "];
                NSLog(@"%.f",[fColorArr[0] floatValue]);
                if (fColorArr.count  == 1 || lColorArr.count == 1) {
                cell.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, self.view.width-44, cell.height) andColors:@[[UIColor colorWithRed:1 green:0.802 blue:0.00999999 alpha:1],[UIColor colorWithRed:1 green:0.666667 blue:0 alpha:1]]];
                }else{
                cell.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, self.view.width-44, cell.height) andColors:@[[UIColor colorWithRed:[fColorArr[1] floatValue] green:[fColorArr[2] floatValue] blue:[fColorArr[3] floatValue] alpha:1],[UIColor colorWithRed:[lColorArr[1] floatValue] green:[lColorArr[2] floatValue] blue:[lColorArr[3] floatValue] alpha:1]]];
                }
                
                //_firstColor    __NSCFString *    @"UIExtendedSRGBColorSpace 0.184 0.8 0.440667 1"    0x0000600000277300
                //_lastColor    __NSCFString *    @"UIExtendedSRGBColorSpace 0.1496 0.68 0.3706 1"    0x00006000002756c0
            }
        }
    }
    return cell;
    }
    if ([tableView isEqual:_finishTaskView]){
    static NSString *cellIdentifier = @"cellIdentifier";
    
    // 从缓存队列中取出复用的cell
    // 从缓存队列中取出复用的cell
    TodoTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // 如果队列中cell为空，即无复用的cell，则对其进行初始化
    if (!cell) {
        // 初始化
        cell  = [TodoTableViewCell xibTableViewCell];
        cell.layer.cornerRadius=8.f;
        
        cell.layer.shadowColor=[UIColor blackColor].CGColor;
        cell.layer.shadowOffset=CGSizeMake(0.3f, 0.3f);
        cell.layer.shadowRadius=6.f;
        cell.layer.shadowOpacity=0.3f;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.tipLabel.text=@"今日红花数";
        
        
        for (int i =0; i<[_finishArr count]; i++) {
            if (indexPath.section == i) {
                FinishTaskM *model = [[FinishTaskM alloc]init];
                model = [_finishArr objectAtIndex:[_finishArr count] - i -1];
                cell.taskNameLb.text = model.finishiTask;
                cell.timeLabel.text = model.time;
                cell.numLabel.text = model.flowerNum;
                cell.idNum = model.idNum;
                //提取出颜色的RGB值
                NSArray *fColorArr = [model.firstColor componentsSeparatedByString:@" "];
                NSArray *lColorArr = [model.lastColor componentsSeparatedByString:@" "];
                NSLog(@"%.f",[fColorArr[0] floatValue]);
                if (fColorArr.count  == 1 || lColorArr.count == 1) {
                    cell.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, self.view.width-44, cell.height) andColors:@[[UIColor colorWithRed:1 green:0.802 blue:0.00999999 alpha:1],[UIColor colorWithRed:1 green:0.666667 blue:0 alpha:1]]];
                }else{
                    cell.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, self.view.width-44, cell.height) andColors:@[[UIColor colorWithRed:[fColorArr[1] floatValue] green:[fColorArr[2] floatValue] blue:[fColorArr[3] floatValue] alpha:1],[UIColor colorWithRed:[lColorArr[1] floatValue] green:[lColorArr[2] floatValue] blue:[lColorArr[3] floatValue] alpha:1]]];
                }
                
                //_firstColor    __NSCFString *    @"UIExtendedSRGBColorSpace 0.184 0.8 0.440667 1"    0x0000600000277300
                //_lastColor    __NSCFString *    @"UIExtendedSRGBColorSpace 0.1496 0.68 0.3706 1"    0x00006000002756c0
            }
        }
    }
    return cell;
    }
    return nil;
}
-(void)addTodo{
    NSLog(@"添加任务");

    AddAlertVC *VC=[AddAlertVC new];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:VC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"flonum"]) {
        NSLog(@"值更新了");
    }
}
-(void)recordButtonClicked{
    CountVC *vc=[CountVC new];
    vc.title=@"统计";
    
    self.navigationItem.hidesBackButton=YES;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    backBtn.tintColor=[UIColor blackColor];
    
    
    vc.navigationItem.leftBarButtonItem = backBtn;
//    
    [vc.tabBarController.tabBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController pushViewController:vc animated:YES];
   
    
}
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if([tableView isEqual:self.finishTaskView]){
        return @[];
    }
    TodoTableViewCell *cell=[_todoTableView cellForRowAtIndexPath:indexPath];
    //收回操作
    UITableViewRowAction *withdrawAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收回" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
        
        TipAlertView *withdrawTAV=[[TipAlertView alloc]initWithTitle:@"收回提示" delegate:self mode:TipMode leftButtonTitle:@"确认收回" rightButtonTitle:@"取消" tipText:@"确认是否收回，我们在明天还会为你自动生成" selectedCell:cell];
        [withdrawTAV show];
        withdrawTAV.recycleBlock = ^(BOOL str) {
            if (str == YES) {
                [[SQLManager shareManager]updateTheRecevalFinish:cell.idNum];
                self->_array = [[SQLManager shareManager]listAllTheTask];
                [self.todoTableView beginUpdates];
                [self.todoTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationMiddle];
                 [self.todoTableView endUpdates];
            }
        };
        /*添加代码*/
    }];
    
    
    //删除操作
    UITableViewRowAction *deleteAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
        
        TipAlertView *deleteTAV=[[TipAlertView alloc]initWithTitle:@"删除提示" delegate:self mode:TipMode leftButtonTitle:@"确认删除" rightButtonTitle:@"取消" tipText:@"确认是否删除，我们会删除你以后所有该习惯的安排，但保留模板" selectedCell:cell];
        [deleteTAV show];
        deleteTAV.confirmDeleBlock = ^(BOOL str) {
            if (str == YES) {
                [[SQLManager shareManager]deleteTheTask:cell.idNum];
                self->_array = [[SQLManager shareManager]listAllTheTask];
                [self.todoTableView beginUpdates];
                [self.todoTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationMiddle];
                [self.todoTableView endUpdates];
                if (self.array.count == 0) {
                    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
                    [backImageView setImage:[UIImage imageNamed:@"page_1"]];
                    self.todoTableView.backgroundView = backImageView;
                }
            }
            
        };
//
        /*添加代码*/
        
        
    }];
    return @[deleteAction,withdrawAction];
    
}
- (void)configSwipeButtons
{
    for (UIView *subview in self.todoTableView.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 2)
        {
            // 和iOS 10的按钮顺序相反
            UIButton *deleteButton = subview.subviews[1];
            UIButton *withdrawButton = subview.subviews[0];
            
            
            [self configDeleteButton:deleteButton];
            [self configWithdrawButton:withdrawButton];
            
            
            
            CGRect frame=subview.frame;
            frame.origin.x+=20;
            subview.frame=frame;

        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_todoTableView]){
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_todoTableView]){
    self.editingIndexPath = nil;
    }
}
- (void)configDeleteButton:(UIButton*)deleteButton
{
    if (deleteButton)
    {
        [deleteButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:10.0]];
        [deleteButton setTitleColor:[UIColor colorWithHexString:@"D0021B"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"编辑模式删除"] forState:UIControlStateNormal];
        [deleteButton setBackgroundColor:[UIColor colorWithHexString:@"E5E8E8"]];
        // 调整按钮上图片和文字的相对位置（该方法的实现在下面）
        [self centerImageAndTextOnButton:deleteButton];
        
        deleteButton.backgroundColor=[UIColor whiteColor];
        
    }
}
- (void)configWithdrawButton:(UIButton*)withdrawButton
{
    if (withdrawButton)
    {
        [withdrawButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:10.0]];
        [withdrawButton setTitleColor:[UIColor colorWithHexString:@"4A90E2"] forState:UIControlStateNormal];
        
        UIImage *readButtonImage = [UIImage imageNamed:@"编辑模式收回"];
        [withdrawButton setImage:readButtonImage forState:UIControlStateNormal];
        
        [withdrawButton setBackgroundColor:[UIColor colorWithHexString:@"E5E8E8"]];
        // 调整按钮上图片和文字的相对位置（该方法的实现在下面）
        [self centerImageAndTextOnButton:withdrawButton];
        
        withdrawButton.backgroundColor=[UIColor whiteColor];
        
    }
}

- (void)centerImageAndTextOnButton:(UIButton*)button
{
    // this is to center the image and text on button.
    // the space between the image and text
    CGFloat spacing = 45.0;
    
    // lower the text and push it left so it appears centered below the image
    CGSize imageSize = button.imageView.image.size;
    imageSize.height=40;
    imageSize.width=40;
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = (titleSize.height - imageSize.height) / 2.0;
    button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    
    
}
-(void)setupTheSegment{
    ZYGSegment *seg = [ZYGSegment initSegment];
    seg.delegate = self;
    [seg addItems:@[@"未完成",@"已完成"] frame:CGRectMake(0, 40, self.view.frame.size.width, 35) inView:(UIView *)self.view];
    NSMutableArray *viewArr = [[NSMutableArray alloc]init];
    [viewArr addObject:(UIView *)_todoTableView];
    [viewArr addObject:(UIView *)_finishTaskView];
    seg.segSubviews = viewArr;
}
-(void)insertCell{
    _array = [[SQLManager shareManager]listAllTheTask];
    [self.todoTableView beginUpdates];
    [self.todoTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    [self.todoTableView endUpdates];
    if (_array.count != 0) {
        UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
        backImageView.backgroundColor = [UIColor whiteColor];
        self.todoTableView.backgroundView = backImageView;
    }
}
-(void)didSelectSegmentAtIndex:(NSInteger)selectedIndex{
    if (selectedIndex == 1) {
        _finishArr = [[SQLManager shareManager]listAllTheFinishT];
        [self.finishTaskView reloadData];

    }
}

@end
