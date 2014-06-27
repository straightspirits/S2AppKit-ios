//
//  S2Logger.m
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2012/11/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Logger.h"
#import "S2AppDelegate.h"



static const NSString* s_threadDictionaryKey = @"_S2LogContext";

static inline S2LogContext* S2GetLogContext()
{
	return [[NSThread currentThread] threadDictionary][s_threadDictionaryKey];
}

static inline void S2SetLogContext(S2LogContext* context)
{
	[[NSThread currentThread] threadDictionary][s_threadDictionaryKey] = context;
}



@implementation S2Log

// イベントログ (時間とメッセージのみ)
+ (void)event:(NSString*)format, ...;
{
	va_list args;
	va_start(args, format);
	[self event:format args:args];
	va_end(args);
}

+ (void)event:(NSString*)format args:(va_list)args;
{
	S2LogContext* context = S2GetLogContext();
	S2LogWriter* logger = context.logger ?: [S2LogWriter applicationLogger];
	NSString* tag = context.tag;

	NSString* message = [[NSString alloc] initWithFormat:format arguments:args];
	
	if (tag)
		[logger write:S2StringFormat(@"%@> %@", tag, message)];
	else
		[logger write:message];
}

+ (void)trace_at:(const char*)sourcePlace line:(int)sourceLine type:(S2LogType)type format:(NSString*)format, ...;
{
	va_list args;
	va_start(args, format);
	[self trace_at:sourcePlace line:sourceLine type:type format:format args:args];
	va_end(args);
}

+ (void)trace_at:(const char*)sourcePlace line:(int)sourceLine type:(S2LogType)type format:(NSString*)format args:(va_list)args;
{
	NSString* message = format ? [[NSString alloc] initWithFormat:format arguments:args] : @"";
	[self trace_at:sourcePlace line:sourceLine type:type message:message];
}

+ (void)trace_at:(const char*)sourcePlace line:(int)sourceLine type:(S2LogType)type message:(NSString*)message;
{
	S2LogContext* context = S2GetLogContext();
	S2LogWriter* logger = context.logger ?: [S2LogWriter applicationLogger];
	NSString* tag = context.tag;
	
	NSString* typeString;
	switch (type) {
		case S2LogTypePass:
			typeString = @"[PASS] ";
			break;
			
		case S2LogTypeWarning:
			typeString = @"[WARNING] ";
			break;
			
		case S2LogTypeError:
			typeString = @"[ERROR] ";
			break;
			
		defualt:
			typeString = @"";
	}
	
	NSString* threadName = [NSThread currentThread].name;
	if (S2StringIsEmpty(threadName)) {
		threadName = [NSThread currentThread].isMainThread ? @"main" : @"background";
	}
	
	if (tag)
		[logger write:S2StringFormat(@"[%@]: %s(%d): %@> %@%@", threadName, sourcePlace, sourceLine, tag, typeString, message)];
	else
		[logger write:S2StringFormat(@"[%@]: %s(%d): %@%@", threadName, sourcePlace, sourceLine, typeString, message)];
}

+ (void)exception_at:(const char*)sourcePlace line:(int)sourceLine error:(NSException*)exception;
{
	[self trace_at:sourcePlace line:sourceLine type:S2LogTypeError message:exception.description];
}

+ (void)error_at:(const char*)sourcePlace line:(int)sourceLine error:(NSError*)error;
{
	[self trace_at:sourcePlace line:sourceLine type:S2LogTypeError message:error.description];
}

+ (void)stack_trace:(S2LogWriter*)logger;
{
	if (!logger) {
		logger = [S2LogWriter applicationLogger];
	}
	
	@try {
		@throw [NSException exceptionWithName:@"" reason:nil userInfo:nil];
	}
	@catch (NSException* ex) {
		[logger writeStackTrace:ex];
	}
}

@end



@implementation S2LogContext

+ (instancetype)new;
{
	return [[self alloc] init];
}

- (instancetype)logger:(S2LogWriter*)logger;
{
	_logger = logger;

	return self;
}

- (instancetype)tag:(NSString*)tag;
{
	_tag = tag;
	
	return self;
}

- (instancetype)logger:(S2LogWriter*)logger tag:(NSString*)tag;
{
	_logger = logger;
	_tag = tag;
	
	return self;
}

- (instancetype)tag:(NSString*)tag logger:(S2LogWriter*)logger;
{
	_logger = logger;
	_tag = tag;
	
	return self;
}

- (void)run:(void (^)())block;
{
	S2AssertNonNil(block);

	@try {
		S2SetLogContext(self);
		
		block();
	}
	@finally {
		S2SetLogContext(nil);
	}
}

@end



@interface S2LogWriter ()

@property (readonly) NSString* filepath;

@end

@interface S2DailyLogWriter : S2LogWriter

- (instancetype)initDaily:(NSString*)title extension:(NSString*)extension at:(NSString*)directory;

@end



@implementation S2LogWriter {
	NSString* _filepath;
	NSLock* _lock;
}

+ (S2LogWriter*)applicationLogger;
{
	S2AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
	
	return S2ObjectIsKindOf(appDelegate, S2AppDelegate) ? appDelegate.logger : nil;
}

+ (instancetype)new:(NSString*)filename at:(NSString*)directory;
{
	S2LogWriter* logger = [[self alloc] init:filename at:directory];

	[logger writeData:[NSData dataWithBytes:"\n\n\n" length:3] toPath:logger.filepath];

	return logger;
}

+ (id)newDaily:(NSString*)title extension:(NSString*)extension at:(NSString*)directory;
{
	S2LogWriter* logger = [[S2DailyLogWriter alloc] initDaily:title extension:extension at:directory];
	
	[logger writeData:[NSData dataWithBytes:"\n\n\n" length:3] toPath:logger.filepath];
	
	return logger;
}

- (instancetype)init:(NSString*)filename at:(NSString*)directory;
{
	if (self = [self init]) {
		_filepath = S2PathConcat(directory, filename);
		_lock = [NSLock new];
		
		NSError* error;
		[[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
		
		if (error) {
			NSLog(@"Runtime Error: %@ [%ld] %@", error.domain, (long)error.code, error.localizedDescription);
			@throw error;
		}
	}
	return self;
}

- (NSString *)filepath;
{
	return _filepath;
}

- (void)write:(NSString*)message;
{
	NSLog(@"%@", message);

	[_lock lock];
	
	NSDate* now = S2DateNow();
	NSString* line = S2StringFormat(@"%@: %@\n", S2DateFormatString(@"yyyy/MM/dd HH:mm:ss.SSS", now), message);

	[self writeData:line.utf8Data toPath:self.filepath];

	[_lock unlock];
}

- (void)writeStackTrace:(NSException*)exception;
{
	[_lock lock];

	[self writeData:@"Stack trace:\n".utf8Data toPath:self.filepath];
	
	for (NSString* callStackSymbol in exception.callStackSymbols) {
		NSLog(@"%@", callStackSymbol);
	
		NSString* line = S2StringFormat(@"\t%@\n", callStackSymbol);
	
		[self writeData:line.utf8Data toPath:self.filepath];
	}

	[_lock unlock];
}

- (void)writeData:(NSData*)data toPath:(NSString*)filepath;
{
	NSFileManager* fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:filepath]) {
		BOOL result = [fileManager createFileAtPath:filepath contents:nil attributes:nil];

		if (!result) {
			NSLog(@"Runtime Error: file cannot created. '%@'", _filepath);
			return;
		}
	}
	
	NSFileHandle* handle = [NSFileHandle fileHandleForUpdatingAtPath:filepath];

	if (!handle) {
		NSLog(@"Runtime Error: file cannnot opened. '%@'", _filepath);
		return;
	}

	[handle seekToEndOfFile];
	[handle writeData:data];

	[handle closeFile];
}

@end



@implementation S2DailyLogWriter {
	NSString* _directory;
	NSString* _title;
	NSString* _extension;
}

- (instancetype)initDaily:(NSString*)title extension:(NSString*)extension at:(NSString*)directory;
{
	if (self = [self init:@"" at:directory]) {
		_directory = directory;
		_title = title;
		_extension = extension;
	}
	return self;
}

- (NSString *)filepath;
{
	NSString* filename = S2StringFormat(@"%@-%@.%@", _title, S2DateFormatString(@"yyyyMMdd", S2DateNow()), _extension);

	return S2PathConcat(_directory, filename);
}

@end
