//
//  TodoTableViewCell.h
//  Test
//
//  Created by Jonathan Lu on 2018/5/8.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *taskNameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property(nonatomic,strong) NSString *idNum;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

+(instancetype)xibTableViewCell;
@end
