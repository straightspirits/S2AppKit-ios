//
//  S2CardPropertyEditorViewController.h
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/23.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2CardEditorViewController.h"



/*
 *	プロパティ編集のためのカードエディター
 *		移動・削除はしない。
 */
@interface S2CardPropertyEditorViewController : S2TableCardEditorViewController

// @require
- (NSArray*)tableSections;

@end
