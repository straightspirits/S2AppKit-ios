//
//  S2SplitViewController.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/08/22.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Foundation.h"
#import "S2ViewController.h"



@interface S2SplitViewController : UISplitViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate>

+ (id)new :(UIViewController*)masterViewController :(UIViewController*)detailViewController;
- (id)init :(UIViewController*)masterViewController :(UIViewController*)detailViewController;

@property (readonly) UIPopoverController* masterPopoverController;

@end



@interface UISplitViewController (S2AppKit)

@property (readonly) UIPopoverController* masterPopoverController;
@property (readonly) UIViewController* masterContentViewController;
@property (readonly) UIViewController* detailContentViewController;

@end
