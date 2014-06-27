//
//  S2Keychain.m
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2012/08/20.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Keychain.h"



@implementation S2Keychain

+ (NSString*)getItem:(NSString*)service :(NSString*)account;
{
	return [self accessGroup:nil getItem:service :account];
}

+ (NSString*)accessGroup:(NSString*)accessGroup getItem:(NSString*)service :(NSString*)account;
{
	S2AssertParameter(account);
	S2AssertParameter(service);
	
	NSMutableDictionary* query = [NSMutableDictionary dictionary];
	query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	if (accessGroup)
		query[(__bridge id)kSecAttrAccessGroup] = accessGroup;
	query[(__bridge id)kSecAttrService] = service;
	query[(__bridge id)kSecAttrAccount] = account;
	query[(__bridge id)kSecReturnData] = (id)kCFBooleanTrue;
	
	CFTypeRef passwordData = nil;
	OSStatus err = SecItemCopyMatching((__bridge CFDictionaryRef)query, &passwordData);
	
	if (err != noErr) {
		if (err == errSecItemNotFound) {
			// do nothing
		}
		else {
			NSLog(@"%s|SecItemCopyMatching: error(%d)", __PRETTY_FUNCTION__, (int)err);
		}

		return nil;
	}

	return [(__bridge NSData*)passwordData utf8String];
}

+ (BOOL)updateItem:(NSString*)service :(NSString*)account :(NSString*)password;
{
	return [self accessGroup:nil updateItem:service :account :password];
}

+ (BOOL)accessGroup:(NSString *)accessGroup updateItem:(NSString *)service :(NSString *)account :(NSString *)password;
{
	S2AssertParameter(password);
	S2AssertParameter(account);
	S2AssertParameter(service);

	NSMutableDictionary* attributes = nil;
	NSMutableDictionary* query = [NSMutableDictionary dictionary];
	
	query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	if (accessGroup)
		query[(__bridge id)kSecAttrAccessGroup] = accessGroup;
	query[(__bridge id)kSecAttrService] = service;
	query[(__bridge id)kSecAttrAccount] = account;
	
	OSStatus err = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
	
	if (err == noErr) {
		// update item
		attributes = [NSMutableDictionary dictionary];
		attributes[(__bridge id)kSecValueData] = password.utf8Data;
		attributes[(__bridge id)kSecAttrModificationDate] = [NSDate date];
		
		err = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributes);
		if (err != noErr) {
			NSLog(@"%s|SecItemUpdate: error(%d)", __PRETTY_FUNCTION__, (int)err);
			return NO;
		}

		return YES;
	}
	else if (err == errSecItemNotFound) {
		// add new item
		attributes = [NSMutableDictionary dictionary];
		attributes[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
		if (accessGroup)
			attributes[(__bridge id)kSecAttrAccessGroup] = accessGroup;
		attributes[(__bridge id)kSecAttrService] = service;
		attributes[(__bridge id)kSecAttrAccount] = account;
		attributes[(__bridge id)kSecValueData] = password.utf8Data;
		attributes[(__bridge id)kSecAttrCreationDate] = [NSDate date];
		attributes[(__bridge id)kSecAttrModificationDate] = [NSDate date];
		
		err = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
		if (err != noErr) {
			NSLog(@"%s|SecItemAdd: error(%d)", __PRETTY_FUNCTION__, (int)err);
			return NO;
		}
		
		return YES;
	}
	else {
		NSLog(@"%s|SecItemCopyMatching: error(%d)", __PRETTY_FUNCTION__, (int)err);
		return NO;
	}
}

+ (BOOL)deleteItem:(NSString*)service :(NSString*)account;
{
	return [self accessGroup:nil deleteItem:service :account];
}

+ (BOOL)accessGroup:(NSString *)accessGroup deleteItem:(NSString*)service :(NSString*)account;
{
	S2AssertParameter(account);
	S2AssertParameter(service);

	NSMutableDictionary* query = [NSMutableDictionary dictionary];
	query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	if (accessGroup)
		query[(__bridge id)kSecAttrAccessGroup] = accessGroup;
	query[(__bridge id)kSecAttrService] = service;
	query[(__bridge id)kSecAttrAccount] = account;
	
	OSStatus err = SecItemDelete((__bridge CFDictionaryRef)query);
	
	if (err != noErr) {
		NSLog(@"%s|SecItemDelete: error(%d)", __PRETTY_FUNCTION__, (int)err);
		return NO;
	}
	
	return YES;
}

+ (NSArray*)getItems:(NSString*)service
{
	S2AssertParameter(service);
	
	NSMutableDictionary* query = [NSMutableDictionary dictionary];
	query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
	query[(__bridge id)kSecAttrService] = service;
	query[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
	query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
	query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitAll;
	
	CFArrayRef result = nil;
	OSStatus err = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef*)&result);
	
	if (err != noErr) {
		NSLog(@"%s|SecItemCopyMatching: error(%d)", __PRETTY_FUNCTION__, (int)err);
		return nil;
	}

	return (__bridge NSArray*)result;
}

@end
