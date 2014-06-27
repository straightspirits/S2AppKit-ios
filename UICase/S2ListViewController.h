//
//  S2ListViewController.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/27.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2ViewController.h"



/*
 *	複数アイテムから一つまたは複数選択するビュー
 */
@interface S2ListViewController : S2ViewController

// 複数選択を許可するか
@property BOOL allowMultiSelection;

// 選択対象項目
@property NSArray* targetItems;

// アイテムを文字列化するクロージャ
@property NSString* (^stringer)(id item);

// 選択インデックスのセット
@property NSMutableIndexSet* selectedIndexes;

// 選択完了時に呼ばれるクロージャ
@property void (^selectionChanged)(NSArray* selectedItems);

@end
