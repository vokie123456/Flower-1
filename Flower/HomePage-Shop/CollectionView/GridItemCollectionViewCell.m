//
//  GridItemCollectionViewCell.m
//  Animations
//
//  Created by YouXianMing on 2017/7/11.
//  Copyright © 2017年 YouXianMing. All rights reserved.
//

#import "GridItemCollectionViewCell.h"
#import "GridItemModel.h"
#import "Masonry.h"
#import "UIColor+ForPublicUse.h"
#import "UIView+AnimationProperty.h"


@interface GridItemCollectionViewCell ()

@property (nonatomic, strong) UIView      *rightLine;
@property (nonatomic, strong) UIView      *downLine;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *LtitleLabel;
@property (nonatomic, strong) UIImageView *flowerIcon;
@property (nonatomic, strong) UILabel *multipleIcon;

//@property (nonatomic, strong) UILabel   *
@end

@implementation GridItemCollectionViewCell

- (void)setupCell {
    
    self.contentView .backgroundColor = [UIColor clearColor];
    
    // KohinoorDevanagari-Light
}

- (void)buildSubview {
    
    self.rightLine = [UIView new];
    self.rightLine.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:self.rightLine];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.right.equalTo(self.contentView);
        make.height.equalTo(self.contentView);
        make.width.mas_equalTo(0.5f);
    }];
    
    self.downLine                 = [UIView new];
    self.downLine.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:self.downLine];
    
    [self.downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.contentView);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.width.equalTo(self.contentView);
    }];
    
    self.imageView                 = [UIImageView new];
    [self.contentView addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-25);
        make.width.mas_equalTo(52);
        make.height.mas_equalTo(52);
        make.center.equalTo(self.contentView);
    }];
    
    self.titleLabel               = [UILabel new];
    self.titleLabel.font          = [UIFont fontWithName:@"KohinoorDevanagari-Light" size:15.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
        make.centerX.equalTo(self.contentView).mas_equalTo(20);

    }];
    
    self.flowerIcon              =[UIImageView new];
    self.flowerIcon.image=[UIImage imageNamed:@"6"];
    [self.contentView addSubview:self.flowerIcon];
    [self.flowerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
        make.centerX.equalTo(self.contentView).mas_equalTo(-22);
    }];
    
    
    

    
    self.LtitleLabel               = [UILabel new];
    self.LtitleLabel.font          =[UIFont fontWithName:@"AppleSDGothicNeo-Light" size:18.f];
    self.LtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.LtitleLabel];
    
    [self.LtitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self.contentView.mas_top).offset(115.f);
        make.centerX.equalTo(self.contentView);
    }];
    
    
}

- (void)loadContent {
    
    GridItemModel *model = self.data;
    self.imageView.image = [UIImage imageNamed:model.icon];
    self.titleLabel.text = model.title;
    self.LtitleLabel.text = model.Ltitle;
}

- (void)setHighlighted:(BOOL)highlighted {
    
    [super setHighlighted:highlighted];
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        
        self.imageView.scale             = highlighted ? 0.95 : 1.f;
        self.titleLabel.alpha            = highlighted ? 0.85 : 1.f;
        self.LtitleLabel.alpha            = highlighted ? 0.85 : 1.f;
        self.contentView.backgroundColor = highlighted ? [UIColor lineColor] : [UIColor clearColor];
        
    } completion:nil];
}

@end
