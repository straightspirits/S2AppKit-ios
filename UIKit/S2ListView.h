//
//  S2ListView.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/08/18.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Foundation.h"
#import <UIKit/UIKit.h>



@interface S2ListView : UIView

@property CGFloat padding;

- (void)addView:(UIView*) view;

@end



@interface S2ListView (Creation)

+ (id)newWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame;

@end
