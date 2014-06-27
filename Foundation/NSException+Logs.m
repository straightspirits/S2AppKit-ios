//
//  NSException+Logs.m
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Functions.h"
#import "S2Platforms.h"
#import "UIDevice+Extensions.h"
#import <mach/mach.h>
#import <mach-o/dyld_images.h>



S2StringValueImplementation(S2ErrorLogType, ClientError);
S2StringValueImplementation(S2ErrorLogType, LibraryError);
S2StringValueImplementation(S2ErrorLogType, ServerError);
S2StringValueImplementation(S2ErrorLogType, DataError);
S2StringValueImplementation(S2ErrorLogType, Crash);



struct dyld_all_image_infos* S2KernelGetAllImageInfos()
{
	task_dyld_info_data_t task_dyld_info;
	mach_msg_type_number_t count = TASK_DYLD_INFO_COUNT;
    
    if (task_info(mach_task_self(), TASK_DYLD_INFO, (task_info_t)&task_dyld_info, &count)) {
		exit(0);
	}
	
	return (struct dyld_all_image_infos*)(uintptr_t)task_dyld_info.all_image_info_addr;
}

NSDictionary* S2KernelGetAllImageAddresses()
{
	struct dyld_all_image_infos* allImageInfos = S2KernelGetAllImageInfos();
	
	NSMutableDictionary* images = [NSMutableDictionary new];
	
	for (int index = 0; index < allImageInfos->infoArrayCount; ++index) {
		const struct dyld_image_info* imageInfo = allImageInfos->infoArray + index;
		NSString* imageFilePath = [NSString stringWithCString:imageInfo->imageFilePath encoding:NSUTF8StringEncoding];
		
		images[S2PathFileName(imageFilePath)] = @((intptr_t)imageInfo->imageLoadAddress);
	}
	
	return images;
}

NSArray* S2KernelImagesKeys(NSDictionary* kernelImages)
{
	return [kernelImages keysSortedByValueUsingComparator:^NSComparisonResult(NSNumber* obj1, NSNumber* obj2) {
		return obj1.unsignedIntegerValue > obj2.unsignedIntegerValue;
	}];
}



@implementation NSException (Logs)

+ (NSString*)errorLogDirectoryPath;
{
	NSString* errorLogDirectoryPath;

	// ログディレクトリパスを取得する
	errorLogDirectoryPath = S2IOS.logDirectoryPath;
	
	return errorLogDirectoryPath;
}

+ (NSArray*)listErrorLogFileNames;
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	NSMutableArray* fileNames = [NSMutableArray new];
	for (NSString* fileName in [fileManager contentsOfDirectoryAtPath:[NSException errorLogDirectoryPath] error:nil]) {
		if (![fileName hasPrefix:@"."] && [fileName hasSuffix:@".log"]) {
			[fileNames addObject:fileName];
		}
	}
	
	return fileNames;
}

- (NSString*)saveToLogFile_type:(NSString*)type;
{
	return [self saveToLogFile_type:type additionalInfo:nil];
}

- (NSString*)saveToLogFile_type:(NSString*)type additionalInfo:(NSArray*)additionalInfo;
{
	// エラーログファイルパスを作成する
	NSString* errorLogFilePath = S2PathConcat(
		[NSException errorLogDirectoryPath],
		S2StringFormat(@"%@%@.%@%@", S2ErrorLogPrefix, S2DateFormatString(@"yyyyMMdd-HHmmss-SSS", S2DateNow()), type, S2ErrorLogSuffix)
	);
	
	[self saveToLogFile_path:errorLogFilePath additionalInfo:additionalInfo];
	
	return errorLogFilePath;
}

- (void)saveToLogFile_path:(NSString*)errorLogFilePath;
{
	[self saveToLogFile_path:errorLogFilePath additionalInfo:nil];
}

- (void)saveToLogFile_path:(NSString*)errorLogFilePath additionalInfo:(NSArray*)additionalInfo;
{
	// エラーログファイルを作成する
	[[NSFileManager defaultManager] createFileAtPath:errorLogFilePath contents:nil attributes:nil];
	
	// エラーログファイルをオープンする
	NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingAtPath:errorLogFilePath];
	if (!fileHandle) {
		__S2DebugLog(@"Fatal: ErrorLog-File creation failed: '%@'", errorLogFilePath);
		return;
	}
	
	// エラーログファイルに、デバイス情報を書き込む
	UIDevice* device = [UIDevice currentDevice];
	[fileHandle writeUtf8Data:@"Environment:\n"];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tBundle Identifier: %@\n", [NSBundle mainBundle].bundleIdentifier)];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tDateTime: %@\n", S2DateFormatString(@"yyyyMMdd-HHmmss-SSS", S2DateNow()))];
	[fileHandle writeUtf8Data:@"\n"];

	[fileHandle writeUtf8Data:@"Device:\n"];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tName: %@\n", device.name)];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tMachine: %@\n", device.hwMachine)];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tModel: %@\n", device.model)];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tLocalized Model: %@\n", device.localizedModel)];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tHardware Model: %@\n", device.hwModel)];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tSystem Name: %@\n", device.systemName)];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tSystem Version: %@\n", device.systemVersion)];
//	[fileHandle writeUtf8Data:S2StringFormat(@"\tUID:%@\n", device.uniqueIdentifier)];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tMac Address: %@\n", device.macAddress)];
	[fileHandle writeUtf8Data:S2StringFormat(@"\tUnique Identifier: %@\n", device.uniqueIdentifierForVendor)];
	[fileHandle writeUtf8Data:@"\n"];
	
	if (additionalInfo && additionalInfo.count > 0) {
		[fileHandle writeData:@"Additional Info:\n".utf8Data];
		for (NSObject* additionalInfoItem in additionalInfo) {
			[fileHandle writeData:S2StringFormat(@"\t%@\n", additionalInfoItem.description).utf8Data];
		}
		[fileHandle writeData:@"\n".utf8Data];
	}

	// エラーログファイルに、例外情報を書き込む
	NSString* exceptionInfo = S2StringFormat(@"%@:\n\treason: %@\n\tuserInfo: %@\n\n", self.name, self.reason, self.userInfo ? self.userInfo : @"(no data)");
	[fileHandle writeData:exceptionInfo.utf8Data];
	
	// エラーログファイルに、スタックトレースを書き込む
	[fileHandle writeData:@"Stack Trace:\n".utf8Data];
	for (id stackSymbol in [self callStackSymbols]) {
		[fileHandle writeData:S2StringFormat(@"\t%@\n", stackSymbol).utf8Data];
	}

	// エラーログファイルに、カーネルイメージ情報を書き込む
	NSDictionary* allKernelImageAddresses = S2KernelGetAllImageAddresses();
	
	[fileHandle writeData:[NSData dataWithBytes:"\n" length:1]];
	[fileHandle writeData:@"Binary Images:\n".utf8Data];
	for (NSString* kernelImageName in S2KernelImagesKeys(allKernelImageAddresses)) {
		uintptr_t kernelImageAddress = [allKernelImageAddresses[kernelImageName] unsignedLongValue];
		[fileHandle writeData:S2StringFormat(@"\t%p - : %@\n", (void*)kernelImageAddress, kernelImageName).utf8Data];
	}
	
	// エラーログファイルをクローズする
	[fileHandle closeFile];
	
    __S2DebugLog(S2ClassTag, @"Fatal: save to ErrorLog-File: '%@'", errorLogFilePath);
}

@end
