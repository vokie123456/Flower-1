//
//  AutolayoutPlaceholderImageView.m
//  TechcodeEn_iPad
//
//  Created by YouXianMing on 2017/10/26.
//  Copyright © 2017年 Techcode. All rights reserved.
//

#import "AutolayoutPlaceholderImageView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface AutolayoutPlaceholderImageView ()

@property (nonatomic, strong) UIImageView *placeHoderImageView;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) NSString    *pUrlString;
@property (nonatomic,strong) UIImage *image;

@end

@implementation AutolayoutPlaceholderImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:CGRectZero]) {
    
        [self buildSubviews];
    }
    
    return self;
}

- (instancetype)init {
    
    if (self = [super init]) {
    
        [self buildSubviews];
    }
    
    return self;
}

- (void)buildSubviews {
    
    self.layer.masksToBounds = YES;
    
//    self.placeHoderImageView = [UIImageView new];
    self.contentImageView    = [UIImageView new];
//    [self addSubview:self.placeHoderImageView];
    [self addSubview:self.contentImageView];
    
//    [self.placeHoderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.edges.equalTo(self);
//    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    self.contentImageContentMode     = UIViewContentModeScaleAspectFill;
//    self.placeholderImageContentMode = UIViewContentModeScaleAspectFill;
}

//#pragma mark - Setter & Getter.
//
//- (void)setPlaceholderImage:(UIImage *)placeholderImage {
//
//    _placeHoderImageView.image = placeholderImage;
//}
//
//- (UIImage *)placeholderImage {
//
//    return _placeHoderImageView.image;
//}
-(void)setShowImage:(UIImage *)showImage{
    _image = showImage;
    _contentImageView.image = showImage;
    
}
-(UIImage *)showImage{
    return _image;
}
- (void)setUrlString:(NSString *)urlString {
    
// 

}

- (NSString *)urlString {
    
    return _pUrlString;
}

//- (void)setPlaceholderImageContentMode:(UIViewContentMode)placeholderImageContentMode {
//
//    _placeHoderImageView.contentMode = placeholderImageContentMode;
//}
//
//- (UIViewContentMode)placeholderImageContentMode {
//
//    return _placeHoderImageView.contentMode;
//}

- (void)setContentImageContentMode:(UIViewContentMode)contentImageContentMode {
    
    _contentImageView.contentMode = contentImageContentMode;
}

- (UIViewContentMode)contentImageContentMode {
    
    return _contentImageView.contentMode;
}

@end
