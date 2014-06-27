//
//  S2CardContinerViewController.h
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/15.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2CardEditorViewController.h"
#import "S2CardStack.h"



/*
 *	カードスタックコンテナー
 */
@interface S2CardContainerViewController : S2ViewController

- (NSInteger)addCardStack:(S2CardStack*)cardEditor;
//- (void)removeCardStack;
- (NSInteger)cardStackCount;
- (S2CardStack*)cardStackAtIndex:(int)index;

@property (readonly) S2CardStack* activeCardStack;
- (S2CardStack*)exchangeCardStack:(int)index;

@property (weak) S2CardEditorViewController* currentEditor;
- (BOOL)canChangeViewController;

@end
