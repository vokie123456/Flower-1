//
//  AddAlertCell.h
//  Test
//
//  Created by Jonathan Lu on 2018/7/11.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAlertCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *cellTextLabel;

+ (instancetype)xibTableViewCell;
@end
