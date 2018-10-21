//
//  HP-ShopViewController.m
//  KidsGrowDemo
//
//  Created by Jonathan Lu on 2018/5/4.
//  Copyright © 2018年 Jonathan Lu. All rights reserved.
//

#import "HP-ShopViewController.h"
#import "UIView+SetRect.h"
#import "GridCollectionItemView.h"
#import "GridItemCollectionViewCell.h"
#import "GridItemModel.h"
#import "AddGoodsView.h"
#import "ConfirmGoodsView.h"
#import "WishModel.h"
#import "UIView+AnimationProperty.h"
#import "UIColor+ForPublicUse.h"
#import "TotalFlowerMNG.h"
#import "DeleteGoodsView.h"
#define backGround_COLOR [UIColor colorWithRed:(254 / 255.0) green:(254 / 255.0) blue:(254 / 255.0) alpha:1]
@interface HP_ShopViewController ()<CustomCollectionViewDelegate,DeclareAbnormalAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *modelArr;

@property(nonatomic,strong)NSMutableArray *totalArr;

@property(nonatomic,strong)UIView *addGoodsCollectionView;

@property(nonatomic,strong)GridCollectionItemView *gridItemView;

@property(nonatomic,strong)UIScrollView *scroView;

@property(nonatomic,strong) WishModel *model;

@property(nonatomic,strong) UILongPressGestureRecognizer *longPress;
@end
@implementation HP_ShopViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"PingFangSC-Medium" size:20.f] forKey:UITextAttributeFont];
    self.navigationController.navigationBar.titleTextAttributes=dict;


    self.view.backgroundColor=backGround_COLOR;
    
    [super viewDidLoad];


    _scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-self.navigationController.navigationBar.height-self.tabBarController.tabBar.height-[[UIApplication sharedApplication] statusBarFrame].size.height)];
    _scroView.backgroundColor=backGround_COLOR;
    
     _modelArr = [[SQLManager shareManager]listAllWish];
    _totalArr = [[NSMutableArray alloc]initWithObjects:[GridItemModel gridItemModelWithLtitle:@"" title:@"" icon:@"addAction"], nil];
    for (WishModel *wModel in _modelArr) {
        int x = arc4random()%14;
        NSString *iconStr = [NSString stringWithFormat:@"sale_%d",x];
        NSLog(@"icon is %@",iconStr);
        [_totalArr addObject: [GridItemModel gridItemModelWithLtitle:[NSString stringWithFormat:@"%@", wModel.wish] title:[NSString stringWithFormat:@"%@",wModel.flowerNum] icon:iconStr]];
    }
    
    _gridItemView = [GridCollectionItemView gridCollectionItemViewWithCollectionItemViewWidth:_scroView.viewSize.width
                                                                                                                delegate:self
                                                                                verticalItemSpace:0
                                                                                horizontalItemSpace:0
                                                                                                          itemHeight:_scroView.viewSize.width / 3.f+30
                                                                                                         contentEdge:UIEdgeInsetsZero
                                                                                                 horizontalCellCount:3
                                                                                                       registerCells:^(CustomCollectionView *customCollectionView) {
  
                                                                                                           [customCollectionView registerClass:[GridItemCollectionViewCell class]];
                                                                                                       }
                                                                                                         addAdapters:^(NSMutableArray<CellDataAdapter *> *adapters) {
                                                                                                             
                                                                                                             [self.totalArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                                                                 
                                                                                                                 [adapters addObject:[GridItemCollectionViewCell dataAdapterWithData:obj]];
                                                                                                             }];
                                                                                                    }];
    

    _gridItemView.frame=_scroView.frame;
    [self.contentView addSubview:_scroView];
    [_scroView addSubview:_gridItemView];
    _gridItemView.left = 0.f;
    _gridItemView.top  = 0.f;

    NSLog(@"_gridItemView的adapters是%@",_gridItemView.adapters);
    self.addGoodsCollectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 125-0.5, 155-0.5)];
    self.addGoodsCollectionView.backgroundColor=backGround_COLOR;
    if (_modelArr.count == 0) {
        UIImageView *backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 160, self.view.bounds.size.width, 390)];
        backimageView.image = [UIImage imageNamed:@"page_3"];
        backimageView.tag = 120;
        [self.addGoodsCollectionView addSubview:backimageView];
    }
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.addGoodsCollectionView.center.x-25.5, self.addGoodsCollectionView.center.y-25.5, 52, 52)];
    imageView.image=[UIImage imageNamed:@"add"];
    
    [self.addGoodsCollectionView addSubview:imageView];
    
    
    [_gridItemView.collectionView addSubview:self.addGoodsCollectionView];
    
    UITapGestureRecognizer *addTouch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAction)];

    [self.addGoodsCollectionView addGestureRecognizer:addTouch];
    
    
    
    self.longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.gridItemView addGestureRecognizer:self.longPress];
    

    

//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *hUDView = [[UIVisualEffectView alloc]initWithEffect:blur];
//    hUDView.alpha = 0.9f;
//    hUDView.frame = CGRectMake(0, 480, 375, 30);
//    [_scroView addSubview:hUDView];

}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)customCollectionView:(CustomCollectionView *)customCollectionView didSelectCell:(BaseCustomCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {

    
    
   
        NSMutableArray *showArr = [NSMutableArray array];
        showArr = [[SQLManager shareManager]listAllWish];
        self.model = [[WishModel alloc]init];
        self.model = showArr[indexPath.row - 1];
    ConfirmGoodsView *view=[[ConfirmGoodsView alloc]initWithGoodName:_model.wish  flowersNumber:_model.flowerNum delegate:self];
        [view show];
    
    
}


    
-(void)sendTheFlowerNum:(NSString *)flowerNum WithGoodsName:(NSString *)goodsName{
    NSMutableArray *new_array = [NSMutableArray array];
    WishModel *wishM = [[WishModel alloc]init];
    wishM.flowerNum = flowerNum;
    NSString *writStr= [NSString stringWithFormat:@"'%@'",goodsName];
    wishM.wish =writStr;
    [[SQLManager shareManager]insertWish:wishM];
    int x = arc4random()%14;
    NSString *iconStr = [NSString stringWithFormat:@"sale_%d",x];
    [new_array insertObject:[GridItemModel gridItemModelWithLtitle:goodsName title:flowerNum icon:iconStr] atIndex:new_array.count];
    [new_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.gridItemView.adapters addObject:[GridItemCollectionViewCell dataAdapterWithData:obj]];
    }];
    [_gridItemView reloadData];
    [[self.addGoodsCollectionView viewWithTag:120]removeFromSuperview];
    
}
-(void)sendTheFlowerNum:(NSString *)flowerNum WithTitleName:(NSString *)goodsName{
    TotalFlowerMNG *manager = [[TotalFlowerMNG alloc]init];
    [manager declineTheNum:flowerNum];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"decline" object:[manager readingFile]];
}

-(void)addAction{

    [self setHighlighted:YES];
    AddGoodsView *addGoodsView = [[AddGoodsView alloc]initWithTitle:@"添加愿望" delegate:self];
    [addGoodsView show];
    [self setHighlighted:NO];
//    [self setHighlighted:NO];
}

- (void)setHighlighted:(BOOL)highlighted {
    

    
    [UIView animateWithDuration:0.35f delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
        self.addGoodsCollectionView.scale         = highlighted ? 0.95 : 1.f;
        
        self.addGoodsCollectionView.backgroundColor = highlighted ? [UIColor lineColor] : backGround_COLOR;
        
    } completion:nil];
}


-(void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer {

    CGPoint pointTouch = [gestureRecognizer locationInView:self.gridItemView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        
        NSIndexPath *indexPath = [self.gridItemView.collectionView indexPathForItemAtPoint:pointTouch];
        if (indexPath == nil) {
            NSLog(@"空");
        }else{
            NSMutableArray *showArr = [NSMutableArray array];
            showArr = [[SQLManager shareManager]listAllWish];
            self.model = [[WishModel alloc]init];
            self.model = showArr[indexPath.row - 1];
            DeleteGoodsView *view=[[DeleteGoodsView alloc]initWithGoodName:self.model.wish  delegate:self];
            [view show];
            view.deleteBlovk = ^(BOOL str) {
                if (str == YES) {
                    [self.gridItemView removeFromSuperview];
                    [[SQLManager shareManager]deleteTheWish:self->_model.idNum];
                    self->_modelArr = [[SQLManager shareManager]listAllWish];
                    self->_totalArr = [[NSMutableArray alloc]initWithObjects:[GridItemModel gridItemModelWithLtitle:@"" title:@"" icon:@"addAction"], nil];
                    for (WishModel *wModel in self->_modelArr) {
                        int x = arc4random()%14;
                        NSString *iconStr = [NSString stringWithFormat:@"sale_%d",x];
                        NSLog(@"icon is %@",iconStr);
                        [self->_totalArr addObject: [GridItemModel gridItemModelWithLtitle:[NSString stringWithFormat:@"%@", wModel.wish] title:[NSString stringWithFormat:@"%@",wModel.flowerNum] icon:iconStr]];
                    }
                    self->_gridItemView = [GridCollectionItemView gridCollectionItemViewWithCollectionItemViewWidth:self->_scroView.viewSize.width
                                                                                                     delegate:self
                                                                                            verticalItemSpace:0
                                                                                          horizontalItemSpace:0
                                                                                                         itemHeight:self->_scroView.viewSize.width / 3.f+30
                                                                                                  contentEdge:UIEdgeInsetsZero
                                                                                          horizontalCellCount:3
                                                                                                registerCells:^(CustomCollectionView *customCollectionView) {
                                                                                                    
                                                                                                    [customCollectionView registerClass:[GridItemCollectionViewCell class]];
                                                                                                }
                                                                                                  addAdapters:^(NSMutableArray<CellDataAdapter *> *adapters) {
                                                                                                      
                                                                                                      [self.totalArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                                                          
                                                                                                          [adapters addObject:[GridItemCollectionViewCell dataAdapterWithData:obj]];
                                                                                                      }];
                                                                                                  }];
                    
                    
                    
                    self->_gridItemView.frame=self->_scroView.frame;
                    [self->_scroView addSubview:self->_gridItemView];
                    self->_gridItemView.left = 0.f;
                    self->_gridItemView.top  = 0.f;
                    
                    [self.gridItemView addGestureRecognizer:self.longPress];
                    self.addGoodsCollectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 125-0.5, 155-0.5)];
                    self.addGoodsCollectionView.backgroundColor=backGround_COLOR;
                    if (self.modelArr.count == 0) {
                        UIImageView *backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 160, self.view.bounds.size.width, 390)];
                        backimageView.image = [UIImage imageNamed:@"page_3"];
                        backimageView.tag = 120;
                        [self.addGoodsCollectionView addSubview:backimageView];
                    }
                    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.addGoodsCollectionView.center.x-25.5, self.addGoodsCollectionView.center.y-25.5, 52, 52)];
                    imageView.image=[UIImage imageNamed:@"add"];
                    
                    [self.addGoodsCollectionView addSubview:imageView];
                    [self->_gridItemView.collectionView addSubview:self.addGoodsCollectionView];
                    
                    UITapGestureRecognizer *addTouch=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAction)];
                    
                    [self.addGoodsCollectionView addGestureRecognizer:addTouch];
                    
                     }
            };
            
            NSLog(@"Section = %ld,Row = %ld",(long)indexPath.section,(long)indexPath.row);
            
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }

}

@end
