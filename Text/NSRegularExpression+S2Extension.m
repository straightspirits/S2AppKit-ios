//
//  NSRegularExpression+S2Extension.m
//  S2AppKit/S2TextKit
//
//  Created by Fumio Furukawa on 2012/11/16.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "NSRegularExpression+S2Extension.h"



@implementation NSRegularExpression (S2Extensions)

- (BOOL)wholeMatchInString:(NSString *)string;
{
	return [self wholeMatchInString:string options:0];
}

- (BOOL)wholeMatchInString:(NSString *)string options:(NSMatchingOptions)options;
{
	NSRange range = string.wholeRange;
	NSTextCheckingResult* result = [self firstMatchInString:string options:0 range:range];
	
	if (!result)
		return NO;
	
	return result.range.location == range.location && result.range.length == range.length;
}

- (NSTextCheckingResult *)firstMatchInString:(NSString *)string;
{
	return [self firstMatchInString:string options:0 range:string.wholeRange];
}

- (NSTextCheckingResult *)firstMatchInString:(NSString *)string options:(NSMatchingOptions)options;
{
	return [self firstMatchInString:string options:options range:string.wholeRange];
}

@end



@implementation NSTextCheckingResult (S2Extensions)

- (NSString*)string:(NSString*)string matchAtIndex:(int)index;
{
	return [string substringWithRange:[self rangeAtIndex:index]];
}

@end