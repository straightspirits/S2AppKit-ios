//
//  S2ResourceVersionCheckTask.h
//  S2AppKit/S2Service
//
//  Created by Fumio Furukawa on 2013/02/07.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "S2Foundation.h"



@interface S2ResourceVersionCheckTask : S2HttpTask

@property NSString* resourceName;
@property NSURL* plistUrl;
@property NSString* currentVersion;
@property BOOL silentCheck;
@property BOOL forceUpdate;

@end

@interface S2ResourceVersionCheckTask (ProtectMethods)

- (void)detectedSameVersion;
- (void)detectedNewVersion:(NSString*)releaseVersion;
- (void)checkFailed:(NSString*)message;

@end




@interface S2ApplicationVersionCheckTask : S2ResourceVersionCheckTask

- (BOOL)doUpdate;

@end