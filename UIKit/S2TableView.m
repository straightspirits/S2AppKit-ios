//
//  S2TableView.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/11/19.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2TableView.h"
#import "S2TableViewCellCollection.h"



// プライベートインターフェースの定義
@interface S2TableViewAdapter ()

@property (weak) UITableView* tableView;

@end



// プライベートインターフェースの定義
@interface S2TableViewSection ()

@property (weak) S2TableViewAdapter* adapter;

@end



// プライベートインターフェースの定義
@interface S2TableViewRow ()

@property (weak) S2TableViewSection* section;

@end



@implementation UITableView (CellSetSupport)

- (S2TableViewCellState)cellState;
{
	return [[self associatedValueForKey:"cellState"] intValue];
}

- (void)setCellState:(S2TableViewCellState)cellState;
{
	[self associateValue:@(cellState) withKey:"cellState"];
}

- (void)attach:(S2TableViewAdapter *)adapter;
{
	self.dataSource = adapter;
	self.delegate = adapter;
	
	adapter.tableView = self;
}

@end


// インターフェースの実装
@implementation S2TableView

+ (id)newPlainStyle:(BOOL)showUnlimitedSeparator;
{
	S2TableView* instance = [[self alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	
	if (!showUnlimitedSeparator)
		instance.tableFooterView = UIView.blankView;
	instance.backgroundColor = S2TableViewDefaultBackground;
	instance.separatorColor = S2WhiteColor(75);
	
	return instance;
}

+ (id)newGroupedStyle
{
	S2TableView* instance = [[self alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	
	return instance;
}

- (void)awakeFromNib;
{
	[super awakeFromNib];

	if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
		self.layoutMargins = self.separatorInset;
	}
}

/* override */
- (void)setSeparatorInset:(UIEdgeInsets)separatorInset;
{
	[super setSeparatorInset:separatorInset];
	
	if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
		self.layoutMargins = separatorInset;
	}
}

@end



@implementation S2TableViewAdapter {
	NSMutableArray* _sections;
}

+ (id)new;
{
	return [[self alloc] init];
}

- (id)init;
{
	if (self = [super init]) {
		_sections = [NSMutableArray new];
	}
	return self;
}

- (void)addSection:(S2TableViewSection*)section;
{
	section.adapter = self;
	
	[_sections addObject:section];
}

- (void)addSections:(NSArray*)sections;
{
	for (S2TableViewSection* section in sections) {
		section.adapter = self;
	
		[_sections addObject:section];
	}
}

- (void)clearSections;
{
	_sections = [NSMutableArray new];
}

- (NSArray *)sections;
{
	return _sections;
}

- (NSArray *)visibleSections;
{
	NSMutableArray* array = [NSMutableArray new];
	for (S2TableViewSection* section in _sections) {
		if (section.visible)
			[array addObject:section];
	}
	return array;
}

- (NSUInteger)indexOfSection:(S2TableViewSection*)section;
{
	return [self.visibleSections indexOfObject:section];
}

- (void)reloadSection:(S2TableViewSection*)section withRowAnimation:(UITableViewRowAnimation)animation;
{
	NSInteger sectionIndex = [self indexOfSection:section];
	[_tableView reloadSection:sectionIndex withRowAnimation:animation];
}

- (void)reloadHeader:(S2TableViewSection*)section;
{
	[self reloadSection:section withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadFooter:(S2TableViewSection*)section;
{
	[self reloadSection:section withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.visibleSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)index
{
	S2TableViewSection* section = self.visibleSections[index];

	if ([section respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
		return [section tableView:tableView numberOfRowsInSection:index];
	}
	
	return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	S2TableViewSection* section = self.visibleSections[indexPath.section];
	
	return [section tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	id<UITableViewDataSource> sectionDataSource = self.visibleSections[section];
	
	if ([sectionDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
		return [sectionDataSource tableView:tableView titleForHeaderInSection:section];
	}
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	id<UITableViewDataSource> sectionDataSource = self.visibleSections[section];
	
	if ([sectionDataSource respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
		return [sectionDataSource tableView:tableView titleForFooterInSection:section];
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	id<UITableViewDelegate> sectionDelegate = self.visibleSections[section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
		return [sectionDelegate tableView:tableView heightForHeaderInSection:section];
	}
	
	return -1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	id<UITableViewDelegate> sectionDelegate = self.visibleSections[section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
		return [sectionDelegate tableView:tableView heightForFooterInSection:section];
	}
	
	return -1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<UITableViewDelegate> sectionDelegate = self.visibleSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
		return [sectionDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
	}
	
	return -1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	id<UITableViewDelegate> sectionDelegate = self.visibleSections[section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
		return [sectionDelegate tableView:tableView viewForHeaderInSection:section];
	}
	
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	id<UITableViewDelegate> sectionDelegate = self.visibleSections[section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
		return [sectionDelegate tableView:tableView viewForFooterInSection:section];
	}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
	id<UITableViewDelegate> sectionDelegate = self.visibleSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
		[sectionDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	id<UITableViewDataSource> sectionDelegate = self.visibleSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
		return [sectionDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
	}
	
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<UITableViewDelegate> sectionDelegate = self.visibleSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
		return [sectionDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
	}

	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
	id<UITableViewDataSource> sectionDelegate = self.visibleSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
		[sectionDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	}
}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//	id<UITableViewDataSource> sectionDelegate = self.visibleSections[indexPath.section];
//	
//	if ([sectionDelegate respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]) {
//		return [sectionDelegate tableView:tableView canMoveRowAtIndexPath:indexPath];
//	}
//	
//	return NO;
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
//{
//	id<UITableViewDataSource> sectionDelegate = self.visibleSections[indexPath.section];
//	
//	if ([sectionDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
//		[sectionDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
//	}
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<UITableViewDelegate> sectionDelegate = self.visibleSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
		[sectionDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<UITableViewDelegate> sectionDelegate = self.visibleSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
		[sectionDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
	id<UITableViewDelegate> sectionDelegate = self.visibleSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]) {
		[sectionDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
	}
}

@end



@implementation S2TableViewSection

- (id)init;
{
	if (self = [super init]) {
		_visible = YES;
	}
	return self;
}

- (NSInteger)index;
{
	return [_adapter indexOfSection:self];
}

- (void)reload;
{
	[_adapter reloadSection:self withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadWithRowAnimation:(UITableViewRowAnimation)animation;
{
	[_adapter reloadSection:self withRowAnimation:animation];
}

- (void)reloadHeader;
{
	[_adapter reloadHeader:self];
}

- (void)reloadFooter;
{
	[_adapter reloadFooter:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
}

@end



@implementation S2TableViewRow {
	NSIndexPath* _indexPath;
}

+ (id)new;
{
	return [[self alloc] init];
}

+ (id)new:(id)object;
{
	return [[self alloc] initWithObject:object];
}

- (id)init;
{
	if (self = [super init]) {
		_visible = YES;
	}
	return self;
}

- (id)initWithObject:(id)object;
{
	if (self = [self init]) {
		_object = object;
	}
	return self;
}

- (NSString *)title;
{
	if (_object == nil)
		return @"";
	if (S2ObjectIsKindOf(_object, NSString))
		return _object;
	return [_object toString];
}

- (NSIndexPath *)indexPath;
{
	return _indexPath;
}

- (void)setIndexPath:(NSIndexPath *)indexPath;
{
	_indexPath = indexPath;
}

- (UITableViewCell *)chooseCell:(S2TableViewCellState)cellState;
{
	S2TableViewStandardCell* cell = [S2TableViewStandardCell newBasicCell:@"__Cell"];
	cell.title = self.title;
	return cell;
}

- (void)didSelected:(S2TableViewCellState)cellState;
{
}

@end



@implementation S2TableViewPropertySection {
	NSString* _sectionTitle;
	NSArray* _rows;
}

+ (id)new:(NSString*)sectionTitle rows:(NSArray *)rows;
{
	return [[self alloc] init:sectionTitle rows:rows];
}

- (id)init:(NSString*)sectionTitle rows:(NSArray *)rows;
{
	if (self = [self init]) {
		_sectionTitle = sectionTitle;
		_rows = rows;
	}
	return self;
}

- (NSArray*)visibleRows;
{
	NSMutableArray* rows = [NSMutableArray new];
	for (S2TableViewRow* row in _rows) {
		if (row.visible)
			[rows addObject:row];
	}
	return rows;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return self.visibleRows.count;
}

- (UITableViewCell *)tableView:(S2TableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	S2TableViewRow* row = self.visibleRows[indexPath.row];

	row.indexPath = indexPath;

	return [row chooseCell:tableView.cellState];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	S2TableViewRow* row = self.visibleRows[indexPath.row];
	
	if (row.height > 0) {
		return row.height;
	}
	else {
		return tableView.rowHeight;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
	return _sectionTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	S2TableViewRow* row = self.visibleRows[indexPath.row];
	
	[row didSelected:tableView.cellState];
}

@end



@implementation S2TableViewEditableListSection {
	NSString* _sectionTitle;
	NSMutableArray* _items;
}

- (id)init;
{
	if (self = [super init]) {
//		_sectionTitle = sectionTitle;
		_items = [NSMutableArray new];
	}
	return self;
}

- (NSArray*)items;
{
	return _items;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return _items.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSInteger row = indexPath.row;
	if (row == _items.count) {
		// 
		S2TableViewStandardCell* cell = [S2TableViewStandardCell newRightDetailCell:@"RowAddCell"];
		cell.title = [self addRowTitle];
		return cell;
	}
	else {
		// アイテムセルは詳細ボタン付き
		UITableViewCell* cell = [self tableView:tableView cellForItem:_items[indexPath.row] at:indexPath];
		cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		return cell;
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return indexPath.row == _items.count ? UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSInteger row = indexPath.row;
	if (row == _items.count) {
		[_items addObject:[self tableView:tableView newItem:indexPath]];
		[tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	else {
		[self tableView:tableView removeItem:_items[indexPath.row] at:indexPath];

		[_items removeObjectAtIndex:indexPath.row];
		[tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	// 選択を許可しない
	return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
	[self tableView:tableView itemSelected:_items[indexPath.row] at:indexPath];
}

@end



@implementation S2TableViewEditableListSection (Delegate)

- (UITableViewCell*)tableView:(UITableView *)tableView cellForItem:(id)item at:(NSIndexPath*)indexPath;
{
	S2AssertMustOverride();
	return nil;
}

- (NSString*)addRowTitle;
{
	return @"Add...";
}

- (id)tableView:(UITableView *)tableView newItem:(NSIndexPath*)indexPath;
{
	S2AssertMustOverride();
	return S2DateNow();
}

- (void)tableView:(UITableView *)tableView itemSelected:(id)item at:(NSIndexPath*)indexPath;
{
}

- (void)tableView:(UITableView *)tableView removeItem:(id)item at:(NSIndexPath*)indexPath;
{
}

@end



@implementation S2TableViewSectionCommand {
	void (^_completion)();
}

+ (id)new:(NSString*)title completion:(void(^)())completion;
{
	return [[self alloc] init:title completion:completion];
}

- (id)init:(NSString*)title completion:(void(^)())completion;
{
	if (self = [self init]) {
		_title = title;
		_completion = completion;
	}
	return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	S2TableViewStandardCell* cell;
	cell = (S2TableViewStandardCell*)[tableView dequeueReusableCellWithIdentifier:@"CommandCell"];
	if (!cell) cell = [S2TableViewStandardCell newBasicCell:@"CommandCell"];
	
	cell.title = self.title;
	cell.textLabel.textAlignment = NSTextAlignmentCenter;
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
{
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if (_completion) {
		_completion();
	}

	// 行選択を解除する
	[tableView deselectAllRows];
}

@end
