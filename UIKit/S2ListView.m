//
//  S2ListView.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/08/18.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2ListView.h"
#import "UIKit+S2AppKit.h"




@interface S2ListView ()

@property NSMutableArray* subviews;

@end

@implementation S2ListView

+ (id)newWithFrame:(CGRect)frame;
{
	return [[self alloc] initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame;
{
    if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_padding = 10;
		_subviews = [NSMutableArray new];
    }
    return self;
}

- (void)addView:(UIView *)view;
{
	S2AssertParameter(view);

	[_subviews addObject:view];
	
	[self addSubview:view];

//	[view sizeToFit];
	[self sizeToFit];
	[self setNeedsLayout];
}

- (void)sizeToFit;
{
	// 高さを再計算する

	CGFloat y = self.padding;

	for (UIView* view in self.subviews) {
		y += view.height + self.padding;
	}

	self.height = y;
}

- (void)layoutSubviews;
{
	[super layoutSubviews];
	
	CGFloat x = self.padding;
	CGFloat y = self.padding;
	CGFloat width = self.width - self.padding * 2;

	for (UIView* view in self.subviews) {
		CGFloat height = view.height;
		view.frame = CGRectMake(x, y, width, height);
		
		y += height + self.padding;
	}
}

@end
