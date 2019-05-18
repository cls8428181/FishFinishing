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

@dynamic code;

@dynamic name;

@end

@implementation KNBCityAttributes 
+ (NSString *)code {
	return @"code";
}
+ (NSString *)name {
	return @"name";
}
@end

