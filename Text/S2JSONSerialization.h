//
//  S2JSONSerialization.h
//  S2AppKit/S2TextKit
//
//  Created by 古川 文生 on 12/07/16.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2Objc.h"
#import "S2Data.h"



@interface S2JSONSerialization : NSObject

+ (NSString*)jsonStringWithObject:(id)object;
+ (NSData*)jsonUTF8DataWithObject:(id)object;

+ (id)objectWithJsonString:(NSString*)jsonString;
+ (id)objectWithJsonUTF8Data:(NSData*)jsonUTF8Data;

@end



@interface NSDateComponents (JSONSerialization) <S2DataSerialize>

- (void)serializeTo:(NSMutableDictionary*)dictionary;
- (void)deserializeFrom:(NSDictionary*)dictionary;

@end