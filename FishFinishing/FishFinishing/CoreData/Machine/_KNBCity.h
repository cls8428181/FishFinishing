// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KNBCity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface KNBCityID : NSManagedObjectID {}
@end

@interface _KNBCity : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KNBCityID *objectID;

@property (nonatomic, strong, nullable) NSString* code;

@property (nonatomic, strong, nullable) NSString* name;

@end

@interface _KNBCity (CoreDataGeneratedPrimitiveAccessors)

- (nullable NSString*)primitiveCode;
- (void)setPrimitiveCode:(nullable NSString*)value;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

@end

@interface KNBCityAttributes: NSObject 
+ (NSString *)code;
+ (NSString *)name;
@end

NS_ASSUME_NONNULL_END
