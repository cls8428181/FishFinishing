//
//  KNBDesignSketchCollectionSectionView.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/28.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KNBOptionViewButtonType) {
    KNBOptionViewButtonType_Style = 1212, //风格
    KNBOptionViewButtonType_Type,         //类型
    KNBOptionViewButtonType_Area          //面积
};

NS_ASSUME_NONNULL_BEGIN

@interface KNBDesignSketchCollectionSectionView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *styleButton;

@property (nonatomic, copy) void (^optionCompleteBlock)(KNBDesignSketchCollectionSectionView *optionView, KNBOptionViewButtonType type);

@end

NS_ASSUME_NONNULL_END
