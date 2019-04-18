//
//  KNBHomeChatModel.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/19.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeChatModel : KNBBaseModel
@property (nonatomic, copy) NSString *caseId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *browse_num;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *subTitle;
@end

NS_ASSUME_NONNULL_END
