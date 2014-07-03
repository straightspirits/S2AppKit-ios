//
//  ZipArchive.h
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//
// History: 
//    09-11-2008 version 1.0    release
//    10-18-2009 version 1.1    support password protected zip files
//    10-21-2009 version 1.2    fix date bug

#import <UIKit/UIKit.h>

#include "zip.h"
#include "unzip.h"


@protocol ZipArchiveDelegate <NSObject>
@optional
- (void)errorMessage:(NSString*) msg;
- (BOOL)overWriteOperation:(NSString*) file;
@end


@interface ZipStream : NSObject {
@private
	zipFile		_zipFile;
	NSString*   _password;
	__weak id	_delegate;
}

@property (weak, nonatomic) id delegate;

- (BOOL)create:(NSString*)zipFile;
- (BOOL)create:(NSString*)zipFile password:(NSString*)password;
//- (BOOL)open:(NSString*)zipFile;
- (BOOL)addFile:(NSString*)file newname:(NSString*)newname;
- (BOOL)close;

@end



@interface UnzipStream : NSObject {
@private
	unzFile		_unzFile;
	NSString*   _password;
	NSInteger	_numberOfFiles;
	__weak id	_delegate;
}

@property (readonly) NSInteger numberOfFiles;
@property (weak, nonatomic) id delegate;

- (BOOL)open:(NSString*)zipFile;
- (BOOL)open:(NSString*)zipFile password:(NSString*)password;
- (NSMutableDictionary*)extract;
- (BOOL)readNextFile:(NSString**)filename data:(NSData**)data error:(NSError**)error;
- (BOOL)extractTo:(NSString*)baseDirectoryPath overwrite:(BOOL)overwrite;
- (BOOL)close;

@end
