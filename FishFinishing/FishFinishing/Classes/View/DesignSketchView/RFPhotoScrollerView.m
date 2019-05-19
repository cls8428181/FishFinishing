//
//  RFPhotoScrollerView.m
//  RFPhotoBrower
//
//  Created by 冯剑 on 2017/11/23.
//  Copyright © 2017年 冯剑. All rights reserved.
//

#import "RFPhotoScrollerView.h"
#import "UIImage+Size.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface RFPhotoScrollerView()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIScrollView *itemScrollView;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIImageView *pageBgView;
@property (nonatomic, strong) NSMutableArray *sizeArray;
@end


@implementation RFPhotoScrollerView
{
    NSArray *_imagesArray;
    CGFloat _offset;
}
- (instancetype)initWithImagesArray:(NSArray *)imagesArray currentIndex:(NSInteger)currentIndex frame:(CGRect)frame {
    _imagesArray = [imagesArray copy];
    _currentIndex = currentIndex;
    _offset = 0.0;
    self = [super initWithFrame:frame];
    if (self) {
        // 设置scrollView
        [self setupScrollView];
        // 添加点击手势
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//        [self addGestureRecognizer:tap];

        // 页码显示
        UILabel *pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KNB_StatusBar_H + 5, kScreenWidth, 20)];
        self.pageLabel = pageLabel;
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.textColor = [UIColor whiteColor];
        pageLabel.font = [UIFont systemFontOfSize:18];
        pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex+1,_imagesArray.count];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = KNBImages(@"knb_design_numbg");
        imageView.frame = CGRectMake(frame.size.width/2 - 30, CGRectGetMinY(pageLabel.frame), 60, 20);
        self.pageBgView = imageView;
        [self addSubview:imageView];
        [self addSubview:pageLabel];
        [self bringSubviewToFront:pageLabel];
    }
    return self;
}
- (void)setupScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled =  YES;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(_imagesArray.count * kScreenWidth, self.frame.size.height);
    scrollView.contentOffset = CGPointMake(_currentIndex * kScreenWidth, 0);
    [self addSubview:scrollView];
    
    KNB_WS(weakSelf);
    // 添加图片
    [_imagesArray enumerateObjectsUsingBlock:^(NSString *imageNamed, NSUInteger idx, BOOL * _Nonnull stop) {
        UIScrollView *itemScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(idx * kScreenWidth, 0, kScreenWidth, self.frame.size.height)];
        self.itemScrollView = itemScrollView;
        itemScrollView.delegate = self;
        itemScrollView.maximumZoomScale = 3.0;//最大缩放倍数
        itemScrollView.minimumZoomScale = 1.0;//最小缩放倍数
        itemScrollView.showsVerticalScrollIndicator = NO;
        itemScrollView.showsHorizontalScrollIndicator = NO;
        itemScrollView.backgroundColor =[UIColor blackColor];
        [itemScrollView setZoomScale:1];
        [self.scrollView addSubview:itemScrollView];

        // 添加图片并适配

        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageNamed] placeholderImage:CCPortraitPlaceHolder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            //图片的宽
            CGFloat width = image.size.width;
            //图片的高
            CGFloat height = image.size.height;
            NSDictionary *tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(width),@"width",@(height),@"height", nil];
            [weakSelf.sizeArray addObject:tempDic];
            CGSize imageReSize = CGSizeMake(KNB_SCREEN_WIDTH, KNB_SCREEN_WIDTH * height/width);
            imageView.frame = CGRectMake((kScreenWidth - imageReSize.width) / 2, (kScreenHeight - imageReSize.height - KNB_TAB_HEIGHT) / 2, imageReSize.width, imageReSize.height);
            [itemScrollView addSubview:imageView];
        }];
        imageView.userInteractionEnabled = YES;
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
    }];

}

// 调整图片
-(CGSize)resizeImageSize:(CGSize)size{
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat maxHeight = kScreenHeight;
    CGFloat maxWidth = kScreenWidth;
    //如果图片尺寸大于view尺寸，按比例缩放
    if(width > maxWidth || height > width){
        CGFloat ratio = height / width;
        CGFloat maxRatio = maxHeight / maxWidth;
        if(ratio < maxRatio){
            width = maxWidth;
            height = width*ratio;
        }else{
            height = maxHeight;
            width = height / ratio;
        }
    }
    return CGSizeMake(width, height);
}

#pragma mark UIScrollViewDelegate
//指定缩放view
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

// 正在放大缩小
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    // 增量为=位移距离/2
    UIView *v = [scrollView.subviews objectAtIndex:0];
    if ([v isKindOfClass:[UIImageView class]]){
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
        (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
        (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        v.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                  scrollView.contentSize.height * 0.5 + offsetY);
    }
   

}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{

}

// 滚动完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{

    if (scrollView == self.scrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x !=_offset){
            _offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    NSInteger page = scrollView.contentOffset.x / kScreenWidth;
                    _currentIndex = page;
                    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",page+1,_imagesArray.count];
                }
            }
        }
    }
}

- (void)settingPageLabelLayoutWithImageSize:(CGSize)size {
    KNB_WS(weakSelf);
    if (size.height > size.width) {
        [self.pageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.mas_equalTo(35);
        }];
        [self.pageBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.mas_equalTo(35);
        }];
    } else {
        [self.pageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.mas_equalTo(KNB_NAV_HEIGHT);
        }];
        [self.pageBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            make.top.mas_equalTo(KNB_NAV_HEIGHT);
        }];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}

- (NSMutableArray *)sizeArray {
    if (!_sizeArray) {
        _sizeArray = [NSMutableArray array];
    }
    return _sizeArray;
}



























@end
