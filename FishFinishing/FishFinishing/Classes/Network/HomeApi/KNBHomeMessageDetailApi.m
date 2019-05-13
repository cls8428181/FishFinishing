//
//  KNBHomeMessageDetailApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeMessageDetailApi.h"

@implementation KNBHomeMessageDetailApi {
    NSInteger _message_id;
}

- (instancetype)initWithMessageId:(NSInteger)messageId {
    if (self = [super init]) {
        _message_id = messageId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBHome_MassageDetail];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"massage_id" : @(_message_id)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
