//
//  RFPhotoScrollerView.h
//  RFPhotoBrower
//
//  Created by 冯剑 on 2017/11/23.
//  Copyright © 2017年 冯剑. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RFPhotoScrollerView : UIView
@property (nonatomic, assign) NSInteger currentIndex;
- (instancetype)initWithImagesArray:(NSArray *)imagesArray currentIndex:(NSInteger)currentIndex frame:(CGRect)frame;
@end
