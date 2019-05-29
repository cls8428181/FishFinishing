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

@class NSObject;

@class NSObject;

@interface KNBCityID : NSManagedObjectID {}
@end

@interface _KNBCity : NSManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (nullable NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KNBCityID *objectID;

@property (nonatomic, strong, nullable) id areaList;

@property (nonatomic, strong, nullable) id cityList;

@property (nonatomic, strong, nullable) NSString* code;

@property (nonatomic, strong, nullable) NSString* isHot;

@property (nonatomic, strong, nullable) NSString* isOpen;

@property (nonatomic, strong, nullable) NSString* letter;

@property (nonatomic, strong, nullable) NSString* level;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSString* pid;

@property (nonatomic, strong, nullable) NSString* pinyin;

@property (nonatomic, strong, nullable) NSString* region;

@property (nonatomic, strong, nullable) NSString* sort;

@property (nonatomic, strong, nullable) NSString* status;

@property (nonatomic, strong, nullable) NSString* temp;

@end

@interface _KNBCity (CoreDataGeneratedPrimitiveAccessors)

- (nullable id)primitiveAreaList;
- (void)setPrimitiveAreaList:(nullable id)value;

- (nullable id)primitiveCityList;
- (void)setPrimitiveCityList:(nullable id)value;

- (nullable NSString*)primitiveCode;
- (void)setPrimitiveCode:(nullable NSString*)value;

- (nullable NSString*)primitiveIsHot;
- (void)setPrimitiveIsHot:(nullable NSString*)value;

- (nullable NSString*)primitiveIsOpen;
- (void)setPrimitiveIsOpen:(nullable NSString*)value;

- (nullable NSString*)primitiveLetter;
- (void)setPrimitiveLetter:(nullable NSString*)value;

- (nullable NSString*)primitiveLevel;
- (void)setPrimitiveLevel:(nullable NSString*)value;

- (nullable NSString*)primitiveName;
- (void)setPrimitiveName:(nullable NSString*)value;

- (nullable NSString*)primitivePid;
- (void)setPrimitivePid:(nullable NSString*)value;

- (nullable NSString*)primitivePinyin;
- (void)setPrimitivePinyin:(nullable NSString*)value;

- (nullable NSString*)primitiveRegion;
- (void)setPrimitiveRegion:(nullable NSString*)value;

- (nullable NSString*)primitiveSort;
- (void)setPrimitiveSort:(nullable NSString*)value;

- (nullable NSString*)primitiveStatus;
- (void)setPrimitiveStatus:(nullable NSString*)value;

- (nullable NSString*)primitiveTemp;
- (void)setPrimitiveTemp:(nullable NSString*)value;

@end

@interface KNBCityAttributes: NSObject 
+ (NSString *)areaList;
+ (NSString *)cityList;
+ (NSString *)code;
+ (NSString *)isHot;
+ (NSString *)isOpen;
+ (NSString *)letter;
+ (NSString *)level;
+ (NSString *)name;
+ (NSString *)pid;
+ (NSString *)pinyin;
+ (NSString *)region;
+ (NSString *)sort;
+ (NSString *)status;
+ (NSString *)temp;
@end

NS_ASSUME_NONNULL_END
