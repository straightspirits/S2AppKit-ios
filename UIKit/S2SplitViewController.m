//
//  S2SplitViewController.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/08/22.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2SplitViewController.h"



static inline UIViewController* contentViewController(id controller)
{
	return [controller isKindOfClass:UINavigationController.class] ? [controller topViewController] : controller;
}



@implementation S2SplitViewController {
	UIPopoverController* _masterPopoverController;
}

+ (id)new :(UIViewController*)masterViewController :(UIViewController*)detailViewController;
{
	return [[self alloc] init :masterViewController :detailViewController];
}

- (id)init :(UIViewController*)masterViewController :(UIViewController*)detailViewController;
{
	S2AssertParameter(masterViewController);
	S2AssertParameter(detailViewController);
	
	if (self = [self init]) {
		[self initializeInstance];

		self.viewControllers = @[masterViewController, detailViewController];

		self.delegate = self;
	}

	return self;
}

- (UIPopoverController *)masterPopoverController;
{
	return _masterPopoverController;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;
{
	UINavigationController* detailViewController = [self.viewControllers objectAtIndex:1];
	
	if (S2ObjectIsKindOf(detailViewController, UINavigationController.class)) {
		for (UIViewController* viewController in detailViewController.viewControllers) {
			viewController.navigationItem.leftBarButtonItem = nil;
		}
	}
	
	_masterPopoverController = nil;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc;
{
	UINavigationController* detailViewController = [self.viewControllers objectAtIndex:1];

	if (S2ObjectIsKindOf(detailViewController, UINavigationController.class)) {
		for (UIViewController* viewController in detailViewController.viewControllers) {
			viewController.navigationItem.leftBarButtonItem = barButtonItem;
		}
	}
	
	_masterPopoverController = pc;
}

@end



@implementation UISplitViewController (S2AppKit)

- (UIPopoverController *)masterPopoverController;
{
	return nil;
}

- (UIViewController *)masterContentViewController;
{
	return contentViewController(self.viewControllers[0]);
}

- (UIViewController *)detailContentViewController;
{
	return contentViewController(self.viewControllers[1]);
}

@end