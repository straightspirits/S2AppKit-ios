//
//  S2Button.h
//  S2AppKit/S2UIKit
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIKit+S2AppKit.h"



@interface S2Button : UIButton {
    // These two arrays define the gradient that will be used
    // when the button is in UIControlStateNormal
    NSArray  *_normalGradientColors;     // Colors
    NSArray  *_normalGradientLocations;  // Relative locations
    
    // These two arrays define the gradient that will be used
    // when the button is in UIControlStateHighlighted 
    NSArray  *_highlightGradientColors;     // Colors
    NSArray  *_highlightGradientLocations;  // Relative locations
    
    // This defines the corner radius of the button
    CGFloat         _cornerRadius;
    
    // This defines the size and color of the stroke
    CGFloat         _strokeWeight;
    UIColor         *_strokeColor;
    
@private
    CGGradientRef   _normalGradient;
    CGGradientRef   _highlightGradient;
}

@property NSArray *normalGradientColors;
@property NSArray *normalGradientLocations;
@property NSArray *highlightGradientColors;
@property NSArray *highlightGradientLocations;
@property CGFloat cornerRadius;
@property CGFloat strokeWeight;
@property UIColor *strokeColor;

- (void)useAlertStyle;
- (void)useRedDeleteStyle;
- (void)useWhiteStyle;
- (void)useBlackStyle;
- (void)useWhiteActionSheetStyle;
- (void)useBlackActionSheetStyle;
- (void)useSimpleOrangeStyle;
- (void)useGreenConfirmStyle;

@end
