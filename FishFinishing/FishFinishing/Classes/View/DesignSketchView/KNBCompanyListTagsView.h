//
//  KNBCompanyListTagsView.h
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "BRBaseView.h"

typedef void(^BRStringResultBlock)(id _Nullable selectValue);
typedef void(^BRStringCancelBlock)(void);
typedef void(^DidBeyondMaximumNumberBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface KNBCompanyListTagsView : BRBaseView
@property (nonatomic, copy) DidBeyondMaximumNumberBlock maxNumberBlock;
/**
 *  显示联动自定义字符串选择器（支持 设置自动选择、自定义主题颜色、取消选择的回调）
 *
 *  @param dataSource       数据源（字符串数组）
 *  @param resultBlock      选择后的回调
 *  @param cancelBlock      取消选择的回调
 *
 */
+ (void)showTagsPickerWithDataSource:(NSArray *)dataSource
                        superView:(UIView *)superView
                    resultBlock:(BRStringResultBlock)resultBlock
                         cancelBlock:(BRStringCancelBlock)cancelBlock;
@end

NS_ASSUME_NONNULL_END
