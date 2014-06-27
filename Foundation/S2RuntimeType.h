//
//  S2RuntimeType.h
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2012/08/16.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



@interface S2RuntimeType : NSObject

+ (id)typeOf:(id)object;
+ (id)typeFrom:(Class)class;

@property (readonly) NSString* name;

@property (readonly) Class targetClass;

@property (readonly) NSArray* properties;

@property (readonly) NSArray* methods;

- (S2RuntimeType*)supertype;

@end



@interface S2RuntimeProperty : NSObject

- (Class)type;

- (NSString*)name;

- (BOOL)readonly;

- (BOOL)weak;

- (BOOL)hasAttribute:(NSString*)attribute;

@end



@interface S2RuntimeMethod : NSObject

- (NSString*)name;

@end
