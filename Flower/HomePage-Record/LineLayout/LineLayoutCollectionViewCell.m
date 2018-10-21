//
//  LineLayoutCollectionViewCell.m
//  Animations
//
//  Created by YouXianMing on 2017/10/30.
//  Copyright © 2017年 YouXianMing. All rights reserved.
//

#import "LineLayoutCollectionViewCell.h"

#import "AutolayoutPlaceholderImageView.h"
#import "Masonry.h"
#import "SQLManager.h"
#import "ImageSaveHelper.h"

@interface LineLayoutCollectionViewCell ()

@property (nonatomic, strong) UIView                         *areaView;
@property (nonatomic, strong) AutolayoutPlaceholderImageView *iconImageView;
@property (nonatomic, strong)UIImage *image1;
@property (nonatomic, strong)NSString *nameStr;
@property (nonatomic, strong)NSMutableArray *finishArr;
@property (nonatomic, strong)NSMutableArray *imageArr;
@property (nonatomic, strong)NSMutableArray *nameARR;
@end

@implementation LineLayoutCollectionViewCell

- (void)buildSubview {
    self.finishArr = [NSMutableArray array];
    self.finishArr = [[SQLManager shareManager]listAllTheIconName];
    self.nameARR = [NSMutableArray array];
    self.nameStr = [NSString string];
    self.imageArr = [NSMutableArray array];
    self.iconImageView                  = [AutolayoutPlaceholderImageView new];


    /*更改代码*/
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(3);
        make.right.mas_equalTo(-3);
        make.top.mas_equalTo(3);
        make.bottom.mas_equalTo(-3);
    }];
    for (IconInfoModel *model in self.finishArr) {
        _nameStr = model.iconName;
        [_nameARR addObject:_nameStr];
    }
    for (int i = 0; i <= _nameARR.count -1; i++) {
        [_imageArr addObject: [ImageSaveHelper getImageArrayWithName:[NSString stringWithFormat:@"%@",_nameARR[i]]]];
    }
}

- (void)loadContentwithNum:(NSIndexPath *)indexPath
{

    if (indexPath.section > _nameARR.count -1) {
        NSString *maxNum = [[SQLManager shareManager]searchTheMAxInfo];
        IconInfoModel *model = [[SQLManager shareManager]showTheIconInfoWith:maxNum];
        [_imageArr addObject:[ImageSaveHelper getImageArrayWithName:[NSString stringWithFormat:@"%@",model.iconName]]];
        self.image1 = _imageArr[indexPath.section -1][0];
        self.iconImageView.showImage  = _image1;
    }else{
    self.image1 = _imageArr[indexPath.section][0];
    self.iconImageView.showImage  = _image1;
    }
}


@end
