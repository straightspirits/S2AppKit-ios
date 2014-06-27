//
//  S2AppDelegate.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/11/03.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Foundation.h"
#import <UIKit/UIKit.h>



@interface S2AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow* window;

- (void)application:(UIApplication*)application didReceiveFatalError:(NSException*)exception;

@end

@interface S2AppDelegate (AppDebugNotification)

@property (readonly) NSString* logFilePrefix;
@property (readonly) S2LogWriter* logger;

- (void)uploadError:(NSString*)type exception:(NSException*)exception;
- (void)uploadError:(NSString*)type error:(NSError*)error;

@end



extern S2AppDelegate* S2AppDelegateInstance();

