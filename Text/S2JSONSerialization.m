//
//  S2JSONSerialization.m
//  S2AppKit/S2TextKit
//
//  Created by 古川 文生 on 12/07/16.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2JSONSerialization.h"
#import "S2RuntimeType.h"
#import "S2Functions.h"



#define DATE_FORMAT	@"yyyy/MM/dd HH:mm:ss Z"



@implementation S2JSONSerialization {
	// 処理中のプロパティ
	S2RuntimeProperty* _processingProperty;
}

+ (NSString*)jsonStringWithObject:(id)object
{
	S2AssertParameter(object);

	return [[self jsonUTF8DataWithObject:object] utf8String];
}

+ (NSData*)jsonUTF8DataWithObject:(id)object
{
	S2AssertParameter(object);

	S2JSONSerialization* serialization = [S2JSONSerialization new];
	
	id archivedObject = [serialization encode:object];

	@try {
		NSError* error;
		NSData* data = [NSJSONSerialization dataWithJSONObject:archivedObject options:NSJSONWritingPrettyPrinted error:&error];

		if (error) {
			S2DebugLog(S2ClassTag, @"Error: %@", error);
			@throw [S2AppException new:S2ClassTag error:error];
		}

		return data;
	}
	@catch (NSException* ex) {
		@throw [S2AppException new:ex];
	}
}

+ (id)objectWithJsonString:(NSString*)jsonString
{
	S2AssertParameter(jsonString);

	return [self objectWithJsonUTF8Data:[jsonString utf8Data]];
}

+ (id)objectWithJsonUTF8Data:(NSData*)jsonUTF8Data
{
	S2AssertParameter(jsonUTF8Data);

	S2JSONSerialization* serialization = [S2JSONSerialization new];
	
	@try {
		NSError* error;
		id archivedObject = [NSJSONSerialization JSONObjectWithData:jsonUTF8Data options:	NSJSONReadingAllowFragments error:&error];

		if (error) {
			S2DebugLog(S2ClassTag, @"Error: %@", error);
			@throw [S2AppException new:S2ClassTag error:error];
		}

		return [serialization decode:archivedObject];
	}
	@catch (NSException* ex) {
		@throw [S2AppException new:ex];
	}
}

#pragma mark - encoding

- (id)encode:(id)object
{
	if (!object) {
		return [NSNull null];
	}
	else if ([object isKindOfClass:[NSString class]]) {
		return object;
	}
	else if ([object isKindOfClass:[NSNumber class]]) {
		return object;
	}
	else if ([object isKindOfClass:[NSDate class]]) {
		return [self encodeDate:object];
	}
	else if ([object isKindOfClass:[NSArray class]]) {
		return [self encodeArray:object];
	}
	else if ([object isKindOfClass:[NSSet class]]) {
		return [self encodeSet:object];
	}
	else if ([object isKindOfClass:[NSDictionary class]]) {
		return [self encodeDictionary:object];
	}
	else if ([object isKindOfClass:[NSIndexSet class]]) {
		return [self encodeIndexSet:object];
	}
	else /* NSObject */ {
		return [self encodeObject:object];
	}
}

- (NSDictionary*)encodeDate:(NSDate*)date
{
	NSDateFormatter* formatter = [NSDateFormatter new];
	
	formatter.dateFormat = DATE_FORMAT;
	
	return @{
		@".entityType": @"DateTime",
		@"dateTime": [formatter stringFromDate:date]
	};
}

- (NSDictionary*)encodeObject:(id)object
{
	NSMutableDictionary* encodedObject = [NSMutableDictionary new];

	[encodedObject setObject:NSStringFromClass([object class]) forKey:@".entityType"];

	// 独自のシリアライズ処理
	if (S2ObjectConformsToProtocol(object, S2DataSerialize)) {
		[(id<S2DataSerialize>)object serializeTo:encodedObject];
		return encodedObject;
	}

	S2RuntimeType* type = [S2RuntimeType typeOf:object];

	while (type && !S2StringEquals(type.name, @"NSObject")) {
		for (S2RuntimeProperty* property in type.properties) {
			NSString *propertyName = property.name;
			
			// weak参照は除外する
			if (property.weak) {
				continue;
			}
			// readonlyは除外する
			if (property.readonly) {
				continue;
			}
			
			_processingProperty = property;
			
			[encodedObject setObject:[self encode:[object valueForKey:propertyName]] forKey:propertyName];
		}

		type = [type supertype];
	}
	
	return encodedObject;
}

- (BOOL)propertyAttributes:(NSArray*)attributes has:(NSString*)attribute;
{
	for (NSString* attr in attributes) {
		if ([attr isEqualToString:attribute]) {
			return YES;
		}
	}
	
	return NO;
}

- (NSArray*)encodeArray:(NSArray*)array
{
	NSMutableArray* encodedObject = [NSMutableArray arrayWithCapacity:array.count];
	
	for (id object in array) {
		[encodedObject addObject:[self encode:object]];
	}
	
	return encodedObject;
}

- (NSArray*)encodeSet:(NSArray*)array
{
	return [self encodeArray:array];
}

- (NSDictionary*)encodeDictionary:(NSDictionary*)dictionary
{
	NSMutableDictionary* encodedObject = [NSMutableDictionary new];
	
	for (id key in dictionary) {
		id object = [dictionary objectForKey:key];
		[encodedObject setObject:[self encode:object] forKey:key];
	}
	
	return encodedObject;
}

- (NSDictionary*)encodeIndexSet:(NSIndexSet*)indexSet
{
	NSMutableArray* indexes = [NSMutableArray new];
	
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		[indexes addObject:@(idx)];
	}];
	
	return @{
		@".entityType": @"NSMutableIndexSet",
		@"indexes": indexes
	};
}

#pragma mark - decoding

- (id)decode:(id)object
{
	if ([object isKindOfClass:NSNull.class]) {
		return nil;
	}
	else if ([object isKindOfClass:NSString.class]) {
		return object;
	}
	else if ([object isKindOfClass:NSNumber.class]) {
		return object;
	}
	else if ([object isKindOfClass:NSArray.class]) {
		if (_processingProperty && [_processingProperty.type isSubclassOfClass:NSSet.class])
			return [self decodeSet:object];
		else
			return [self decodeArray:object];
	}
	else if ([object isKindOfClass:NSDictionary.class]) {
		NSDictionary* dictionary = object;
		NSString* entityType = [dictionary objectForKey:@".entityType"];
		
		// entityTypeが指定されていたら、Dictionary以外のオブジェクト
		if (entityType) {
			if ([entityType isEqualToString:@"DateTime"]) {
				return [self decodeDate:dictionary];
			}
			else if ([entityType isEqualToString:@"NSMutableIndexSet"]) {
				return [self decodeIndexSet:object];
			}
			else if ([entityType hasPrefix:@"__"]){
				@throw [S2AppException exceptionWithName:S2ClassTag
														  reason:S2StringFormat(@"entityType '%@' is not found", entityType)
														userInfo:nil];
			}
			else {
				Class class = NSClassFromString(entityType);
				
				// クラスの存在チェック
				if (!class) {
					@throw [S2AppException exceptionWithName:S2ClassTag
															  reason:S2StringFormat(@"entityType '%@' is not found", entityType)
															userInfo:nil];
				}

				return [self decodeObject:[class new] values:dictionary];
			}
		}
		else {
			return [self decodeDictionary:object];
		}
	}
	else {
		S2AssertFailed(@"decode %@ failed. (unknown JSON data)", NSStringFromClass([object class]));
		return nil;
	}
}

- (NSMutableArray*)decodeArray:(NSArray*)array
{
	NSMutableArray* decodedObject = [NSMutableArray arrayWithCapacity:array.count];
	
	for (id object in array) {
		[decodedObject addObject:[self decode:object]];
	}
	
	return decodedObject;
}

- (NSMutableSet*)decodeSet:(NSArray*)array
{
	NSMutableSet* decodedObject = [NSMutableSet setWithCapacity:array.count];
	
	for (id object in array) {
		[decodedObject addObject:[self decode:object]];
	}
	
	return decodedObject;
}

- (NSDate*)decodeDate:(NSDictionary*)values
{
	NSDateFormatter* formatter = [NSDateFormatter new];

	formatter.dateFormat = DATE_FORMAT;
	
	return [formatter dateFromString:[values objectForKey:@"dateTime"]];
}

- (id)decodeObject:(id)object values:(NSDictionary*)values
{
	// フック
	if (S2ObjectRespondsToSelector(object, @selector(hookDeserialize:))) {
		values = [object hookDeserialize:values];
	}

	// 独自のデシリアライズ処理
	if (S2ObjectConformsToProtocol(object, S2DataSerialize)) {
		[(id<S2DataSerialize>)object deserializeFrom:values];
		return object;
	}

	S2RuntimeType* type = [S2RuntimeType typeOf:object];

	while (type && !S2StringEquals(type.name, @"NSObject")) {
		for (S2RuntimeProperty* property in type.properties) {
			NSString *propertyName = property.name;
			
			// weak参照は除外する
			if (property.weak) {
				continue;
			}
			// readonlyは除外する
			if (property.readonly) {
				continue;
			}
			
			if ([[values allKeys] containsObject:propertyName]) {
				id value = [values objectForKey:propertyName];
				
				_processingProperty = property;
				[object setValue:[self decode:value] forKey:propertyName];
			}
		}
		
		type = [type supertype];
	}
	
	return object;
}

- (NSDictionary*)decodeDictionary:(NSDictionary*)dictionary
{
	NSMutableDictionary* decodedObject = [NSMutableDictionary new];

	for (id key in dictionary) {
		id object = [dictionary objectForKey:key];
		[decodedObject setObject:[self decode:object] forKey:key];
	}

	return decodedObject;
}

- (NSIndexSet*)decodeIndexSet:(NSDictionary*)dictionary
{
	NSMutableIndexSet* decodedObject = [NSMutableIndexSet new];

	NSArray* indexes = [dictionary objectForKey:@"indexes"];
	
	for (NSNumber* index in indexes) {
		[decodedObject addIndex:index.intValue];
	}
	
	return decodedObject;
}

@end



@implementation NSDateComponents (JSONSerialization)

- (void)serializeTo:(NSMutableDictionary*)dictionary;
{
	
}

- (void)deserializeFrom:(NSDictionary*)dictionary;
{
	
}

@end