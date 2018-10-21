//
//  FlowerTVC.m
//  Test
//
//  Created by Jonathan Lu on 2018/7/13.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//
#define NUMBERS @"0123456789"
#import "FlowerTVC.h"
@interface FlowerTVC()<UITextFieldDelegate>
@end
@implementation FlowerTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    self.FlowerNumberTF.delegate=self;
    self.FlowerNumberTF.tintColor=[UIColor clearColor];
    self.FlowerNumberTF.keyboardType=UIKeyboardTypeNumberPad;
    [self.FlowerNumberTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingDidEnd];
    // Initialization code
}
-(void)textFieldChanged:(UITextField *)textField{
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:textField.text,@"text", nil];
    NSNotification *notification = [NSNotification notificationWithName:@"flower" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    NSLog(@"texte is %@",textField.text);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)xibTableViewCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"FlowerTVC" owner:nil options:nil] lastObject];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    if (textField == self.FlowerNumberTF){
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 2) return NO;//限制长度
        return YES;
    }else{
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if ( proposedNewLength > 2) return NO;//限制长度
        return YES;
    }


}

    
    
    


    


    



@end
