//
//  S2Debug.m
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/09.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Debug.h"



//#ifdef DEBUG

void __S2DebugLogWithArgs(NSString* tag, NSString* format, va_list args)
{
	if (!format)
		return;
	
	NSString* message = [[NSString alloc] initWithFormat:format arguments:args];
	
	if (tag)
		NSLog(@"%@> %@", tag, message);
	else
		NSLog(@"%@", message);
}

void __S2DebugLog(NSString* tag, NSString* format, ...)
{
	if (!format)
		return;
	
	va_list args;
	va_start(args, format);
	__S2DebugLogWithArgs(tag, format, args);
	va_end(args);
}

//#endif



