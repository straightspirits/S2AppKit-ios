//
//  S2Model.m
//  S2AppKit/S2Foundation
//
//  Created by 古川 文生 on 12/07/22.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2Model.h"
#import "S2NotificationCenter.h"



@implementation S2Model {
	S2NotificationCenter* _notificationCenter;
}

- (id)init;
{
	if (self = [super init]) {
		_notificationCenter = [S2NotificationCenter new];
	}
	return self;
}

- (void)addNotificationHandler_name:(NSString*)name observer:(id)observer selector:(SEL)selector;
{
	[_notificationCenter addObserver:observer selector:selector name:name object:self];
}

- (void)removeNotificationHandler_name:(NSString*)name observer:(id)observer;
{
	[_notificationCenter removeObserver:observer name:name object:self];
}

- (void)removeAllNotificationHandlers:(id)observer;
{
	[_notificationCenter removeObserver:observer];
}

- (void)postNotification_name:(NSString *)name;
{
	[_notificationCenter postNotificationName:name object:self userInfo:nil];
}

- (void)postNotification_name:(NSString *)name userInfo:(NSDictionary*)userInfo;
{
	[_notificationCenter postNotificationName:name object:self userInfo:userInfo];
}

@end
