//
//  SharePhotoViewController.h
//  Test
//
//  Created by Jonathan Lu on 2018/5/18.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIImageView *addIcon;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property(strong,nonatomic)NSString *taskName;
@property(strong,nonatomic)NSString *taskIdNum;
@property BOOL isExit;
@property (strong, nonatomic) IBOutlet UITextView *textView;



@end
