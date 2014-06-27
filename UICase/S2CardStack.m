//
//  S2CardStack.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/11/18.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2CardStack.h"



@implementation S2CardStack

+ (id)new:(S2CardEditorViewController*)cardEditor;
{
	return [[self alloc] initWithRootViewController:cardEditor];
}

- (void)rollBack;
{
	[self popToRootViewControllerAnimated:NO];
}

- (void)push:(S2CardEditorViewController*)viewController animated:(BOOL)animated;
{
	[self pushViewController:viewController animated:animated];
}

@end
