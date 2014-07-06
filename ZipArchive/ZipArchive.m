//
//  ZipArchive.mm
//  
//
//  Created by aish on 08-9-11.
//  acsolu@gmail.com
//  Copyright 2008  Inc. All rights reserved.
//

#import "S2Foundation.h"
#import "ZipArchive.h"
#import "zlib.h"
#import "zconf.h"



@implementation ZipStream

- (id)init
{
	if( self=[super init] )
	{
		_zipFile = NULL ;
	}
	return self;
}

- (void)dealloc
{
	[self close];
//	[super dealloc];
}

- (BOOL)create:(NSString*)zipFile
{
	_zipFile = zipOpen( (const char*)[zipFile UTF8String], APPEND_STATUS_CREATE);
	if( !_zipFile ) 
		return NO;
	return YES;
}

- (BOOL)create:(NSString*)zipFile password:(NSString*)password
{
	_password = password;
	return [self create:zipFile];
}

- (BOOL)open:(NSString*)zipFile;
{
	_zipFile = zipOpen( (const char*)[zipFile UTF8String], 3);
	if( !_zipFile )
		return NO;
	return YES;
}

- (BOOL)addFile:(NSString*)file newname:(NSString*)newname;
{
	if( !_zipFile )
		return NO;
//	tm_zip filetime;
	time_t current;
	time( &current );
	
	zip_fileinfo zipInfo = {0};
//	zipInfo.dosDate = (unsigned long) current;
	
	NSError* error;
	NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:&error];
	if( attr )
	{
		NSDate* fileDate = (NSDate*)[attr objectForKey:NSFileModificationDate];
		if( fileDate )
		{
			// some application does use dosDate, but tmz_date instead
			NSCalendar* currCalendar = [NSCalendar currentCalendar];
			uint flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | 
				NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ;
			NSDateComponents* dc = [currCalendar components:flags fromDate:fileDate];
			zipInfo.tmz_date.tm_sec = (uInt)[dc second];
			zipInfo.tmz_date.tm_min = (uInt)[dc minute];
			zipInfo.tmz_date.tm_hour = (uInt)[dc hour];
			zipInfo.tmz_date.tm_mday = (uInt)[dc day];
			zipInfo.tmz_date.tm_mon = (uInt)[dc month] - 1;
			zipInfo.tmz_date.tm_year = (uInt)[dc year];
		}
	}
	
	int ret ;
	NSData* data = nil;
	if( [_password length] == 0 )
	{
		ret = zipOpenNewFileInZip( _zipFile,
								  (const char*) [newname UTF8String],
								  &zipInfo,
								  NULL,0,
								  NULL,0,
								  NULL,//comment
								  Z_DEFLATED,
								  Z_DEFAULT_COMPRESSION );
	}
	else
	{
		data = [ NSData dataWithContentsOfFile:file];
		uLong crcValue = crc32( 0L,NULL, 0L );
		crcValue = crc32( crcValue, (const Bytef*)data.bytes, (uInt)data.length );
		ret = zipOpenNewFileInZip3( _zipFile,
								  (const char*) [newname UTF8String],
								  &zipInfo,
								  NULL,0,
								  NULL,0,
								  NULL,//comment
								  Z_DEFLATED,
								  Z_DEFAULT_COMPRESSION,
								  0,
								  15,
								  8,
								  Z_DEFAULT_STRATEGY,
								  [_password cStringUsingEncoding:NSASCIIStringEncoding],
								  crcValue );
	}
	if( ret!=Z_OK )
	{
		return NO;
	}
	if( data==nil )
	{
		data = [NSData dataWithContentsOfFile:file];
	}

	uInt dataLen = (uInt)data.length;
	ret = zipWriteInFileInZip( _zipFile, (const void*)data.bytes, dataLen);
	if( ret!=Z_OK )
	{
		return NO;
	}
	ret = zipCloseFileInZip( _zipFile );
	if( ret!=Z_OK )
		return NO;
	return YES;
}

- (BOOL)close
{
	_password = nil;
	if( _zipFile==NULL )
		return NO;
	BOOL ret =  zipClose( _zipFile,NULL )==Z_OK?YES:NO;
	_zipFile = NULL;
	return ret;
}

#pragma mark wrapper for delegate

- (void)outputErrorMessage:(NSString*)msg
{
	if( _delegate && [_delegate respondsToSelector:@selector(ErrorMessage)] )
		[_delegate errorMessage:msg];
}

@end



@implementation UnzipStream {
	int _currentFileIndex;
}

- (BOOL)open:(NSString*)zipFile
{
	_unzFile = unzOpen((const char*)[zipFile UTF8String]);
	if (_unzFile == NULL) {
		return NO;
	}

	unz_global_info globalInfo;
	if (unzGetGlobalInfo(_unzFile, &globalInfo) != UNZ_OK) {
		return NO;
	}

	NSLog(@"%ld entries in the zip file", globalInfo.number_entry);
	_numberOfFiles = globalInfo.number_entry;
	_currentFileIndex = -1;

	return YES;
}

- (BOOL)open:(NSString*)zipFile password:(NSString*)password
{
	_password = password;
	return [self open:zipFile];
}

- (NSMutableDictionary*)extract;
{
	NSMutableDictionary* dictionary = [NSMutableDictionary new];
	
	NSString* filename;
	NSData* data;
	while ([self readNextFile:&filename data:&data error:nil]) {
		[dictionary setObject:(data ? data : NSNull.null) forKey:filename];
	}

	return dictionary;
}

- (BOOL)readNextFile:(NSString**)filename data:(NSData**)data error:(NSError**)error;
{
	if (filename) *filename = nil;
	if (data) *data = nil;

	if (_currentFileIndex < 0) {
		int ret = unzGoToFirstFile(_unzFile);
		S2Assert(ret == UNZ_OK, @"unzGoToFirstFile() failed.");
		_currentFileIndex = 0;
	}
	else {
		int ret = unzGoToNextFile(_unzFile);
		if (ret == UNZ_END_OF_LIST_OF_FILE) {
			return NO;
		}
		
		S2Assert(ret == UNZ_OK, @"unzGoToNextFile() failed.");
		++_currentFileIndex;
	}

	int ret;
	if (_password.length == 0)
		ret = unzOpenCurrentFile(_unzFile);
	else
		ret = unzOpenCurrentFilePassword(_unzFile, [_password cStringUsingEncoding:NSASCIIStringEncoding]);
	
	if (ret != UNZ_OK) {
		S2Assert(ret == UNZ_OK, @"unzOpenCurrentFile() failed.");
		return NO;
	}
	
	// reading data and write to file
	unz_file_info fileInfo;
	ret = unzGetCurrentFileInfo(_unzFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
	if (ret != UNZ_OK) {
		S2Assert(ret == UNZ_OK, @"unzGetCurrentFileInfo() failed.");
		unzCloseCurrentFile(_unzFile);
		return YES;
	}
	
	NSString* fileNameInZip = [self fileNameInZip:&fileInfo];
	BOOL isDirectory = [fileNameInZip hasSuffix:@"/"];

	if (filename) *filename = fileNameInZip;
	
	if (!isDirectory) {
		[self writeToData:data];
	}

	return YES;
}

- (BOOL)extractTo:(NSString*)baseDirectoryPath overwrite:(BOOL)overwrite;
{
	BOOL success = YES;
	NSFileManager* fman = [NSFileManager defaultManager];

	int ret = unzGoToFirstFile(_unzFile);
	if (ret != UNZ_OK) {
		[self outputErrorMessage:@"Failed"];
		return NO;
	}
	
	do {
		if ([_password length] == 0)
			ret = unzOpenCurrentFile(_unzFile);
		else
			ret = unzOpenCurrentFilePassword(_unzFile, [_password cStringUsingEncoding:NSASCIIStringEncoding]);

		if (ret != UNZ_OK) {
			[self outputErrorMessage:@"Error occurs"];
			success = NO;
			break;
		}

		// reading data and write to file
		unz_file_info fileInfo;
		ret = unzGetCurrentFileInfo(_unzFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if (ret != UNZ_OK) {
			[self outputErrorMessage:@"Error occurs while getting file info"];
			success = NO;
			unzCloseCurrentFile(_unzFile);
			break;
		}
		
		NSString* fileNameInZip = [self fileNameInZip:&fileInfo];
		BOOL isDirectory = [fileNameInZip hasSuffix:@"/"];
		NSString* fullPath = [baseDirectoryPath stringByAppendingPathComponent:fileNameInZip];
		
		// ディレクトリを作成する
		if (isDirectory)
			[fman createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
		else
			[fman createDirectoryAtPath:[fullPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];

		// 上書きチェック？
		if ([fman fileExistsAtPath:fullPath] && !isDirectory && !overwrite) {
			if (![self overWrite:fullPath]) {
				unzCloseCurrentFile( _unzFile );
				ret = unzGoToNextFile( _unzFile );
				continue;
			}
		}
		
		// ファイルに書き込む
		[self writeToFile:fullPath fileInfo:&fileInfo];

		ret = unzGoToNextFile(_unzFile);
	} while (ret == UNZ_OK && UNZ_OK != UNZ_END_OF_LIST_OF_FILE);

	return success;
}

- (NSString*)fileNameInZip:(unz_file_info*)fileInfo;
{
	uLong filenameLength = fileInfo->size_filename;

	// ファイル名を取得する
	char* filename = (char*)malloc(filenameLength + 1);
	unzGetCurrentFileInfo(_unzFile, fileInfo, filename, filenameLength + 1, NULL, 0, NULL, 0);
	filename[filenameLength] = '\0';
	
	// check if it contains directory
	NSString * strPath = [NSString stringWithUTF8String:filename];

	free(filename);

	// ¥ を / に変換する
	if ([strPath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/\\"]].location!=NSNotFound) {
		strPath = [strPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
	}
	
	return strPath;
}

- (BOOL)writeToData:(NSData**)data;
{
	NSMutableData* _data = [NSMutableData new];
	
	while (true) {
		unsigned char buffer[4096];
		
		int read = unzReadCurrentFile(_unzFile, buffer, 4096);
		if (read == 0) {
			break;
		}
		
		if (read > 0) {
			[_data appendBytes:buffer length:read];
		}
		else if (read < 0) {
			[self outputErrorMessage:@"Failed to reading zip file"];
			return NO;
		}
	}
	
	if (data) *data = _data;
	
	return YES;
}

- (void)writeToFile:(NSString*)filepath fileInfo:(unz_file_info*)fileInfo;
{
	FILE* fp = fopen((const char*)[filepath UTF8String], "wb");
	if (!fp)
		return;

	while (true) {
		unsigned char buffer[4096];

		int read = unzReadCurrentFile(_unzFile, buffer, 4096);
		if (read == 0) {
			break;
		}
		
		if (read > 0) {
			fwrite(buffer, read, 1, fp );
		}
		else if (read < 0) {
			[self outputErrorMessage:@"Failed to reading zip file"];
			break;
		}
	}
	
	fclose(fp);
		
	// set the orignal datetime property
	NSDate* orgDate = [self unzTimeToNSDate:&fileInfo->tmu_date];
		
	NSDictionary* attr = [NSDictionary dictionaryWithObject:orgDate forKey:NSFileModificationDate];
	if (![[NSFileManager defaultManager] setAttributes:attr ofItemAtPath:filepath error:nil]) {
		// cann't set attributes
		NSLog(@"Failed to set attributes");
	}
	
	unzCloseCurrentFile(_unzFile);
}

- (NSDate*)unzTimeToNSDate:(tm_unz*)tm
{
	NSDateComponents *dc = [[NSDateComponents alloc] init];
	
	dc.second = tm->tm_sec;
	dc.minute = tm->tm_min;
	dc.hour = tm->tm_hour;
	dc.day = tm->tm_mday;
	dc.month = tm->tm_mon+1;
	dc.year = tm->tm_year;

	NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

	return [calendar dateFromComponents:dc];
}

- (BOOL)close
{
	_password = nil;
	if( _unzFile )
		return unzClose( _unzFile )==UNZ_OK;
	return YES;
}

#pragma mark wrapper for delegate

- (void)outputErrorMessage:(NSString*)msg
{
	if( _delegate && [_delegate respondsToSelector:@selector(errorMessage)] )
		[_delegate errorMessage:msg];
}

- (BOOL)overWrite:(NSString*)file
{
	if( _delegate && [_delegate respondsToSelector:@selector(overWriteOperation)] )
		return [_delegate overWriteOperation:file];
	return YES;
}

@end


