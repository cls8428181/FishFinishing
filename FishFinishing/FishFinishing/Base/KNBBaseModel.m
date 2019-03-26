//
//  KNBBaseModel.m
//  KenuoTraining
//
//  Created by 吴申超 on 16/2/25.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBBaseModel.h"
#import <SDWebImageManager.h>
#import "NSDate+BTAddition.h"
#import "NSString+Contain.h"
#import "UIImageView+WebCache.h"


@implementation KNBBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:self.class];
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:self.class];
}

///// 子类复写此方法关联coredata名称
+ (NSString *)managedObjectEntityName {
    NSString *className = NSStringFromClass([self class]);
    NSString *entityName = nil;

    if ([className contains:@"Model"]) {
        entityName = [className stringByReplacingOccurrencesOfString:@"Model" withString:@""];
        return entityName;
    }
    return @"";
}

#pragma mark - search

+ (NSArray *)searchAll {
    Class cls = NSClassFromString([self managedObjectEntityName]);
    NSArray *result = [cls MR_findAll];
    return [self classToModel:result];
}

+ (NSArray *)searchWithKey:(id)key {
    NSArray *result = [self searchKey:key ascending:NO];
    return [self classToModel:result];
}

+ (NSArray *)searchWithKey:(id)key value:(id)value {
    NSArray *result = [self searchKey:key value:value];
    return [self classToModel:result];
}

+ (NSArray *)searchWithPredicate:(NSPredicate *)dicate {
    Class cls = NSClassFromString([self managedObjectEntityName]);
    NSArray *data = [cls MR_findAllWithPredicate:dicate];
    return [self classToModel:data];
}

+ (NSArray *)searchWithPredicate:(NSPredicate *)dicate
                 sortDescription:(NSSortDescriptor *)sortDes
                            page:(NSInteger)page {
    Class cls = NSClassFromString([self managedObjectEntityName]);
    NSFetchRequest *request = [cls MR_requestAllWithPredicate:dicate];
    //设置排序数组
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDes, nil];
    [request setSortDescriptors:sortDescriptors];
    //设置分页查询数目
    [request setFetchLimit:20];
    //设置查询起始
    [request setFetchOffset:(page - 1) * 20];
    NSArray *data = [cls MR_executeFetchRequest:request];
    return [self classToModel:data];
}
+ (NSArray *)searchWithPredicate:(NSPredicate *)dicate andSorting:(NSString *)sorting andAscending:(BOOL)ascending {
    Class cls = NSClassFromString([self managedObjectEntityName]);
    NSArray *data = [cls MR_findAllSortedBy:sorting ascending:ascending withPredicate:dicate];
    return [self classToModel:data];
}
+ (NSArray *)searchWithSorting:(NSString *)sorting andAscending:(BOOL)ascending {
    Class cls = NSClassFromString([self managedObjectEntityName]);
    NSArray *data = [cls MR_findAllSortedBy:sorting ascending:ascending];
    return [self classToModel:data];
}
#pragma mark - BaseSearch

+ (NSArray *)search {
    Class cls = NSClassFromString([self managedObjectEntityName]);
    return [cls MR_findAll];
}

+ (NSArray *)searchKey:(id)key {
    return [self searchKey:key ascending:NO];
}

+ (NSArray *)searchKey:(id)key ascending:(BOOL)ascending {
    Class cls = NSClassFromString([self managedObjectEntityName]);
    return [cls MR_findAllSortedBy:key ascending:ascending];
}

+ (NSArray *)searchKey:(id)key value:(id)value {
    Class cls = NSClassFromString([self managedObjectEntityName]);
    return [cls MR_findByAttribute:key withValue:value];
}

+ (NSArray *)classToModel:(NSArray *)res {
    if (res.count == 0) {
        return nil;
    }
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSManagedObject *object in res) {
        id result = [MTLManagedObjectAdapter modelOfClass:[self class] fromManagedObject:object error:nil];
        [modelArray addObject:result];
    }
    return modelArray;
}

#pragma mark - delete

+ (BOOL)deleteKey:(id)key value:(id)value {
    NSArray *result = [self searchKey:key value:value];
    if (result.count > 0) {
        return [self deleteWithModel:result[0]];
    }
    return NO;
}

+ (BOOL)deletePrimaryKeyValue:(id)value {
    NSSet *primary = [self propertyKeysForManagedObjectUniquing];
    if (primary.count == 0) {
        return NO;
    }
    for (id key in primary) {
        BOOL result = [self deleteKey:key value:value];
        return result;
    }
    return NO;
}

+ (BOOL)deleteModel {
    NSArray *result = [self search];
    for (id model in result) {
        [self deleteWithModel:model];
    }
    return YES;
}

+ (BOOL)deleteWithModel:(id)model {
    BOOL success = [model MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return success;
}
+ (BOOL)deleteWithPredicate:(NSPredicate *)predicate {
    Class cls = NSClassFromString([self managedObjectEntityName]);
    BOOL success = [cls MR_deleteAllMatchingPredicate:predicate];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return success;
}
#pragma mark -Save

+ (void)saveWithModel:(id)model resultBlock:(void (^)(BOOL success))block {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *_Nonnull localContext) {
        NSError *error;
        [MTLManagedObjectAdapter managedObjectFromModel:model insertingIntoContext:localContext error:&error];
    } completion:^(BOOL contextDidSave, NSError *_Nullable error) {
        if (error) {
            NSLog(@"MagicalRecord saveError======%@", error);
        }else{
            NSLog(@"===插入数据库成功===");
        }
        if (block) {
            block(contextDidSave);
        }
    }];
}

#pragma mark - change to model

+ (id)changeResponseJSONObject:(nullable id)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        NSLog(@"obj is nill");
        return nil;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        if (isNullStr(obj)) {
            return nil;
        }
    }
    if ([obj isKindOfClass:[NSArray class]]) {
        return [self changeJSONArray:obj];
    }
    NSError *error = nil;
    id model = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:obj error:&error];
    if (error) {
        NSLog(@"changeResponseEroor:%@", error);
    }
    return model;
}

+ (NSArray *)changeJSONArray:(NSArray *)ary {
    if ([ary isKindOfClass:[NSNull class]]) {
        NSLog(@"array is nill");
        return nil;
    }
    NSError *error = nil;
    NSArray *models = [MTLJSONAdapter modelsOfClass:self.class fromJSONArray:ary error:&error];
    if (error) {
        NSLog(@"changeJSONArray:%@", error);
    }
    return models;
}

+ (NSArray *)jsonFromModelArray:(NSArray *)ary {
    if ([ary isKindOfClass:[NSNull class]]) {
        NSLog(@"array is nill");
        return nil;
    }
    NSError *error = nil;
    NSArray *jsonArray = [MTLJSONAdapter JSONArrayFromModels:ary error:&error];
    if (error) {
        NSLog(@"changeJSONArray:%@", error);
    }
    return jsonArray;
}

+ (void)setImageView:(UIImageView *)imageView urlString:(NSString *)url placeholderImage:(NSString *)placeholder {
    UIImage *placeholderImage = nil;
    if (![placeholder isEqual:[NSNull class]]) {
        placeholderImage = [UIImage imageNamed:placeholder];
    }
    NSURL *imageUrl = [NSURL URLWithString:url];
    [imageView sd_setImageWithURL:imageUrl
                 placeholderImage:placeholderImage
                          options:SDWebImageRetryFailed | SDWebImageRefreshCached
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                            
                        }];
}

+ (void)headImageView:(UIImageView *)imgView urlString:(NSString *)str {
    UIImage *defaultImg = [UIImage imageNamed:@"icon_head_placeholder"];
    if (isNullStr(str)) {
        imgView.image = defaultImg;
    } else {
        NSURL *imageUrl = [NSURL URLWithString:str];
        [imgView sd_setImageWithURL:imageUrl placeholderImage:defaultImg];
    }
}

- (NSString *)transToFuzzyDate:(NSString *)str {
    //对于后台返回不规范数据的处理 
    if ([str containsString:@"."]) {
        NSRange range = [str rangeOfString:@"."];
        if (range.location != NSNotFound) {
            str = [str substringToIndex:range.location];
        }
    }
    NSDate *date = [NSDate getDate:str];
    return [date transformToFuzzyDate];
}


- (NSString *)transToFuzzyDateSimply:(NSString *)str{
    //对于后台返回不规范数据的处理
    if ([str containsString:@"."]) {
        NSRange range = [str rangeOfString:@"."];
        if (range.location != NSNotFound) {
            str = [str substringToIndex:range.location];
        }
    }
    NSDate *date = [NSDate getDate:str];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}


- (NSString *)transToFuzzyDateYYMMDD:(NSString *)str{
    //对于后台返回不规范数据的处理
    if ([str containsString:@"."]) {
        NSRange range = [str rangeOfString:@"."];
        if (range.location != NSNotFound) {
            str = [str substringToIndex:range.location];
        }
    }
    NSDate *date = [NSDate getDate:str];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}


+ (NSString *)transNumber:(double)number {
    NSString *doublePriceStr = [NSString stringWithFormat:@"%.2f", number];
    NSDecimalNumber *priceNum = [NSDecimalNumber decimalNumberWithString:doublePriceStr];
    NSString *priceStr = [priceNum stringValue];
    return priceStr;
}

@end
