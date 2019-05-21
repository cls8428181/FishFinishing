//
//  KNCityListViewController.h
//  Concubine
//
//  Created by 刘随义 on 16/6/12.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import "KNBBaseViewController.h"
#import "KNBHomeCityHeaderView.h"

typedef void (^KNBHomeCityListViewBlock)(NSString *cityName, NSString *areaId);


@interface KNBHomeCityListViewController : KNBBaseViewController

@property (nonatomic, copy) KNBHomeCityListViewBlock cityBlock;

@end
