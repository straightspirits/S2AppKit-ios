//
//  S2CardListViewController.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/08.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2ViewControllers.h"
#import "S2CardContainerViewController.h"



/*
 *	カードリストビュー
 */
@interface S2CardListViewController : S2ViewController

- (S2CardContainerViewController*)cardContainer;

- (void)reload;

- (void)notifyUpdate:(NSString*)key;

@end
