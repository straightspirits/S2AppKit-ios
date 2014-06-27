//
//  UIViewController+AppletWorld.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import <UIKit/UIKit.h>



@class S2UICase;



@interface UIViewController (UICase)

@property (weak) S2UICase* uicase;

- (NSString*)localizedStringForKey:(NSString*)key;
- (NSString*)localizedStringForKey:(NSString*)key defaultValue:(NSString*)value;

@end

