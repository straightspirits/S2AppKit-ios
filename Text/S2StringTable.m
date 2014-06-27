//
//  S2StringTable.m
//  S2AppKit/S2TextKit
//
//  Created by Fumio Furukawa on 2013/01/02.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "S2StringTable.h"
#import "S2Functions.h"



static NSString* sDefaultValue = @"\0";



NSString* S2LocalizedStringFromTable(NSString* table, NSString* key)
{
	NSString* value = [[NSBundle mainBundle] localizedStringForKey:key value:sDefaultValue table:table];

	return S2StringEquals(value, sDefaultValue) ? nil : value;
}



@implementation S2StringTable

+ (S2StringTable*)defaultTable;
{
	return [self new:nil];
}

+ (id)new:(NSString*)tableName;
{
	return [[self alloc] init:tableName];
}

- (id)init:(NSString*)tableName;
{
	if (self = [self init]) {
		_tableName = tableName;
	}
	return self;
}

- (NSString*)localizedString:(NSString*)key;
{
	NSString* value = [[NSBundle mainBundle] localizedStringForKey:key value:sDefaultValue table:_tableName];
	
	return S2StringEquals(value, sDefaultValue) ? nil : value;
}

- (NSString*)localizedString:(NSString*)key defaultValue:(NSString*)defaultValue;
{
	NSString* value = [self localizedString:key];
	
	return value ? value : defaultValue;
}

@end
