//
//  HPTabBarView.h
//  Test
//
//  Created by Jonathan Lu on 2018/5/23.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICountingLabel.h"

@class HPTabBarView;


@protocol HPTabBarViewDelegate <NSObject>

- (void)HPTabBarView:(HPTabBarView *)view didSelectItemAtIndex:(NSInteger)index;



@end

@interface HPTabBarView : UIView

@property (nonatomic, weak) id<HPTabBarViewDelegate> viewDelegate;
@property (weak, nonatomic) IBOutlet UICountingLabel *countingLb;
@property (weak, nonatomic) IBOutlet UIButton *redFlower;

//-(void)countingAddTo:(NSString *)Number;
@end
