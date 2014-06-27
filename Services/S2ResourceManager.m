//
//  S2ResourceManager.m
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/09.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2ResourceManager.h"
#import "S2Logger.h"
#import <AudioToolbox/AudioToolbox.h>



@implementation S2ResourceManager

+ (int)registerSound:(NSURL*)resourceURL;
{
	SystemSoundID soundId;
	OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)resourceURL, &soundId);
	
	if (status != 0) {
		S2LogError(nil, S2ClassTag, @"OSStatus = %d", status);
	}
	
	return soundId;
}

+ (void)playSound:(int)soundId;
{
	AudioServicesPlayAlertSound(soundId);
}
//static int idd = 1104;

+ (NSData*)loadSound:(NSString*)bundlePath;
{
	return nil;
}

@end
