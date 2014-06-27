//
//  S2AdBanner.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/11/05.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2AdBanner.h"



@interface S2AdBanner ()

@end



@implementation S2AdBanner {
}

S2_DEALLOC_LOGGING_IMPLEMENT

- (void)startAd;
{
	S2AssertMustOverride();
}

- (void)stopAd;
{
	S2AssertMustOverride();
}

- (BOOL)running;
{
	return NO;
}

@end
