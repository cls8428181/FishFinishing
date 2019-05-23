//
//  KNBHomeServiceModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeServiceModel : KNBBaseModel

/**
 类型 id
 */
@property (nonatomic, copy) NSString *cat_id;

/**
 服务商 id
 */
@property (nonatomic, copy) NSString *fac_id;

/**
 案例中的服务商 id
 */
@property (nonatomic, copy) NSString *facilitator_id;

/**
 距离
 */
@property (nonatomic, copy) NSString *distance;

/**
 id
 */
@property (nonatomic, copy) NSString *serviceId;

/**
 名称
 */
@property (nonatomic, copy) NSString *name;

/**
 头像
 */
@property (nonatomic, copy) NSString *logo;

/**
 省
 */
@property (nonatomic, copy) NSString *province_name;

/**
 市
 */
@property (nonatomic, copy) NSString *city_name;


/**
 区
 */
@property (nonatomic, copy) NSString *area_name;

/**
 地址
 */
@property (nonatomic, copy) NSString *address;

/**
 电话
 */
@property (nonatomic, copy) NSString *telephone;

/**
 标签
 */
@property (nonatomic, copy) NSString *tag;

/**
 服务
 */
@property (nonatomic, strong) NSArray *serviceList;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 分享名
 */
@property (nonatomic, copy) NSString *share_name;

/**
 备注
 */
@property (nonatomic, copy) NSString *remark;

/**
 创建时间
 */
@property (nonatomic, copy) NSString *created_at;

/**
 服务商类型
 */
@property (nonatomic, copy) NSString *share_id;

@property (nonatomic, copy) NSString *cat_name;

/**
 服务商类型名称
 */
@property (nonatomic, copy) NSString *parent_cat_name;

/**
 服务商类型id
 */
@property (nonatomic, copy) NSString *parent_cat_id;

/**
 是否置顶   0 未置顶 1 置顶
 */
@property (nonatomic, copy) NSString *is_stick;

/**
 是否是体验版   0 不是体验版 1 体验版
 */
@property (nonatomic, copy) NSString *is_experience;

/**
 到期时间
 */
@property (nonatomic, copy) NSString *due_time;

/**
 检查
 */
@property (nonatomic, copy) NSString *check_in;

/**
 路径
 */
@property (nonatomic, copy) NSString *path;

/**
 服务类型
 */
@property (nonatomic, copy) NSString *subscribe_type;

/**
 服务名称
 */
@property (nonatomic, copy) NSString *service_name;

/**
 服务图标
 */
@property (nonatomic, copy) NSString *icon;

/**
 案例图片
 */
@property (nonatomic, copy) NSString *img;

/**
 案例推荐 1 推荐 0 未推荐
 */
@property (nonatomic, copy) NSString *is_recommend;

/**
 户型
 */
@property (nonatomic, copy) NSString *apart_name;

/**
 风格
 */
@property (nonatomic, copy) NSString *style_name;

/**
 面积
 */
@property (nonatomic, copy) NSString *acreage;

/**
 价格
 */
@property (nonatomic, copy) NSString *price;

/**
 案例数据
 */
@property (nonatomic, strong) NSArray<KNBHomeServiceModel *> *caseList;

/**
 是否展开简介
 */
@property (nonatomic, assign) BOOL isOpen;

/**
 是否显示图标
 */
@property (nonatomic, assign) BOOL isShow;

/**
 服务商详情简介 cell 高度
 */
@property (nonatomic, assign) CGFloat remarkHeight;

/**
 案例列表高度
 */
@property (nonatomic, assign) CGFloat caseListHeight;

/**
 是否为编辑状态
 */
@property (nonatomic, assign) BOOL isEdit;

/**
 最大地址宽度
 */
@property (nonatomic, assign) CGFloat maxAddressWidth;

/**
 转换后的距离字符串
 */
@property (nonatomic, copy) NSString *distanceString;

/**
 限制长度后的名字
 */
@property (nonatomic, copy) NSString *nameString;

@end

NS_ASSUME_NONNULL_END
