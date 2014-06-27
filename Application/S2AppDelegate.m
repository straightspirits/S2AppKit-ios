//
//  S2AppDelegate.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/11/03.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2AppDelegate.h"



static void fatalHandler(NSException *exception);



S2AppDelegate* S2AppDelegateInstance()
{
	id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
	
	return S2ObjectIsKindOf(appDelegate, S2AppDelegate) ? (S2AppDelegate*)appDelegate : nil;
}



@implementation S2AppDelegate {
	S2LogWriter* _logger;
}

+ (void)initialize;
{
    // グローバル例外ハンドラを設定する
    NSSetUncaughtExceptionHandler(fatalHandler);
}

- (id)init;
{
	if (self = [super init]) {
		// アプリケーションのロガーを作成する
		_logger = [S2LogWriter newDaily:self.logFilePrefix extension:@"log" at:S2IOS.logDirectoryPath];
	}
	return self;
}

- (void)application:(UIApplication*)application didReceiveFatalError:(NSException*)exception;
{
	[self uploadError:S2ErrorLogType_Crash exception:exception];
}

@end



@implementation S2AppDelegate (AppDebugNotification)

- (NSString *)logFilePrefix;
{
	return [NSBundle mainBundle].bundleName;
}

- (S2LogWriter *)logger;
{
	return _logger;
}

- (void)uploadError:(NSString*)type exception:(NSException*)exception;
{
	// ファイルに出力する
	[exception saveToLogFile_type:type];
}

- (void)uploadError:(NSString*)type error:(NSError*)error;
{
	S2LogPass(@"%@", error);
}

@end



void fatalHandler(NSException *exception)
{
	__S2DebugLog(@"S2AppDelegate", @"Fatal: -- Uncaught exception catched --");
	__S2DebugLog(@"S2AppDelegate", @"Fatal: Exception: name=%@ reason=%@ userInfo=%@", exception.name, exception.reason, exception.userInfo);
	__S2DebugLog(@"S2AppDelegate", @"Fatal: Stack Trace: %@", [exception callStackSymbols]);

	// AppDelegateに通知する
	[S2AppDelegateInstance() application:[UIApplication sharedApplication] didReceiveFatalError:exception];
}
