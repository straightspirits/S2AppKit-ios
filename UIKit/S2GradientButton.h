//
//  S2GradientButton.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/08/17.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "S2Colors.h"



#define S2ButtonNormalColor		S2WhiteColor(75)
#define S2ButtonAlertColor		S2ColorRed
#define S2ButtonStrongColor		S2ColorBlue



typedef enum {
	S2ButtonTypeNormal,
	S2ButtonTypeComplete,
	S2ButtonTypeAlert,
} S2ButtonType;

@interface S2GradientButton : UIControl

+ (id)new:(S2ButtonType)buttonType;
+ (id)new:(S2ButtonType)buttonType withFrame:(CGRect)frame;
- (id)init:(S2ButtonType)buttonType withFrame:(CGRect)frame;

@property (nonatomic) NSString* title;
@property (nonatomic) UIColor* titleColor;

@end
