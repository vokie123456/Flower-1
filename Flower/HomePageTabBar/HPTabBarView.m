//
//  HPTabBarView.m
//  Test
//
//  Created by Jonathan Lu on 2018/5/23.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "HPTabBarView.h"
#import "TotalFlowerMNG.h"


@interface HPTabBarView ()

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *items;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation HPTabBarView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor=[UIColor clearColor];

}
#pragma mark - Actions

- (IBAction)showTheButton:(id)sender {
    NSLog(@"点击小红花啦，旋转");
    [self spain];
//    [UIView ];
}
- (IBAction)selectItem:(UIButton *)sender
{
    // button的tag对应tabBarController的selectedIndex
    // 设置选中button的样式
    self.selectIndex = sender.tag;
    // 让代理来处理切换viewController的操作
    if ([self.viewDelegate respondsToSelector:@selector(HPTabBarView:didSelectItemAtIndex:)]) {
        [self.viewDelegate HPTabBarView:self didSelectItemAtIndex:sender.tag];
    }
}
-(void)spain{
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.redFlower.transform = CGAffineTransformRotate(self.redFlower.transform, M_PI);
    } completion:nil];
}
//- (IBAction)clickCenterItem:(id)sender
//{
//    // 让代理来处理点击中间button的操作
//    if ([self.viewDelegate respondsToSelector:@selector(msTabBarViewDidClickCenterItem:)]) {
//        [self.viewDelegate msTabBarViewDidClickCenterItem:self];
//    }
//}

#pragma mark - Setter

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if(_selectIndex==0){
        UIButton *lastItem = _items[0];
        [lastItem setSelected:NO];
    }
    
    // 先把上次选择的item设置为可用
    UIButton *lastItem = _items[_selectIndex];
    [lastItem setEnabled:YES];
    // 再把这次选择的item设置为不可用
    if(selectIndex==0){
        UIButton *item = _items[selectIndex];
        [item setEnabled:YES];

    }
    UIButton *item = _items[selectIndex];
    [item setEnabled:NO];
    
    
    _selectIndex = selectIndex;
    
    

}
@end
