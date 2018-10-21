//
//  HeaderTVC.h
//  Test
//
//  Created by Jonathan Lu on 2018/7/12.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UIScrollView *colorSelectScrollView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *colorShowView;
@property (strong, nonatomic) IBOutlet UIButton *yellowButton;
@property (strong, nonatomic) UIButton *redButton;
@property (strong, nonatomic) UIButton *pinkButton;
@property (strong, nonatomic) UIButton *skyBlueButton;
@property (strong, nonatomic) UIButton *greenButton;
@property (strong, nonatomic) UIButton *purpleButton;
@property (strong, nonatomic) UIButton *orangeButton;
@property (strong, nonatomic) UIButton *maroonButton;
@property (strong, nonatomic) UIButton *watermelonButton;
@property (strong, nonatomic) UIButton *sandButton;
@property (strong, nonatomic) UIButton *blackButton;

//@property (strong, nonatomic) UIImageView *selectIamgeView;
//@property (strong, nonatomic) UIButton *selectButton;
+(instancetype)xibTableViewCell;
@end
