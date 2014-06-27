//
//  S2ResourceManager.h
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/09.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



@interface S2ResourceManager : NSObject

+ (int)registerSound:(NSURL*)resourceURL;
+ (void)playSound:(int)soundId;

+ (NSData*)loadSound:(NSString*)bundlePath;

@end
