//
//  SharePhotoViewController.m
//  Test
//
//  Created by Jonathan Lu on 2018/5/18.
//  Copyright © 2018年 JonathanLu. All rights reserved.
//

#import "SharePhotoViewController.h"
#import "HexColors.h"
#import "ImageSaveHelper.h"
#import "SQLManager.h"
#import "IconInfoModel.h"
#import "HP_TodoViewController.h"
#import "FinishTaskM.h"
#define backGround_COLOR [UIColor colorWithRed:(221 / 255.0) green:(80 / 255.0) blue:(68 / 255.0) alpha:1]
@interface SharePhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic)NSMutableArray *imageArr;



@end

@implementation SharePhotoViewController
-(instancetype)init{
    if (self = [super init]) {
        self.isExit = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageArr = [NSMutableArray array];
    self.addImage.contentMode=UIViewContentModeScaleAspectFit;
    self.addImage.userInteractionEnabled=YES;
    self.addIcon.userInteractionEnabled=YES;
    
    
    self.confirmButton.layer.cornerRadius=6;
    self.confirmButton.backgroundColor=[UIColor colorWithHexString:@"d51619" alpha:0.8f];

    [self.confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *touch1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
    
    UITapGestureRecognizer *touch2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
    
    [self.addIcon addGestureRecognizer:touch1];
    [self.addImage addGestureRecognizer:touch2];
    
    
    _textView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    _textView.layer.borderWidth = 0.6f;
    _textView.layer.cornerRadius = 6.0f;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    // Dispose of any resources that can be recreated.
}
-(void)selectImage:(UITapGestureRecognizer *)recognizer{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
           
            imagePicker.navigationBar.translucent=NO;
            imagePicker.navigationBar.barTintColor=backGround_COLOR;
            imagePicker.navigationBar.tintColor=[UIColor blackColor];
            

            
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        [alertC addAction:camera];
    }
    
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        pickerImage.navigationBar.translucent=NO;
        pickerImage.navigationBar.barTintColor=backGround_COLOR;
        pickerImage.navigationBar.tintColor=[UIColor blackColor];
//        pickerImage.navigationBar.shadowImage=[UIImage new];
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
        pickerImage.delegate = self;

        pickerImage.allowsEditing = NO;
        
        [self presentViewController:pickerImage animated:YES completion:nil];
        
    }];
    
    [alertC addAction:cancle];
    [alertC addAction:picture];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}
// 选择图片

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info

{
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    // }
    //加在视图中
    self.addImage.image=selectedImage;
    [self saveTheIcon:selectedImage];
    self.addIcon.image=[UIImage new];
    self.addImage.backgroundColor=[UIColor clearColor];
    
    
}

-(void)saveTheIcon:(UIImage *)image{
    self.isExit = YES;
    if (_imageArr.count == 0) {
        [_imageArr addObject:image];
        return;
    }
    [_imageArr replaceObjectAtIndex:0 withObject:image];
    
//    [_imageArr addObject:image];
}
-(void)confirm{
    if (_imageArr.count == 0) {
        [self dismissViewControllerAnimated:NO completion:^{
            [[NSNotificationCenter  defaultCenter]postNotificationName:@"back" object:nil];
            
        }];
    }else{
        [ImageSaveHelper saveImageArray:_imageArr andArrayName:self.taskName];
        FinishTaskM *fmodel = [[FinishTaskM alloc]init];
        fmodel = [[SQLManager shareManager]showTheTaskWith:self.taskIdNum];
        IconInfoModel *iconMd = [[IconInfoModel alloc]init];
        iconMd.iconName = [NSString stringWithFormat:@"'%@'",fmodel.finishiTask];//fmodel.finishiTask;
        iconMd.flowerNum = fmodel.flowerNum;
        iconMd.exp = [NSString stringWithFormat:@"'%@'",self.textView.text];
        [[SQLManager shareManager]insertIcon:iconMd];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"saveimage" object:nil];
        [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"back" object:nil];
        
    }];
    }
}
// 取消选取图片

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)returnBOOL{
    return YES;
}

@end
