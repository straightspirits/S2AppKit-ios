//
//  S2StringTable.h
//  S2AppKit/S2TextKit
//
//  Created by Fumio Furukawa on 2013/01/02.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



extern NSString* S2LocalizedStringFromTable(NSString* table, NSString* key);
static inline NSString* S2LocalizedString(NSString* key)
	{ return S2LocalizedStringFromTable(nil, key); }



@interface S2StringTable : NSObject

+ (S2StringTable*)defaultTable;

+ (id)new:(NSString*)tableName;

@property (readonly) NSString* tableName;

- (NSString*)localizedString:(NSString*)key;
- (NSString*)localizedString:(NSString*)key defaultValue:(NSString*)defaultValue;

@end
