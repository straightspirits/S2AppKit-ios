//
//  S2Platforms.h
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



@interface S2IOS : NSObject

+ (NSString*)documentsDirectoryPath;
+ (NSURL*)documentsDirectoryURL;
+ (NSString*)libraryDirectoryPath;
+ (NSString*)cacheDirectoryPath;
+ (NSString*)temporaryDirectoryPath;
+ (NSString*)logDirectoryPath;

+ (NSString*)currentLanguage;
+ (NSString*)currentLocaleId;

@end



NSMutableArray* S2FileSystemSearch(NSString* directoryPath, NSString* pattern);
NSMutableArray* S2FileSystemSearchRecursive(NSString* directoryPath, NSString* pattern);

void S2FileSystemCreateFile(NSString* filePath, NSObject* object);
void S2FileSystemCreateDirectory(NSString* directoryPath, BOOL withIntermediateDirectories);
void S2FileSystemRemoveItem(NSString* itemPath);
