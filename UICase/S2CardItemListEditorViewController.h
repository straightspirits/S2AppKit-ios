//
//  S2CardEditorItemListWithPropertyViewController.h
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/20.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2CardEditorViewController.h"



/*
 *	セクション0: プロパティリスト
 *	セクション1: アイテムリスト
 */
@interface S2CardItemListEditorViewController : S2TableCardEditorViewController

@property (readonly) NSInteger itemListSection;

@property BOOL reloadItemSectionOnListEditing;

@property BOOL allowsAddRow;

- (NSIndexPath*)indexPathForItemListRow:(NSInteger)row;
- (NSIndexPath*)indexPathForAddRow;

// @required
- (NSMutableArray*)targetItemList;

// @optional
- (NSString*)itemSectionTitle;

// @optional
- (NSString*)itemSectionFooter;

// @optional
- (NSString*)messageForItemAddRow;

// @optional
- (NSInteger)propertyListCount;

// @optional
- (NSArray*)propertyListCells;

// @optional
- (void)propertySelected:(NSInteger)index;

// @required
- (UITableViewCell*)tableView:(UITableView *)tableView cellForItemSectionRow:(NSInteger)row;

// @optional
- (void)editItemAtIndex:(NSInteger)index;

// @optional
- (void)moveItemAt:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

// @optional
- (BOOL)canRemoveItemAtIndex:(NSInteger)index;
- (void)removeItemAtIndex:(NSInteger)index;

// @optional
- (void)itemSelected:(NSInteger)index;

// @optional
- (void)addNewItem;

- (int)commandCount;
- (NSString*)commandTitle:(NSInteger)row;
- (void)commandSelected:(NSInteger)row;

- (void)reloadPropertySection;
- (void)reloadItemListSection;

- (void)replaceItemRow:(NSInteger)row;
- (void)replaceItemRow:(NSInteger)row item:(id)item;
- (void)addItemRow;
- (void)addItemRow:(id)item;

@end
