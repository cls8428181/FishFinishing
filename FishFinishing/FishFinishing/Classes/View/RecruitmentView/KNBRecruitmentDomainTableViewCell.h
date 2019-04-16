//
//  KNBRecruitmentDomainTableViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/15.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KNBRecruitmentDomainType) {
    KNBRecruitmentDomainTypeDefault = 0,       //擅长领域
    KNBRecruitmentDomainTypeService,            //服务选择
};

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentDomainTableViewCell : UITableViewCell
@property (nonatomic, assign) KNBRecruitmentDomainType type;

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 cell 高度
 */
+ (CGFloat)cellHeight;

- (void)setTagsViewDataSource:(NSArray *)dataArray;
@end

NS_ASSUME_NONNULL_END
