//
//  S2Objc.m
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2012/11/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"
#import "S2Functions.h"



@implementation NSObject (S2AppKit)

- (NSString*)className;
{
	return NSStringFromClass(self.class);
}

- (NSString*)toString;
{
	return self.description;
}

- (void)logRetainCount;
{
	__S2DebugLog(S2ClassTag, @"retainCount=%ld", CFGetRetainCount((__bridge CFTypeRef)self));
}

@end



@implementation NSData (S2AppKit)

+ (NSData*)utf8Bom;
{
	unsigned char bom[] = {0xEF, 0xBB, 0xBF};
	return [NSData dataWithBytes:bom length:sizeof(bom)];
}

+ (NSData*)utf16LEBom;
{
	unsigned char bom[] = {0xFF, 0xFE};
	return [NSData dataWithBytes:bom length:sizeof(bom)];
}

+ (NSData*)utf16BEBom;
{
	unsigned char bom[] = {0xFE, 0xFF};
	return [NSData dataWithBytes:bom length:sizeof(bom)];
}

- (NSString *)utf8String;
{
	return S2Utf8DataToString(self);
}

@end



@implementation NSString (S2AppKit)

+ (NSString*)stringWithCharacter:(unichar)character repeatCount:(int)repeatCount;
{
	if (repeatCount <= 0)
		return @"";

	unichar* separator = alloca(sizeof(unichar) * (repeatCount + 1));
	{
		unichar* ptr = separator;
		for (int index = 0; index < repeatCount; ++index) {
			*ptr++ = character;
		}
		*ptr++ = 0;
	}

	return [NSString stringWithCharacters:separator length:repeatCount];
}

- (NSData *)utf8Data;
{
	return S2StringToUtf8Data(self);
}

- (NSData*)base64Data;
{
	return [NSData dataWithBase64String:self];
}

- (NSRange)wholeRange;
{
	return NSMakeRange(0, self.length);
}

- (NSComparisonResult)compareTo:(id)object;
{
	if (!S2ObjectIsKindOf(object, self))
		return NSOrderedDescending;
	
	return [self compare:object];
}

@end



@implementation NSNumber (S2AppKit)

- (NSComparisonResult)compareTo:(id)target;
{
	if (!S2ObjectIsKindOf(target, self))
		return NSOrderedDescending;
	
	return [self compare:target];
}

@end



@implementation NSDate (S2AppKit)

- (NSComparisonResult)compareTo:(id)target;
{
	if (!S2ObjectIsKindOf(target, self))
		return NSOrderedDescending;
	
	return [self compare:target];
}

@end



@implementation NSArray (S2AppKit)

- (id)firstObject;
{
	return self.count > 0 ? self[0] : nil;
}

- (NSUInteger)indexOfKeyPath:(NSString*)keyPath value:(id)targetValue;
{
	return [self indexOfObjectPassingTest:^(NSObject* object, NSUInteger index, BOOL* stop) {
		return S2ObjectEquals([object valueForKeyPath:keyPath], targetValue);
	}];
}

- (NSUInteger)indexOfKey:(NSString*)key object:(id)targetObject;
{
	return [self indexOfObjectPassingTest:^(NSObject* object, NSUInteger index, BOOL* stop) {
		return S2ObjectEquals([object valueForKey:key], [targetObject valueForKey:key]);
	}];
}

- (NSUInteger)indexOfKey:(NSString*)key value:(id)targetValue;
{
	return [self indexOfObjectPassingTest:^(NSObject* object, NSUInteger index, BOOL* stop) {
		return S2ObjectEquals([object valueForKey:key], targetValue);
	}];
}

- (NSArray *)sortedArray;
{
	return [self sortedArrayUsingSelector:@selector(compareTo:)];
}

- (NSArray *)sortedArrayUsingKey:(NSString*)key ascending:(BOOL)ascending;
{
	return [self sortedArrayUsingDescriptors:@[
		[[NSSortDescriptor alloc] initWithKey:key ascending:ascending]
	]];
}

@end



@implementation NSMutableArray (S2AppKit)

- (NSMutableArray*)shallowCopyWithZone:(NSZone*)zone;
{
	return [[NSMutableArray allocWithZone:zone] initWithArray:self copyItems:NO];
}

- (NSMutableArray*)deepCopyWithZone:(NSZone*)zone;
{
	return [[NSMutableArray allocWithZone:zone] initWithArray:self copyItems:YES];
}

- (void)sort;
{
	[self sortUsingSelector:@selector(compareTo:)];
}

- (void)sortUsingKey:(NSString*)key ascending:(BOOL)ascending;
{
	[self sortUsingDescriptors:@[
		[[NSSortDescriptor alloc] initWithKey:key ascending:ascending]
	]];
}

@end



@implementation NSMutableSet (S2AppKit)

- (NSMutableSet*)shallowCopyWithZone:(NSZone*)zone;
{
	return [[NSMutableSet allocWithZone:zone] initWithSet:self copyItems:NO];
}

- (NSMutableSet*)deepCopyWithZone:(NSZone*)zone;
{
	return [[NSMutableSet allocWithZone:zone] initWithSet:self copyItems:YES];
}

@end



@implementation NSDictionary (S2AppKit)

- (NSArray *)keysSortedByValue;
{
	return [self keysSortedByValueUsingSelector:@selector(compareTo:)];
}

@end



@implementation NSMutableDictionary (S2AppKit)

- (NSMutableDictionary*)shallowCopyWithZone:(NSZone*)zone;
{
	return [[NSMutableDictionary allocWithZone:zone] initWithDictionary:self copyItems:NO];
}

- (NSMutableDictionary*)deepCopyWithZone:(NSZone*)zone;
{
	return [[NSMutableDictionary allocWithZone:zone] initWithDictionary:self copyItems:YES];
}

@end



@implementation NSFileHandle (S2AppKit)

- (void)writeUtf8Data:(NSString *)string;
{
	[self writeData:string.utf8Data];
}

@end



@implementation S2AppException

+ (S2AppException *)new:(NSString *)name reason:(NSString *)reason;
{
	return [[self alloc] initWithName:name reason:reason userInfo:nil];
}

+ (S2AppException *)new:(NSString *)name format:(NSString *)format, ...;
{
	NSString* reason;

	if (!format) {
		reason = @"";
	}
	else {
		va_list args;
		va_start(args, format);
		reason = [[NSString alloc] initWithFormat:format arguments:args];
		va_end(args);
	}
	
	return [[self alloc] initWithName:name reason:reason userInfo:nil];
}

+ (S2AppException *)new:(NSString *)name error:(NSError *)error;
{
	return [[self alloc] initWithName:name reason:error.description userInfo:error.userInfo];
}

+ (S2AppException *)new:(NSException*)exception;
{
	return [[self alloc] initWithName:exception.name reason:exception.reason userInfo:exception.userInfo];
}

+ (S2AppException *)exceptionWithName:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo;
{
	return [[self alloc] initWithName:name reason:reason userInfo:userInfo];
}

@end



@implementation NSBundle (S2AppKit)

- (NSString *)bundleName;
{
	return self.infoDictionary[@"CFBundleName"];
}

@end
