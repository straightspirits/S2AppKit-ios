//
//  NSStream+S2AppKit.h
//  S2AppKit/S2Network
//
//  Created by Fumio Furukawa on 2012/11/16.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



@interface NSStream (S2AppKit)

+ (void)getStreamsToHostNamed:(NSString *)hostName
						 port:(UInt32)port
				  inputStream:(out NSInputStream **)inputStreamPtr
				 outputStream:(out NSOutputStream **)outputStreamPtr;

@end
