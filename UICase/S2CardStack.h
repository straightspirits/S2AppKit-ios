//
//  S2CardStack.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/11/18.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2CardEditorViewController.h"




/*
 *	カードスタック
 *		・NavigationController
 *		・巻き戻し
 *		・指定エディタ挿入
 */
@interface S2CardStack : S2NavigationController

+ (id)new:(S2CardEditorViewController*)cardEditor;

- (void)rollBack;

- (void)push:(S2CardEditorViewController*)viewController animated:(BOOL)animated;

@end
