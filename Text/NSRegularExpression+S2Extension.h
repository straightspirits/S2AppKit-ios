//
//  NSRegularExpression+S2Extension.h
//  S2AppKit/S2TextKit
//
//  Created by Fumio Furukawa on 2012/11/16.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



@interface NSRegularExpression (S2Extensions)

- (BOOL)wholeMatchInString:(NSString *)string;
- (BOOL)wholeMatchInString:(NSString *)string options:(NSMatchingOptions)options;

- (NSTextCheckingResult *)firstMatchInString:(NSString *)string;
- (NSTextCheckingResult *)firstMatchInString:(NSString *)string options:(NSMatchingOptions)options;

@end



@interface NSTextCheckingResult (S2Extensions)

- (NSString*)string:(NSString*)string matchAtIndex:(int)index;

@end
