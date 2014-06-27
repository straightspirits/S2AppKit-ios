//
//  S2Button.m
//  S2AppKit/S2UIKit
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 MyCompanyName. All rights reserved.
//

#import "S2Button.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>



@interface S2Button()

@property (readonly) CGGradientRef normalGradient;
@property (readonly) CGGradientRef highlightGradient;

@end

#pragma mark -

@implementation S2Button

+ (id)new;
{
	return [self buttonWithType:UIButtonTypeCustom];
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self setOpaque:NO];
        self.backgroundColor = [UIColor clearColor];
		self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		self.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
	}
	return self;
}

#pragma mark -

- (CGGradientRef)normalGradient
{
    if (_normalGradient == NULL)
    {
        NSInteger locCount = [_normalGradientLocations count];
        CGFloat locations[locCount];
        for (NSInteger i = 0; i < locCount; i++)
        {
            NSNumber *location = [_normalGradientLocations objectAtIndex:i];
            locations[i] = [location floatValue];
        }
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        
        _normalGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)_normalGradientColors, locations);
        CGColorSpaceRelease(space);
    }
    return _normalGradient;
}

- (CGGradientRef)highlightGradient
{
    if (_highlightGradient == NULL)
    {
        CGFloat locations[[_highlightGradientLocations count]];
        for (int i = 0; i < [_highlightGradientLocations count]; i++)
        {
            NSNumber *location = [_highlightGradientLocations objectAtIndex:i];
            locations[i] = [location floatValue];
        }
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        
        _highlightGradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)_highlightGradientColors, locations);
        CGColorSpaceRelease(space);
    }
    return _highlightGradient;
}
#pragma mark -
#pragma mark Appearances
- (void)useAlertStyle
{
    // Oddly enough, if I create the color array using arrayWithObjects:, it
    // doesn't work - the gradient comes back NULL
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
    UIColor *color = [UIColor colorWithRed:0.283 green:0.32 blue:0.414 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.82 green:0.834 blue:0.87 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.186 green:0.223 blue:0.326 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    self.normalGradientColors = colors;
    self.normalGradientLocations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:1.0f],
                                    [NSNumber numberWithFloat:0.483f],
                                    nil];
    
    NSMutableArray *colors2 = [NSMutableArray arrayWithCapacity:4];
    color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.656 green:0.683 blue:0.713 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.137 green:0.155 blue:0.208 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.237 green:0.257 blue:0.305 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    self.highlightGradientColors = colors2;
    self.highlightGradientLocations = [NSArray arrayWithObjects:
                                       [NSNumber numberWithFloat:0.0f],
                                       [NSNumber numberWithFloat:1.0f],
                                       [NSNumber numberWithFloat:0.51f],
                                       [NSNumber numberWithFloat:0.654f],
                                       nil];
    self.cornerRadius = 7.0f;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
}
- (void)useRedDeleteStyle
{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:5];
    UIColor *color = [UIColor colorWithRed:0.667 green:0.15 blue:0.152 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.841 green:0.566 blue:0.566 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.75 green:0.341 blue:0.345 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.592 green:0.0 blue:0.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.592 green:0.0 blue:0.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    self.normalGradientColors = colors;
    self.normalGradientLocations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:1.0f],
                                    [NSNumber numberWithFloat:0.582f],
                                    [NSNumber numberWithFloat:0.418f],
                                    [NSNumber numberWithFloat:0.346],
                                    nil];
    
    NSMutableArray *colors2 = [NSMutableArray arrayWithCapacity:5];
    color = [UIColor colorWithRed:0.467 green:0.009 blue:0.005 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.754 green:0.562 blue:0.562 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.543 green:0.212 blue:0.212 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.5 green:0.153 blue:0.152 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.388 green:0.004 blue:0.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    
    self.highlightGradientColors = colors;
    self.highlightGradientLocations = [NSArray arrayWithObjects:
                                       [NSNumber numberWithFloat:0.0f],
                                       [NSNumber numberWithFloat:1.0f],
                                       [NSNumber numberWithFloat:0.715f],
                                       [NSNumber numberWithFloat:0.513f],
                                       [NSNumber numberWithFloat:0.445f],
                                       nil];
    self.cornerRadius = 9.f;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
- (void)useWhiteStyle
{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
	UIColor *color = [UIColor colorWithRed:0.864 green:0.864 blue:0.864 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.995 green:0.995 blue:0.995 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.956 green:0.956 blue:0.955 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
    self.normalGradientColors = colors;
    self.normalGradientLocations = [NSMutableArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:1.0f],
                                    [NSNumber numberWithFloat:0.601f],
                                    nil];
    
    NSMutableArray *colors2 = [NSMutableArray arrayWithCapacity:3];
	color = [UIColor colorWithRed:0.692 green:0.692 blue:0.691 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.995 green:0.995 blue:0.995 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
    self.highlightGradientColors = colors2;
    self.highlightGradientLocations = [NSMutableArray arrayWithObjects:
                                       [NSNumber numberWithFloat:0.0f],
                                       [NSNumber numberWithFloat:1.0f],
                                       [NSNumber numberWithFloat:0.601f],
                                       nil];
    
    self.cornerRadius = 9.f;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
}
- (void)useBlackStyle
{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:4];
	UIColor *color = [UIColor colorWithRed:0.154 green:0.154 blue:0.154 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.307 green:0.307 blue:0.307 alpha:1.0];
	[colors addObject:(id)[color CGColor]];;
	color = [UIColor colorWithRed:0.166 green:0.166 blue:0.166 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.118 green:0.118 blue:0.118 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
    self.normalGradientColors = colors;
    self.normalGradientLocations = [NSMutableArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:1.0f],
                                    [NSNumber numberWithFloat:0.548f],
                                    [NSNumber numberWithFloat:0.462f],
                                    nil];
    self.cornerRadius = 9.0f;
    
    NSMutableArray *colors2 = [NSMutableArray arrayWithCapacity:4];
	color = [UIColor colorWithRed:0.199 green:0.199 blue:0.199 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.04 green:0.04 blue:0.04 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.074 green:0.074 blue:0.074 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.112 green:0.112 blue:0.112 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
    
    self.highlightGradientColors = colors2;
    self.highlightGradientLocations = [NSMutableArray arrayWithObjects:
                                       [NSNumber numberWithFloat:0.0f],
                                       [NSNumber numberWithFloat:1.0f],
                                       [NSNumber numberWithFloat:0.548f],
                                       [NSNumber numberWithFloat:0.462f],
                                       nil];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)useWhiteActionSheetStyle
{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
	UIColor *color = [UIColor colorWithRed:0.864 green:0.864 blue:0.864 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.995 green:0.995 blue:0.995 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.956 green:0.956 blue:0.955 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
    self.normalGradientColors = colors;
    self.normalGradientLocations = [NSMutableArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:1.0f],
                                    [NSNumber numberWithFloat:0.601f],
                                    nil];
    
	NSMutableArray *colors2 = [NSMutableArray arrayWithCapacity:7];
	color = [UIColor colorWithRed:0.033 green:0.251 blue:0.673 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.66 green:0.701 blue:0.88 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.222 green:0.308 blue:0.709 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.145 green:0.231 blue:0.683 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.0 green:0.124 blue:0.621 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.011 green:0.181 blue:0.647 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.311 green:0.383 blue:0.748 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
    self.highlightGradientColors = colors2;
    self.highlightGradientLocations = [NSMutableArray arrayWithObjects:
                                       [NSNumber numberWithFloat:0.0f],
                                       [NSNumber numberWithFloat:1.0f],
                                       [NSNumber numberWithFloat:0.957f],
                                       [NSNumber numberWithFloat:0.574f],
                                       [NSNumber numberWithFloat:0.541],
                                       [NSNumber numberWithFloat:0.185f],
                                       [NSNumber numberWithFloat:0.812f],
                                       nil];
    
    self.cornerRadius = 9.f;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}
- (void)useBlackActionSheetStyle
{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:4];
	UIColor *color = [UIColor colorWithRed:0.154 green:0.154 blue:0.154 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.307 green:0.307 blue:0.307 alpha:1.0];
	[colors addObject:(id)[color CGColor]];;
	color = [UIColor colorWithRed:0.166 green:0.166 blue:0.166 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.118 green:0.118 blue:0.118 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
    self.normalGradientColors = colors;
    self.normalGradientLocations = [NSMutableArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:1.0f],
                                    [NSNumber numberWithFloat:0.548f],
                                    [NSNumber numberWithFloat:0.462f],
                                    nil];
    self.cornerRadius = 9.0f;
    
	NSMutableArray *colors2 = [NSMutableArray arrayWithCapacity:7];
	color = [UIColor colorWithRed:0.033 green:0.251 blue:0.673 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.66 green:0.701 blue:0.88 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.222 green:0.308 blue:0.709 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.145 green:0.231 blue:0.683 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.0 green:0.124 blue:0.621 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.011 green:0.181 blue:0.647 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.311 green:0.383 blue:0.748 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
    self.highlightGradientColors = colors2;
    self.highlightGradientLocations = [NSMutableArray arrayWithObjects:
                                       [NSNumber numberWithFloat:0.0f],
                                       [NSNumber numberWithFloat:1.0f],
                                       [NSNumber numberWithFloat:0.957f],
                                       [NSNumber numberWithFloat:0.574f],
                                       [NSNumber numberWithFloat:0.541],
                                       [NSNumber numberWithFloat:0.185],
                                       [NSNumber numberWithFloat:0.812f],
                                       nil];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}
- (void)useSimpleOrangeStyle
{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:2];
	UIColor *color = [UIColor colorWithRed:0.935 green:0.403 blue:0.02 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.97 green:0.582 blue:0.0 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
    self.normalGradientColors = colors;
    self.normalGradientLocations = [NSMutableArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:1.0f],
                                    nil];
    
    NSMutableArray *colors2 = [NSMutableArray arrayWithCapacity:3];
	color = [UIColor colorWithRed:0.914 green:0.309 blue:0.0 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.935 green:0.4 blue:0.0 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
	color = [UIColor colorWithRed:0.946 green:0.441 blue:0.01 alpha:1.0];
	[colors2 addObject:(id)[color CGColor]];
    self.highlightGradientColors = colors2;
    self.highlightGradientLocations = [NSMutableArray arrayWithObjects:
                                       [NSNumber numberWithFloat:0.0f],
                                       [NSNumber numberWithFloat:1.0f],
                                       [NSNumber numberWithFloat:0.498f],
                                       nil];
    
    self.cornerRadius = 9.f;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (void)useGreenConfirmStyle
{
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:5];
    UIColor *color = [UIColor colorWithRed:0.15 green:0.667 blue:0.152 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.566 green:0.841 blue:0.566 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.341 green:0.75 blue:0.345 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.0 green:0.592 blue:0.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.0 green:0.592 blue:0.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    self.normalGradientColors = colors;
    self.normalGradientLocations = [NSMutableArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:1.0f],
                                    [NSNumber numberWithFloat:0.582f],
                                    [NSNumber numberWithFloat:0.418f],
                                    [NSNumber numberWithFloat:0.346],
                                    nil];
    
    NSMutableArray *colors2 = [NSMutableArray arrayWithCapacity:5];
    color = [UIColor colorWithRed:0.009 green:0.467 blue:0.005 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.562 green:0.754 blue:0.562 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.212 green:0.543 blue:0.212 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.153 green:0.5 blue:0.152 alpha:1.0];
    [colors2 addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.004 green:0.388 blue:0.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
	
    self.highlightGradientColors = colors;
    self.highlightGradientLocations = [NSMutableArray arrayWithObjects:
                                       [NSNumber numberWithFloat:0.0f],
                                       [NSNumber numberWithFloat:1.0f],
                                       [NSNumber numberWithFloat:0.715f],
                                       [NSNumber numberWithFloat:0.513f],
                                       [NSNumber numberWithFloat:0.445f],
                                       nil];
    self.cornerRadius = 9.f;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
#pragma mark -
- (void)drawRect:(CGRect)rect 
{
    self.backgroundColor = [UIColor clearColor];
	CGRect imageBounds = CGRectMake(0.0, 0.0, self.bounds.size.width - 0.5, self.bounds.size.height);
    
    
	CGGradientRef gradient;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint point2;
    
	CGFloat resolution = 0.5 * (self.bounds.size.width / imageBounds.size.width + self.bounds.size.height / imageBounds.size.height);
	
	CGFloat stroke = self.strokeWeight * resolution;
	if (stroke < 1.0)
		stroke = ceil(stroke);
	else
		stroke = round(stroke);
	stroke /= resolution;
	CGFloat alignStroke = fmod(0.5 * stroke * resolution, 1.0);
	CGMutablePathRef path = CGPathCreateMutable();
	CGPoint point = CGPointMake((self.bounds.size.width - [self cornerRadius]), self.bounds.size.height - 0.5f);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(self.bounds.size.width - 0.5f, (self.bounds.size.height - [self cornerRadius]));
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPoint controlPoint1 = CGPointMake((self.bounds.size.width - ([self cornerRadius] / 2.f)), self.bounds.size.height - 0.5f);
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	CGPoint controlPoint2 = CGPointMake(self.bounds.size.width - 0.5f, (self.bounds.size.height - ([self cornerRadius] / 2.f)));
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(self.bounds.size.width - 0.5f, [self cornerRadius]);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake((self.bounds.size.width - [self cornerRadius]), 0.0);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(self.bounds.size.width - 0.5f, ([self cornerRadius] / 2.f));
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint2 = CGPointMake((self.bounds.size.width - ([self cornerRadius] / 2.f)), 0.0);
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake([self cornerRadius], 0.0);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(0.0, [self cornerRadius]);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(([self cornerRadius] / 2.f), 0.0);
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint2 = CGPointMake(0.0, ([self cornerRadius] / 2.f));
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(0.0, (self.bounds.size.height - [self cornerRadius]));
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake([self cornerRadius], self.bounds.size.height - 0.5f);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(0.0, (self.bounds.size.height - ([self cornerRadius] / 2.f)));
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint2 = CGPointMake(([self cornerRadius] / 2.f), self.bounds.size.height - 0.5f);
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake((self.bounds.size.width - [self cornerRadius]), self.bounds.size.height - 0.5f);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	CGPathCloseSubpath(path);
    if (self.state == UIControlStateHighlighted)
        gradient = self.highlightGradient;
    else
        gradient = self.normalGradient;
    
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
	point = CGPointMake((self.bounds.size.width / 2.0), self.bounds.size.height - 0.5f);
	point2 = CGPointMake((self.bounds.size.width / 2.0), 0.0);
	CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	CGContextRestoreGState(context);
	[self.strokeColor setStroke];
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
    
}
#pragma mark -
#pragma mark Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setNeedsDisplay];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.15];
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.15];
    [super touchesEnded:touches withEvent:event];
}

// Used to catch and fix problem where quick taps don't get updated back to normal state
- (void)hesitateUpdate
{
    [self setNeedsDisplay];
}

#pragma mark -

- (void)dealloc
{
    if (_normalGradient != NULL)
        CGGradientRelease(_normalGradient);
    if (_highlightGradient != NULL)
        CGGradientRelease(_highlightGradient);
}

@end
