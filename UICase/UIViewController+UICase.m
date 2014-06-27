//
//  UIViewController+UICase.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2UICase.h"



@implementation UIViewController (UICase)

- (S2UICase*)uicase;
{
	return [self associatedValueForKey:"uicase"];
}

- (void)setUicase:(S2UICase *)uicase;
{
	[self associateValue:uicase withKey:"uicase"];
}

- (NSString*)localizedStringForKey:(NSString*)key;
{
	return [self localizedStringForKey:key defaultValue:key];
}

- (NSString*)localizedStringForKey:(NSString*)key defaultValue:(NSString*)defaultValue;
{
	NSString* value;
	
	value = [self.uicase localizedStringForKey:[self.identifier stringByAppendingFormat:@".%@", key]];
	
	if (!value) {
		value = [self.uicase localizedStringForKey:key];
	}
	
	if (!value) {
		value = [S2UIKit localizedStringForKey:key defaultValue:defaultValue];
	}
	
	return value;
}

@end



