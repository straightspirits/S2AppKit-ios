//
//  S2CardEditorItemListWithPropertyViewController.m
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/20.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2CardItemListEditorViewController.h"



@implementation S2CardItemListEditorViewController

- (void)initializeInstance
{
	[super initializeInstance];
	
	self.reloadItemSectionOnListEditing = NO;
	self.allowsAddRow = NO;
}

- (BOOL)hasPropertyList
{
	return self.propertyListCount > 0;
}

- (NSInteger)itemListSection
{
	return [self hasPropertyList] ? 1 : 0;
}

- (NSIndexPath*)indexPathForItemListRow:(NSInteger)row
{
	return [NSIndexPath indexPathForRow:row inSection:self.itemListSection];
}

- (NSIndexPath*)indexPathForAddRow;
{
	if (self.allowsAddRow) {
		return S2IndexPath(self.itemListSection + 1, 0);
	}
	else {
		return nil;
	}
}

#pragma mark -

- (NSMutableArray*)targetItemList
{
	// need override
	return nil;
}

- (NSString*)itemSectionTitle
{
	return [self localizedStringForKey:@"itemList.title" defaultValue:nil];
}

- (NSString*)itemSectionFooter
{
	NSString* footer1 = [self localizedStringForKey:@"itemList.footer@1" defaultValue:nil];
	return footer1 ? S2StringFormat(footer1, self.targetItemList.count) : nil;
}

- (NSString*)messageForItemAddRow
{
	return [self localizedStringForKey:@"itemList.rowAddMessage" defaultValue:@"Add row..."];
}

- (NSInteger)propertyListCount
{
	return self.propertyListCells.count;
}

- (NSArray*)propertyListCells
{
	return nil;
}

- (void)propertySelected:(NSInteger)index
{
	S2TableViewRow* row = self.propertyListCells[index];
	
	[row didSelected:self.editing];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForItemSectionRow:(NSInteger)row
{
	// need override
//	NSAssert(NO, "failed!");
	return nil;
}

- (void)editItemAtIndex:(NSInteger)index
{
	// optional override
}

- (void)moveItemAt:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
	id object = [self.targetItemList objectAtIndex:fromIndex];

	[self.targetItemList removeObjectAtIndex:fromIndex];

	[self.targetItemList insertObject:object atIndex:toIndex];
}

- (BOOL)canRemoveItemAtIndex:(NSInteger)index;
{
	return YES;
}

- (void)removeItemAtIndex:(NSInteger)index;
{
	[self.targetItemList removeObjectAtIndex:index];
}

- (void)itemSelected:(NSInteger)index;
{
	// optional override
}

- (void)addNewItem
{
	// need override
}

#pragma mark - View editing

- (void)editingChanged:(BOOL)animated;
{
	if (!self.editing && self.listEditing) {
		// リスト編集を強制終了する
		[self setListEditing:NO animated:NO];
	}
	else {
		if (self.allowsAddRow) {
			// 編集状態の変化に伴うテーブルビューの行操作を行う
			if (!self.editing) {
				[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.itemListSection + 1] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
			else {
				[self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.itemListSection + 1] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
		}

		// プロパティリストをreloadし、セルを切り替える
		[self reloadPropertySection];
		
		// アイテムリストをreloadし、セルを切り替える
		[self reloadItemListSection];
	}
}

// リスト編集開始時
- (void)didBeginListEditing
{
	[super didBeginListEditing];

	// 追加セクションを削除する
	[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:self.itemListSection + 1] withRowAnimation:UITableViewRowAnimationAutomatic];
	
	if (self.reloadItemSectionOnListEditing) {
		[self reloadItemListSection];
	}
}

// リスト編集終了時
- (void)didEndListEditing
{
	[super didEndListEditing];
	
	// 追加セクションを追加する
	// self.editing == NO の場合は、setEditing:animated: で削除する。
	if (self.editing) {
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.itemListSection + 1] withRowAnimation:UITableViewRowAnimationAutomatic];
	}

	if (self.reloadItemSectionOnListEditing) {
		[self reloadItemListSection];
	}
}

#pragma mark - Table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	int sectionCount = 1;
	
	if (self.hasPropertyList) {
		++sectionCount;
	}
	
	if (self.allowsAddRow && self.editing && !self.tableView.editing) {
		++sectionCount;
	}
	
    return sectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (!self.hasPropertyList)
		++section;
	
	switch (section) {
		case 0:
			return nil;
			
		case 1:
			return [self itemSectionTitle];
			
		default:
			return nil;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if (!self.hasPropertyList)
		++section;
	
	switch (section) {
		case 0:
			return nil;

		case 1:
			return [self itemSectionFooter];
			
		default:
			return nil;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (!self.hasPropertyList)
		++section;
	
	switch (section) {
		case 0:
			return self.propertyListCount;
			
		case 1:
			return self.targetItemList.count;
			
		case 2:
			return self.commandCount;
			
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger section = indexPath.section;
	if (!self.hasPropertyList)
		++section;
	
	switch (section) {
		case 0:
			{
				S2TableViewRow* row = self.propertyListCells[indexPath.row];
				row.indexPath = indexPath;
				return [row chooseCell:self.editing];
			}
			
		case 1:
			return [self tableView:tableView cellForItemSectionRow:indexPath.row];

		case 2:
			{
				S2TableViewRowAddCell* cell = [S2TableViewRowAddCell instantiateCell:tableView];
				cell.messageLabel.text = [self commandTitle:indexPath.row];
				return cell;
			}

		default:
			return nil;
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger section = indexPath.section;
	if (!self.hasPropertyList)
		++section;
	
	// アイテムリストだけ編集可能
	switch (section) {
		case 0:
			return NO;
			
		case 1:
			return YES;
			
		case 2:
			return NO;
			
		default:
			return NO;
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == self.itemListSection) {
		if ([self canRemoveItemAtIndex:indexPath.row]) {
			[self deleteItemRow:indexPath.row];
		}
	}
	else if (indexPath.section == self.itemListSection + 1) {
		// add item
		[self addNewItem];
	}
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == self.itemListSection && indexPath.row != self.targetItemList.count;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	[self moveItemAt:fromIndexPath.row toIndex:toIndexPath.row];
	[self setModified];
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// MEMO !self.editingの時、スワイプによる削除ボタン表示機能を無効化する
	return self.tableView.editing && [self canRemoveItemAtIndex:indexPath.row] ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	if (sourceIndexPath.section == self.itemListSection) {
		if (proposedDestinationIndexPath.section != sourceIndexPath.section) {
			return sourceIndexPath;
		}
	}

	return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger section = indexPath.section;
	if (!self.hasPropertyList)
		++section;
	
	switch (section) {
		case 0:
			[self propertySelected:indexPath.row];
			break;

		case 1:
			if (self.tableView.editing) {
				[self editItemAtIndex:indexPath.row];
			}
			else {
				// select item
				[self itemSelected:indexPath.row];
			}
			break;

		case 2:
			[self commandSelected:indexPath.row];
			break;
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark -

- (int)commandCount;
{
	return 1;
}

- (NSString*)commandTitle:(NSInteger)row;
{
	return self.messageForItemAddRow;
}

- (void)commandSelected:(NSInteger)row;
{
	// add item
	[self addNewItem];
}

- (void)reloadPropertySection
{
	if (self.hasPropertyList) {
		// MEMO: アニメーションをONにすると、Cellの入れ替えがあるためちらついた
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
	}
}

- (void)reloadItemListSection
{
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.itemListSection] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadItemListFooter
{
	// フッターのみのreloadはないようなので、セクション全体を対象にする
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.itemListSection] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)replaceItemRow:(NSInteger)row
{
	NSIndexPath* indexPath = [self indexPathForItemListRow:row];
	[self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)replaceItemRow:(NSInteger)row item:(id)item
{
	[self.targetItemList replaceObjectAtIndex:row withObject:item];
	[self setModified];
	
	NSIndexPath* indexPath = [self indexPathForItemListRow:row];
	[self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addItemRow
{
	// テーブル行を追加する
	NSIndexPath* indexPath = [self indexPathForItemListRow:self.targetItemList.count - 1];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	// フッターを更新する
	[self reloadItemListFooter];
}

- (void)addItemRow:(id)item
{
	[self.targetItemList addObject:item];
	[self setModified];

	// テーブル行を追加する
	NSIndexPath* indexPath = [self indexPathForItemListRow:self.targetItemList.count - 1];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	// フッターを更新する
	[self reloadItemListFooter];
}

- (void)deleteItemRow:(NSInteger)row;
{
	// remove item
	[self removeItemAtIndex:row];
	[self setModified];

	// テーブル行を削除する
	NSIndexPath* indexPath = [self indexPathForItemListRow:row];
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

	// フッターを更新する
	[self reloadItemListFooter];
}

@end
