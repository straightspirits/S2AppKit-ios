//
//  S2PopoverNavigationViewController.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/13.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2ViewControllers.h"



/*
 *	ナビゲーションバー付きPopoverビューコントローラー
 */
@interface S2PopoverNavigationViewController : S2ViewController

+ (id)new_uicase:(S2UICase*)uicase size:(CGSize)size;

@property (readonly) UINavigationBar* navigationBar;

@property (readonly) S2ContextToolbar* contextToolbar;

// override point
@property (readonly) UIView* contentView;

@end
