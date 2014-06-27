//
//  S2Logger.h
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2012/11/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



@class S2LogContext, S2LogWriter;



// イベントログ (時間とメッセージのみ、ユーザー行動視点)
#define S2EventLog(format, ...) \
	[S2Log event:format, ##__VA_ARGS__]

typedef enum _S2LogType {
	S2LogTypePass,			// 通過
	S2LogTypeWarning,		// 警告
	S2LogTypeError,			// エラー
} S2LogType;

// 追跡ログ (ソース特定可能な情報付き、システム視点)
#define S2LogTrace(_type, _format, ...) \
	[S2Log trace_at:__PRETTY_FUNCTION__ line:__LINE__ type:_type format:_format, ##__VA_ARGS__]

// 通過ログ (ソース特定可能な情報付き)
#define S2LogPass(_format, ...) \
	[S2Log trace_at:__PRETTY_FUNCTION__ line:__LINE__ type:S2LogTypePass format:_format, ##__VA_ARGS__]

// ワーニングログ (ソース特定可能な情報付き)
#define S2LogWarning(_format, ...) \
	[S2Log trace_at:__PRETTY_FUNCTION__ line:__LINE__ type:S2LogTypeWarning format:_format, ##__VA_ARGS__]

// エラーログ (ソース特定可能な情報付き)
#define S2LogError(_format, ...) \
	[S2Log trace_at:__PRETTY_FUNCTION__ line:__LINE__ type:S2LogTypeError format:_format, ##__VA_ARGS__]

// システム例外ログ (ソース特定可能な情報付き)
#define S2LogNSException(_exception) \
	[S2Log exception_at:__PRETTY_FUNCTION__ line:__LINE__ exception:_exception]

// システムエラーログ (ソース特定可能な情報付き)
#define S2LogNSError(_error)\
	[S2Log error_at:__PRETTY_FUNCTION__ line:__LINE__ error:_error]



/*
 *	Log Block
 *
 *	Example:
 *		S2_LOG_BEGIN(tag:S2ClassTag)
 *			S2LogPass(@"parameter: %s", @"value")
 *			[S2Log event:@""];
 *		S2_LOG_END
 */
#define S2_LOG_BEGIN(setter) \
	[[[S2LogContext new] setter] run:^() {
#define S2_LOG_END \
	}];



@interface S2Log : NSObject

+ (void)event:(NSString*)format, ...;
+ (void)event:(NSString*)format args:(va_list)args;

+ (void)trace_at:(const char*)sourcePlace line:(int)sourceLine type:(S2LogType)type format:(NSString*)format, ...;
+ (void)trace_at:(const char*)sourcePlace line:(int)sourceLine type:(S2LogType)type format:(NSString*)format args:(va_list)args;
+ (void)trace_at:(const char*)sourcePlace line:(int)sourceLine type:(S2LogType)type message:(NSString*)message;

+ (void)error_at:(const char*)sourcePlace line:(int)sourceLine error:(NSError*)error;

+ (void)stack_trace:(S2LogWriter*)logger;

@end



@interface S2LogContext : NSObject

+ (instancetype)new;

// setter
- (instancetype)logger:(S2LogWriter*)logger;
- (instancetype)tag:(NSString*)tag;
- (instancetype)logger:(S2LogWriter*)logger tag:(NSString*)tag;
- (instancetype)tag:(NSString*)tag logger:(S2LogWriter*)logger;

- (void)run:(void(^)())block;

@property S2LogWriter* logger;
@property NSString* tag;

@end



@interface S2LogWriter : NSObject

+ (S2LogWriter*)applicationLogger;

+ (instancetype)new:(NSString*)filename at:(NSString*)directory;
+ (id)newDaily:(NSString*)title extension:(NSString*)extension at:(NSString*)directory;

- (void)write:(NSString*)message;
- (void)writeStackTrace:(NSException*)exception;

@end
