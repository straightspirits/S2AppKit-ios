//
//  S2Label.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2014/09/11.
//  Copyright (C) 2014 Straight Spirits Co. Ltd. All rights reserved.
//

#import "S2Label.h"



@interface S2Label ()

@end

@implementation S2Label

- (void)awakeFromNib;
{
	[super awakeFromNib];
	self.textVerticalAlignment = S2TextVerticalAlignmentMiddle;
}

/* override */
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines;
{
	CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];

	switch (self.textVerticalAlignment) {
		case S2TextVerticalAlignmentTop:
			textRect.origin.y = bounds.origin.y;
			break;
		case S2TextVerticalAlignmentBottom:
			textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
			break;
		case S2TextVerticalAlignmentMiddle:
		default:
			// 中央揃え
			textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
	}
	return textRect;
}

/* override */
- (void)drawTextInRect:(CGRect)requestedRect;
{
	CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];

	[super drawTextInRect:actualRect];
}

@end
