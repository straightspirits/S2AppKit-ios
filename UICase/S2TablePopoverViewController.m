//
//  S2TablePopoverViewController.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/07.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2TablePopoverViewController.h"
#import "S2TableViewCellCollection.h"



@interface S2TablePopoverViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation S2TablePopoverViewController {
	CGSize _size;
	NSIndexPath* _lastSelectedIndexPath;
}

+ (id)new_uicase:(S2UICase*)uicase size:(CGSize)size;
{
	S2TablePopoverViewController* instance = [super new_uicase:uicase];

	instance->_size = size;
	instance.decideMode = S2PopoverTableViewDecideOnceTap;

	return instance;
}

- (void)loadView
{
	if (!self.nibBundle || !self.nibName) {
		// プレーンスタイルのテーブルビューを作成する
		UITableView* view = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height) style:UITableViewStylePlain];
		
		self.view = view;
		self.tableView = view;
	}
	else {
		[super loadView];
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
}

- (void)applySelection:(NSIndexPath *)indexPath
{
	self.delegate.selectedIndex = indexPath.row;
}

#pragma mark - UITableViewDataSource method implements

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.delegate numberOfRowCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self.delegate tableView:tableView cellForRow:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (self.decideMode) {
			// 1回タップ確定モード
		case S2PopoverTableViewDecideOnceTap:
			[self applySelection:indexPath];
			[self.delegate dismissPopover];
			break;
			
			// 2回タップ確定モード
		case S2PopoverTableViewDecideTwiceTap:
			if ([_lastSelectedIndexPath isEqual:indexPath]) {
				[self applySelection:indexPath];
				[self.delegate dismissPopover];
			}
			_lastSelectedIndexPath = indexPath;
			break;
			
			// 1回タップ確定モード(閉じない)
		case S2PopoverTableViewDecideOnceTapNoDismiss:
			[self applySelection:indexPath];
			break;
	}
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
	[self.delegate dismissPopover];
	
	return NO;
}

@end



@implementation S2StringListPopoverViewController {
	NSArray* _items;
	NSString* (^_stringer)(id item);
	NSInteger _selectedRow;
	void (^_selected)(NSInteger index, id item);
	void (^_dismissed)();
}

+ (id)new_uicase:(S2UICase*)uicase width:(CGFloat)width strings:(NSArray *)strings;
{
	return [self new_uicase:uicase width:width strings:strings selected:nil dismissed:nil];
}

+ (id)new_uicase:(S2UICase*)uicase width:(CGFloat)width strings:(NSArray*)strings selected:(void (^)(NSInteger index, id item))selected dismissed:(void(^)())dismissed;
{
	NSParameterAssert(uicase);
	NSParameterAssert(strings);
	
	S2StringListPopoverViewController* instance = [self new_uicase:uicase size:CGSizeMake(width, 50)];
	instance->_items = strings;
	instance->_stringer = ^NSString*(id item) { return item; };
	instance->_selectedRow = -1;
	instance->_selected = selected;
	instance->_dismissed = dismissed;

	return instance;
}

+ (id)new_uicase:(S2UICase*)uicase width:(CGFloat)width items:(NSArray*)items stringer:(NSString* (^)(id item))stringer selected:(void (^)(NSInteger index, id item))selected dismissed:(void(^)())dismissed;
{
	NSParameterAssert(uicase);
	NSParameterAssert(items);
	NSParameterAssert(stringer);

	S2StringListPopoverViewController* instance = [self new_uicase:uicase size:CGSizeMake(width, 50)];
	instance->_items = items;
	instance->_stringer = stringer;
	instance->_selectedRow = -1;
	instance->_selected = selected;
	instance->_dismissed = dismissed;
	
	return instance;
}

 - (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.delegate = self;

//	self.tableView.sectionHeaderHeight = 10;
//	self.tableView.sectionFooterHeight = 10;

	self.preferredContentSize = [self.tableView rectForSection:0].size;

	// 初期選択
	if (_selectedRow >= 0) {
		NSIndexPath* indexPath = [NSIndexPath indexPathForRow:_selectedRow inSection:0];
		[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
}

- (NSInteger)selectedIndex
{
	return _selectedRow;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
	if (_selected) {
		_selected(selectedIndex, _items[selectedIndex]);
	}
	
	_selectedRow = selectedIndex;
}

- (NSInteger)numberOfRowCount
{
	return _items.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRow:(NSInteger)row
{
	S2TableViewStandardCell* cell = [S2TableViewStandardCell instantiateRightDetailCell:tableView reuseIdentifier:@"Cell"];
	
	cell.title = _stringer([_items objectAtIndex:row]);
	
	return cell;
}

- (void)dismissPopover
{
	[self.uicase dismissPopover];
	
	if (_dismissed) {
		_dismissed();
	}
}

@end