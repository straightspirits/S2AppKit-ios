//
//  S2ListViewController.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/27.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2TableView.h"
#import "S2ListViewController.h"
#import "S2TableViewCellCollection.h"



@interface S2ListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak) S2TableView* tableView;
@property NSMutableArray* checks;

@end

@implementation S2ListViewController {
	NSString* (^_stringer)(id item);
	void (^_selectionChanged)(NSArray* selectedItems);
}

- (NSString *(^)(id))stringer;
{
	return _stringer;
}

- (void)setStringer:(NSString *(^)(id))stringer;
{
	_stringer = stringer;
}

- (void (^)(NSArray *))selectionChanged;
{
	return _selectionChanged;
}

- (void)setSelectionChanged:(void (^)(NSArray *))selectChanged;
{
	_selectionChanged = selectChanged;
}

- (void)loadView;
{
	self.view = UIView.blankView;
	
	S2TableView* tableView = [S2TableView newPlainStyle:YES];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self.view addSubview:tableView];
	self.tableView = tableView;
}

- (void)initializeForDisplay;
{
	_checks = [NSMutableArray arrayWithCapacity:_targetItems.count];
	for (id item in _targetItems) {
		[_checks addObject:@(NO)];
	}

	[self.selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
		[self setChecked:YES at:[NSIndexPath indexPathForRow:index inSection:0]];
	}];
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	self.tableView.tableFooterView.frame = self.tableView.rectForTableFooter;
}

- (BOOL)checkedAt:(NSIndexPath*)indexPath;
{
	NSNumber* checked = [_checks objectAtIndex:indexPath.row];
	return checked.boolValue;
}

- (void)setChecked:(BOOL)checked at:(NSIndexPath*)indexPath;
{
	[_checks replaceObjectAtIndex:indexPath.row withObject:@(checked)];
	
	UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
	if (cell) {
		cell.imageView.image = [UIImage imageNamed:checked ? @"check-14" : @"blank-14"];
	}
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return _targetItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	id item = [_targetItems objectAtIndex:indexPath.row];
	
	S2TableViewStandardCell* cell = [S2TableViewStandardCell instantiateRightDetailCell:tableView reuseIdentifier:@"Cell"];
	
	if (_stringer) {
		cell.title = _stringer(item);
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
	cell.backgroundColor = S2ColorWhite;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.imageView.image = [UIImage imageNamed:[self checkedAt:indexPath] ? @"check-14" : @"blank-14"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if (self.allowMultiSelection) {
		// チェック済みなら、解除する
		if ([self checkedAt:indexPath]) {
			[self setChecked:NO at:indexPath];
			
			[self.selectedIndexes removeIndex:indexPath.row];
			
			if (_selectionChanged) {
				_selectionChanged(self.selectedItems);
			}
		}
		// チェックなしなら、設定する
		else {
			[self setChecked:YES at:indexPath];
			
			[self.selectedIndexes addIndex:indexPath.row];
			
			if (_selectionChanged) {
				_selectionChanged(self.selectedItems);
			}
		}
	}
	else {
		// 選択を全解除する
		[self.selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
			[self setChecked:NO at:[NSIndexPath indexPathForRow:index inSection:0]];
		}];
		[self.selectedIndexes removeAllIndexes];
		
		// チェックする
		[self setChecked:YES at:indexPath];
		
		[self.selectedIndexes addIndex:indexPath.row];
		
		if (_selectionChanged) {
			_selectionChanged(self.selectedItems);
		}
	}
}

- (NSArray*)selectedItems;
{
	NSMutableArray* items = [NSMutableArray new];

	[self.selectedIndexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
		[items addObject:[self.targetItems objectAtIndex:index]];
	}];
	
	return items;
}

@end
