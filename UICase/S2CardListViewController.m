//
//  S2CardViewController.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/08.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2CardListViewController.h"
#import "S2CardContainerViewController.h"



@implementation S2CardListViewController

- (S2CardContainerViewController*)cardContainer
{
	return self.splitViewController.viewControllers.lastObject;
}

- (void)reload;
{
	S2LogPass(nil, @"");
}

- (void)notifyUpdate:(NSString*)key
{
	S2LogPass(nil, @"key=%@", key);
}

@end
