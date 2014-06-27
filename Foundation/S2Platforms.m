//
//  S2Platforms.m
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Functions.h"
#import "S2Platforms.h"
#import "S2Logger.h"



@implementation S2IOS

+ (NSString *)documentsDirectoryPath;
{
	NSArray* pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return pathes.firstObject;
}

+ (NSURL *)documentsDirectoryURL;
{
    NSArray* urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
	return urls.firstObject;
}

+ (NSString *)libraryDirectoryPath;
{
	NSArray* pathes = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return pathes.firstObject;
}

+ (NSURL *)libraryDirectoryURL;
{
    NSArray* urls = [[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
	return urls.firstObject;
}

+ (NSString *)cacheDirectoryPath;
{
	NSArray* pathes = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return pathes.firstObject;
}

+ (NSString *)temporaryDirectoryPath;
{
	return NSTemporaryDirectory();
}

+ (NSString*)logDirectoryPath;
{
	NSString* path = S2PathConcat(S2IOS.libraryDirectoryPath, @"Logs");
	S2AssertNonNil(path);

	// エラーログディレクトリを作成する
	[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

	return path;
}

+ (NSString *)currentLanguage;
{
	return [NSLocale preferredLanguages][0];
}

+ (NSString *)currentLocaleId;
{
	return [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
}

@end



NSMutableArray* S2FileSystemSearch(NSString* directoryPath, NSString* pattern)
{
	NSMutableArray* results = [NSMutableArray new];
	
	NSFileManager* fm = [NSFileManager defaultManager];
	NSError* error;

	NSArray* files = [fm contentsOfDirectoryAtPath:directoryPath error:&error];
	
	if (error) {
		@throw error;
	}
	
	for (NSString* fileName in files) {
		if (S2StringMatch(fileName, pattern))
			[results addObject:S2PathConcat(directoryPath, fileName)];
	}

	return results;
}

NSMutableArray* S2FileSystemSearchRecursive(NSString* directoryPath, NSString* pattern)
{
	NSMutableArray* results = [NSMutableArray new];

	NSFileManager* fm = [NSFileManager defaultManager];
	NSError* error;
	
	NSArray* files = [fm subpathsOfDirectoryAtPath:directoryPath error:&error];
	
	if (error) {
		@throw error;
	}
	
	for (NSString* fileName in files) {
		if (S2StringMatch(fileName, pattern))
			[results addObject:S2PathConcat(directoryPath, fileName)];
	}
	
	return results;
}

void S2FileSystemCreateFile(NSString* filePath, NSObject* object)
{
	NSFileManager* fm = [NSFileManager defaultManager];
	
	NSData* contents;
	if ([object isKindOfClass:[NSData class]])
		contents = (NSData*)object;
	else if ([object isKindOfClass:[NSString class]])
		contents = ((NSString*)object).utf8Data;
	else
		contents = [object toString].utf8Data;

	BOOL result = [fm createFileAtPath:filePath contents:contents attributes:nil];

	if (!result) {
		S2LogError(nil, @"S2FileSystem", @"Failed");
	}
}

void S2FileSystemCreateDirectory(NSString* directoryPath, BOOL withIntermediateDirectories)
{
	NSFileManager* fm = [NSFileManager defaultManager];
	NSError* error;
	
	BOOL result = [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:withIntermediateDirectories attributes:nil error:&error];

	if (!result) {
		S2LogError(nil, @"S2FileSystem", @"Failed");
	}
	
	if (error) {
		@throw [S2AppException new:@"S2FileSystemException" error:error];
	}
}

void S2FileSystemRemoveItem(NSString* itemPath)
{
	NSFileManager* fm = [NSFileManager defaultManager];
	NSError* error;
	
	BOOL result = [fm removeItemAtPath:itemPath error:&error];

	if (!result) {
		S2LogError(nil, @"S2FileSystem", @"Failed");
	}
	
	if (error) {
		@throw [S2AppException new:@"S2FileSystemException" error:error];
	}
}
