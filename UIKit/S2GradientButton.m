//
//  S2GradientButton.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/08/17.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2GradientButton.h"
#import <QuartzCore/QuartzCore.h>



#define CORNER_RADIUS	9.0
#define PADDING_X		10.0



typedef enum {
    GradientButtonStateNormal = 0,
    GradientButtonStateHighlighted,
    GradientButtonStateDisabled
} GradientButtonState;



@interface HighlightEdgeLayer : CALayer
@end

@implementation HighlightEdgeLayer

- (void)drawInContext:(CGContextRef)context
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint p = CGPointMake(CORNER_RADIUS, CORNER_RADIUS);
	
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 CORNER_RADIUS,
                 2.0*M_PI/2.0,
                 3.0*M_PI/2.0,
                 false);
	
    p.x = self.bounds.size.width - CORNER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 CORNER_RADIUS,
                 3.0*M_PI/2.0,
                 4.0*M_PI/2.0,
                 false);
	
    CGContextAddPath(context, path);
    CGPathRelease(path);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1.0 alpha:0.5].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextDrawPath(context, kCGPathStroke);
}

@end



@interface S2GradientButton()

@property CAGradientLayer* gradientLayer;
@property CATextLayer* titleLayer;
@property HighlightEdgeLayer* highlightEdgeLayer;

@end

@implementation S2GradientButton

+ (id)new:(S2ButtonType)buttonType;
{
	return [[self alloc] init:buttonType withFrame:CGRectMake(0, 0, 0, 44)];
}

+ (id)new:(S2ButtonType)buttonType withFrame:(CGRect)frame;
{
	return [[self alloc] init:buttonType withFrame:frame];
}

- (id)init:(S2ButtonType)buttonType withFrame:(CGRect)frame;
{
    if (self = [super initWithFrame:frame]) {
		[self setButtonType:buttonType];
        [self _setup];
    }
    return self;
}

- (void)setButtonType:(S2ButtonType)buttonType;
{
	switch (buttonType) {
		case S2ButtonTypeNormal:
			self.titleColor = S2ColorBlack;
			self.backgroundColor = S2ButtonNormalColor;
			break;
		
		case S2ButtonTypeComplete:
			self.titleColor = S2ColorWhite;
			self.backgroundColor = S2ButtonStrongColor;
			break;

		case S2ButtonTypeAlert:
			self.titleColor = S2ColorWhite;
			self.backgroundColor = S2ButtonAlertColor;
			break;
		
		default:
			self.titleColor = S2ColorWhite;
			self.backgroundColor = S2ColorBlack;
			break;
	}
}

- (void)_setup
{
    // setup base layer
    self.layer.cornerRadius = CORNER_RADIUS;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.75].CGColor;
    self.layer.borderWidth = 1.0;
	
    // setup gradient layer
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.locations = @[
		[NSNumber numberWithFloat:0.0],
        [NSNumber numberWithFloat:0.5],
        [NSNumber numberWithFloat:0.5],
        [NSNumber numberWithFloat:1.0],
	];
	
    [self.layer addSublayer:self.gradientLayer];
	
    // setup title layer
    self.titleLayer = [CATextLayer layer];
    self.titleLayer.string = self.title;
    self.titleLayer.font = CGFontCreateWithFontName((__bridge CFStringRef)[self _font].fontName);
    self.titleLayer.fontSize = [self _font].pointSize;
    self.titleLayer.truncationMode = kCATruncationEnd;
    self.titleLayer.alignmentMode = kCAAlignmentCenter;
    self.titleLayer.shadowColor = [UIColor blackColor].CGColor;
    self.titleLayer.shadowRadius = 0.5;
    self.titleLayer.shadowOffset = CGSizeMake(-0.5, -0.5);
    self.titleLayer.shadowOpacity = 0.5;
    [self.layer addSublayer:self.titleLayer];

    // setup highlight edge
    self.highlightEdgeLayer = [HighlightEdgeLayer layer];
    self.highlightEdgeLayer.frame = CGRectInset(self.bounds, 0.5, 1.0);
    [self.layer addSublayer:self.highlightEdgeLayer];
    
    // set state
    [self _setState:GradientButtonStateNormal];
}

- (UIFont*)_font
{
    return [UIFont boldSystemFontOfSize:18.0];
}

- (void)_setState:(GradientButtonState)state
{
    switch (state) {
        case GradientButtonStateNormal:
            self.gradientLayer.colors = @[
				(id)[UIColor colorWithWhite:1.0 alpha:0.7].CGColor,
				(id)[UIColor colorWithWhite:1.0 alpha:0.4].CGColor,
				(id)[UIColor colorWithWhite:1.0 alpha:0.3].CGColor,
				(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
			];
            self.titleLayer.foregroundColor = self.titleColor.CGColor;
            break;
            
        case GradientButtonStateHighlighted:
            self.gradientLayer.colors = @[
				(id)[UIColor colorWithWhite:1.0 alpha:0.5].CGColor,
				(id)[UIColor colorWithWhite:1.0 alpha:0.2].CGColor,
				(id)[UIColor colorWithWhite:0.0 alpha:0.05].CGColor,
				(id)[UIColor colorWithWhite:0.0 alpha:0.1].CGColor,
			];
            self.titleLayer.foregroundColor = self.titleColor.CGColor;
            break;
            
        case GradientButtonStateDisabled:
            self.gradientLayer.colors = @[
				(id)[UIColor colorWithWhite:1.0 alpha:0.7].CGColor,
				(id)[UIColor colorWithWhite:1.0 alpha:0.4].CGColor,
				(id)[UIColor colorWithWhite:1.0 alpha:0.3].CGColor,
				(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
			];
            self.titleLayer.foregroundColor = [UIColor lightGrayColor].CGColor;
            break;
    }
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	[self layoutTitleLayer];
}

- (void)layoutTitleLayer
{
    CGSize wholeSize = self.frame.size;
    CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName: [self _font]}];
    self.titleLayer.frame = CGRectMake(
		PADDING_X,
		(wholeSize.height - titleSize.height) / 2,
		wholeSize.width - PADDING_X * 2,
		titleSize.height
	);
}

#pragma mark - Properties

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLayer.string = title;

	[self layoutTitleLayer];
}

- (void)setTitleColor:(UIColor *)titleColor
{
	_titleColor = titleColor;
	
	self.titleLayer.foregroundColor = titleColor.CGColor;
}

#pragma mark - UIControl

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];

	self.gradientLayer.frame = self.bounds;
	self.highlightEdgeLayer.frame = self.bounds;

	[self setNeedsLayout];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self _setState:enabled ? GradientButtonStateNormal : GradientButtonStateDisabled];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self _setState:highlighted ? GradientButtonStateHighlighted : GradientButtonStateNormal];
}

@end
