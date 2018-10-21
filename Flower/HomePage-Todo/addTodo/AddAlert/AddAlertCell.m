//
//  AddAlertCell.m
//  Test
//
//  Created by Jonathan Lu on 2018/7/11.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "AddAlertCell.h"
@interface AddAlertCell()

@end
@implementation AddAlertCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
+(instancetype)xibTableViewCell {
    //在类方法中加载xib文件,注意:loadNibNamed:owner:options:这个方法返回的是NSArray,所以在后面加上firstObject或者lastObject或者[0]都可以;因为我们的Xib文件中,只有一个cell
    return  [[[NSBundle mainBundle] loadNibNamed:@"AddAlertCell" owner:nil options:nil] lastObject];
    
    
}
- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += 22;
    
    frame.size.width -= 2 * 22;
    
    [super setFrame:frame];
    
}
@end
