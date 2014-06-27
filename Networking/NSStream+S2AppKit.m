//
//  NSStream+S2AppKit.m
//  S2AppKit/S2Network
//
//  Created by Fumio Furukawa on 2012/11/16.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "NSStream+S2AppKit.h"



@implementation NSStream (S2AppKit)

+ (void)getStreamsToHostNamed:(NSString *)hostName
						 port:(UInt32)port
				  inputStream:(out NSInputStream **)inputStreamPtr
				 outputStream:(out NSOutputStream **)outputStreamPtr
{
    assert(hostName != nil);
    assert((port > 0) && (port < 65536));
    assert((inputStreamPtr != NULL) || (outputStreamPtr != NULL));
	
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
	
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)hostName, port,
		((inputStreamPtr  != NULL) ? &readStream  : NULL),
		((outputStreamPtr != NULL) ? &writeStream : NULL)
	);
	
    if (inputStreamPtr != NULL) {
        *inputStreamPtr  = CFBridgingRelease(readStream);
    }
    if (outputStreamPtr != NULL) {
        *outputStreamPtr = CFBridgingRelease(writeStream);
    }
}

@end
