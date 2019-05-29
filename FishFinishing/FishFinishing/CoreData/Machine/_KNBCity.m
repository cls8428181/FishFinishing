// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KNBCity.m instead.

#import "_KNBCity.h"

@implementation KNBCityID
@end

@implementation _KNBCity

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"KNBCity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"KNBCity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"KNBCity" inManagedObjectContext:moc_];
}

- (KNBCityID*)objectID {
	return (KNBCityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic areaList;

@dynamic cityList;

@dynamic code;

@dynamic isHot;

@dynamic isOpen;

@dynamic letter;

@dynamic level;

@dynamic name;

@dynamic pid;

@dynamic pinyin;

@dynamic region;

@dynamic sort;

@dynamic status;

@dynamic temp;

@end

@implementation KNBCityAttributes 
+ (NSString *)areaList {
	return @"areaList";
}
+ (NSString *)cityList {
	return @"cityList";
}
+ (NSString *)code {
	return @"code";
}
+ (NSString *)isHot {
	return @"isHot";
}
+ (NSString *)isOpen {
	return @"isOpen";
}
+ (NSString *)letter {
	return @"letter";
}
+ (NSString *)level {
	return @"level";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)pid {
	return @"pid";
}
+ (NSString *)pinyin {
	return @"pinyin";
}
+ (NSString *)region {
	return @"region";
}
+ (NSString *)sort {
	return @"sort";
}
+ (NSString *)status {
	return @"status";
}
+ (NSString *)temp {
	return @"temp";
}
@end

