//
//  S2Keychain.h
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2012/08/20.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



@interface S2Keychain : NSObject

+ (NSString*)getItem:(NSString*)service :(NSString*)account;
+ (NSString*)accessGroup:(NSString*)accessGroup getItem:(NSString*)service :(NSString*)account;
+ (BOOL)updateItem:(NSString*)service :(NSString*)account :(NSString*)password;
+ (BOOL)accessGroup:(NSString*)accessGroup updateItem:(NSString*)service :(NSString*)account :(NSString*)password;
+ (BOOL)deleteItem:(NSString*)service :(NSString*)account;
+ (BOOL)accessGroup:(NSString *)accessGroup deleteItem:(NSString*)service :(NSString*)account;

+ (NSArray*)getItems:(NSString*)service;

@end