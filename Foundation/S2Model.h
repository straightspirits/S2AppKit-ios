//
//  S2Model.h
//  S2AppKit/S2Foundation
//
//  Created by 古川 文生 on 12/07/22.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2Objc.h"



@interface S2Model : NSObject

- (void)addNotificationHandler_name:(NSString*)name observer:(id)observer selector:(SEL)selector;
- (void)removeNotificationHandler_name:(NSString*)name observer:(id)observer;
- (void)removeAllNotificationHandlers:(id)observer;

- (void)postNotification_name:(NSString *)name;
- (void)postNotification_name:(NSString *)name userInfo:(NSDictionary*)userInfo;

@end
