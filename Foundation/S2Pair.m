//
//  S2Pair.m
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2013/01/05.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "S2Pair.h"



@implementation S2Pair

+ (id)new:(id)key value:(id)value;
{
	return [[self alloc] init:key value:value];
}

- (id)init:(id)key value:(id)value;
{
	if (self = [self init]) {
		self.key = key;
		self.value = value;
	}
	return self;
}

@end
