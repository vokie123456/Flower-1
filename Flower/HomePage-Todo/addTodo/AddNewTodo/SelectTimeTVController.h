//
//  SelectTimeTVController.h
//  Test
//
//  Created by Jonathan Lu on 2018/7/13.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnValueBlock) (NSString *strValue);
@interface SelectTimeTVController : UITableViewController


@property(nonatomic, copy) ReturnValueBlock returnValueBlock;

@end
