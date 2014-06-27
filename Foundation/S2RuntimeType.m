//
//  S2RuntimeType.m
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2012/08/16.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2RuntimeType.h"
#import <objc/runtime.h>



@interface S2RuntimeProperty ()

+ (id)new:(objc_property_t)property;

@end

@interface S2RuntimeMethod ()

+ (id)new:(Method)method;

@end



@implementation S2RuntimeType {
	Class _targetClass;
	
	objc_property_t* _objc_properties;
	unsigned int _objc_property_count;

	NSMutableArray* _properties;
}

static NSMutableDictionary* sTypeDictionary;

+ (void)initialize
{
	sTypeDictionary = [NSMutableDictionary new];
}

- (void)dealloc
{
	if (_objc_properties) {
		free(_objc_properties);
	}
}

+ (id)typeOf:(id)object;
{
	Class class = [object class];
	
	return [self typeFrom:class];
}

+ (id)typeFrom:(Class)class;
{
	S2RuntimeType* type = [sTypeDictionary objectForKey:NSStringFromClass(class)];
	if (type)
		return type;
	
	unsigned int propertyCount;
	objc_property_t* properties = class_copyPropertyList(class, &propertyCount);
	
	type = [self new];
	type->_targetClass = class;
	type->_objc_properties = properties;
	type->_objc_property_count = propertyCount;
	type->_properties = [NSMutableArray arrayWithCapacity:propertyCount];

	for (int i = 0; i < propertyCount; i++) {
		objc_property_t property = properties[i];
		
		[type->_properties addObject:[S2RuntimeProperty new:property]];
	}
	
	[sTypeDictionary setObject:type forKey:NSStringFromClass(class)];

	return type;
}

- (NSString *)name;
{
	return NSStringFromClass(_targetClass);
}

- (Class)targetClass;
{
	return _targetClass;
}

- (S2RuntimeType*)supertype;
{
	Class superclass = [_targetClass superclass];

	return superclass ? [S2RuntimeType typeFrom:superclass] : nil;
}

- (NSArray *)methods;
{
	NSMutableArray* methods = [NSMutableArray new];
	
	unsigned int methodCount;
	Method* methodList = class_copyMethodList(_targetClass, &methodCount);
	
	for (int i = 0; i < methodCount; i++) {
		Method method = methodList[i];
		
		[methods addObject:[S2RuntimeMethod new:method]];
	}
	
	return methods;
}

@end



@implementation S2RuntimeProperty {
	objc_property_t _property;
}

+ (id)new:(objc_property_t)property;
{
	S2RuntimeProperty* object = [super new];

	object->_property = property;

	return object;
}

- (Class)type;
{
	NSArray* attributes = [@(property_getAttributes(_property)) componentsSeparatedByString:@","];

	NSString* typeAttribute = [attributes objectAtIndex:0];
	
	if ([typeAttribute hasPrefix:@"T@"]) {
		NSRange range = {3, typeAttribute.length - 4};
		NSString* typeName = [typeAttribute substringWithRange:range];
		
		return NSClassFromString(typeName);
	}
	else {
		return nil;
	}
}

- (NSString *)name;
{
	return @(property_getName(_property));
}

- (BOOL)readonly;
{
	return [self hasAttribute:@"R"];
}

- (BOOL)weak;
{
	return [self hasAttribute:@"W"];
}

- (BOOL)hasAttribute:(NSString*)attribute;
{
	NSArray* attributes = [@(property_getAttributes(_property)) componentsSeparatedByString:@","];

	for (NSString* attr in attributes) {
		if ([attr isEqualToString:attribute]) {
			return YES;
		}
	}
	
	return NO;
}

- (NSString *)description;
{
	return @(property_getAttributes(_property));
}

@end



@implementation S2RuntimeMethod {
	Method _method;
}

+ (id)new:(Method)method;
{
	S2RuntimeMethod* object = [super new];
	
	object->_method = method;
	
	return object;
}

- (NSString *)name;
{
	return NSStringFromSelector(method_getName(_method));
}

@end
