//
//  S2NotificationCenter.m
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2013/07/30.
//  Copyright (c) 2013年 Straight Spirits Co.Ltd. All rights reserved.
//

#import "S2NotificationCenter.h"
#import "S2Objc.h"
#import "S2AppDelegate.h"



@implementation S2NotificationCenter

static void runPost(void(^callback)())
{
	@try {
		callback();
	}
	@catch (NSException *exception) {
		// エラーログを送信する
		[S2AppDelegateInstance() uploadError:S2ErrorLogType_ClientError exception:exception];
	}
}

- (void)postNotification:(NSNotification *)notification;
{
	runPost(^{
		[super postNotification:notification];
	});
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject;
{
	runPost(^{
		[super postNotificationName:aName object:anObject];
	});
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
{
	runPost(^{
		[super postNotificationName:aName object:anObject userInfo:aUserInfo];
	});
}

@end
