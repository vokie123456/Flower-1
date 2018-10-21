//
//  LineLayoutViewController.m
//  Animations
//
//  Created by YouXianMing on 2017/10/16.
//  Copyright © 2017年 YouXianMing. All rights reserved.
//

#import "HP-RecordViewController.h"
#import "ComplexLineLayout.h"

#import "LineLayoutCollectionViewCell.h"
#import "Masonry.h"
#import "WanDouJiaModel.h"
#import "NSData+JSONData.h"
#import "FileManager.h"
#import "SQLManager.h"
#import "IconInfoModel.h"
#import "ImageSaveHelper.h"
#import "UIView+frameAdjust.h"
#import <ChameleonFramework/Chameleon.h>
#define backGround_COLOR [UIColor colorWithRed:(246 / 255.0) green:(246 / 255.0) blue:(246 / 255.0) alpha:1]
@interface HP_RecordViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray <CellDataAdapter *> *adapters;
@property (nonatomic, strong) UICollectionView                   *collectionView;
@property (nonatomic, strong) UICollectionViewLayout             *layout;
@property (nonatomic,strong)NSMutableArray *imageCountArr;

@property (nonatomic,strong) UIView *detailView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *finishDateLabel;
@property (nonatomic,strong) UITextView *detailTextView;
@property (nonatomic,strong) NSMutableArray *finishArr;


@end

@implementation HP_RecordViewController

- (void)viewDidLoad {
        [super viewDidLoad];
    self.contentView.backgroundColor=backGround_COLOR;

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:20.f] forKey:UITextAttributeFont];
    self.navigationController.navigationBar.titleTextAttributes=dict;
    static NSInteger layoutType = 0;
    layoutType                 += 1;
    self.adapters         = [NSMutableArray array];
    _finishArr = [NSMutableArray array];
    _finishArr = [[SQLManager shareManager]listAllTheIconName];
    NSMutableArray *nameARR = [NSMutableArray array];
    NSString *nameStr = [NSString string];
    NSString *timeStr = [NSString string];
    NSString *expStr = [NSString string];
    _imageCountArr = [NSMutableArray array];
    for (IconInfoModel *model in _finishArr) {
        if (_finishArr.count == 1) {
            timeStr = model.time;
            expStr = model.exp;
            nameStr = model.iconName;
        }
            nameStr = model.iconName;
            [nameARR addObject:nameStr];
        }
        for (int i = 0; i < nameARR.count; i++) {
            [_imageCountArr addObject: [ImageSaveHelper getImageArrayWithName:[NSString stringWithFormat:@"%@",nameARR[i]]]];
        }
    [self.adapters addObject:[LineLayoutCollectionViewCell AdapterWithArray:_imageCountArr]];
    
    // 布局文件
    self.layout                         = [ComplexLineLayout new];
    self.collectionView                 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.delegate        = self;
    self.collectionView.dataSource      = self;
    self.collectionView.contentInset    = UIEdgeInsetsMake(10, 50, 10, 50);
    self.collectionView.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:self.collectionView];
    


    [LineLayoutCollectionViewCell      registerToCollectionView:self.collectionView];
    
    // collectionView的一些配置
    self.collectionView.layer.borderWidth = 0.5f;
    self.collectionView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f].CGColor;
    self.collectionView.showsVerticalScrollIndicator   = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.contentView);
        make.left.mas_offset(10);
        make.right.mas_offset(-10);
        make.height.equalTo(self.contentView).multipliedBy(0.4f);
        make.top.mas_offset(10);
        

    }];
    [self.contentView layoutIfNeeded];
   
    
    self.detailView =[[UIView alloc]initWithFrame:CGRectMake(22, self.collectionView.maxY+20, self.contentView.width-44, 230)];
    self.detailView.layer.cornerRadius=8.f;
    
    self.detailView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.detailView.layer.shadowOffset=CGSizeMake(0.3f, 0.3f);
    self.detailView.layer.shadowRadius=6.f;
    self.detailView.layer.shadowOpacity=0.3f;
   
    self.detailView.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:self.detailView.frame andColors:@[[UIColor flatYellowColor],[UIColor flatYellowColorDark]]];
    
    [self.contentView addSubview:self.detailView];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-44, 50)];
    self.titleLabel.text= [NSString stringWithFormat:@"%@",nameStr];
    [self.detailView addSubview:self.titleLabel];
    
    self.finishDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, self.titleLabel.maxY+10, self.titleLabel.width, 20)];
    self.finishDateLabel.text= [NSString stringWithFormat:@"%@",timeStr];
    self.finishDateLabel.font=[UIFont systemFontOfSize:12.f];
    [self.detailView addSubview:self.finishDateLabel];
    
    self.detailTextView=[[UITextView alloc]initWithFrame:CGRectMake(20, self.finishDateLabel.maxY+20, self.titleLabel.width,100)];
    self.detailTextView.text=[NSString stringWithFormat:@"%@",expStr];
    self.detailTextView.backgroundColor=[UIColor clearColor];
    self.detailTextView.editable=NO;
    [self.detailView addSubview:self.detailTextView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTheoffset:) name:@"offset" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTheView) name:@"saveimage" object:nil];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.imageCountArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.adapters.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseCustomCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.adapters[indexPath.row].cellReuseIdentifier forIndexPath:indexPath];
    cell.image                      = self.adapters[indexPath.row].array[indexPath.row];
    cell.indexPath                 = indexPath;
    [cell loadContentwithNum:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    NSLog(@"%@", indexPath);

}
-(void)getTheoffset:(NSNotification *)offset{
    CGFloat cgoffset = [offset.userInfo[@"offset"] floatValue];
    NSUInteger num = cgoffset / 170;
    NSLog(@"这是第%lu张图",(unsigned long)num);
    if (_finishArr.count <= num) {
        num = _finishArr.count -1;
    }
    IconInfoModel *model = [[IconInfoModel alloc]init];
    model = _finishArr[num];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.iconName];
    self.finishDateLabel.text = [NSString stringWithFormat:@"%@",model.time];
    self.detailTextView.text = [NSString stringWithFormat:@"%@",model.exp];

}
-(void)refreshTheView{
    NSLog(@"刷新View");
    NSString *maxStr = [[SQLManager shareManager]searchTheMAxInfo];
    IconInfoModel *model = [[SQLManager shareManager]showTheIconInfoWith:maxStr];
    [_imageCountArr addObject:[ImageSaveHelper getImageArrayWithName:model.iconName]];
    [_finishArr addObject:model];
    self.adapters         = [NSMutableArray array];
    [self.adapters addObject:[LineLayoutCollectionViewCell AdapterWithArray:_imageCountArr]];
    [_collectionView insertSections:[NSIndexSet indexSetWithIndex:[maxStr intValue] - 1]];
    
}

@end
