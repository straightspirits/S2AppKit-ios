//
//  S2CollapsibleTableView.m
//  S2AppKit/S2UIKit
//
//  Created by 古川 文生 on 12/07/12.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2CollapsibleTableView.h"



@implementation S2CollapsibleTableView {
	NSMutableArray* _sectionExpandings;
	
	int _lastSelectedSection;
}

+ (id)new
{
	return [super newPlainStyle:NO];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	if (self = [super initWithFrame:frame style:style]) {
		[self initializeInstance];
	}
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[self initializeInstance];
}

- (void)initializeInstance
{
	_sectionExpandings = [NSMutableArray new];

	_lastSelectedSection = -1;
}

- (BOOL)sectionIsExpanding:(int)section
{
	BOOL result = NO;
	
	if (section < _sectionExpandings.count) {
		NSNumber* number = [_sectionExpandings objectAtIndex:section];
		if (number) {
			result = [number boolValue];
		}
	}
	
	return result;
}

- (void)expandSection:(int)section animated:(BOOL)animated
{
	if (section == _lastSelectedSection) {
		return;
	}

	// 引数エラー
	NSInteger sectionCount = [self.dataSource numberOfSectionsInTableView:self];
	if (section >= sectionCount) {
		// 開いているセクションを閉じる
		[self shrinkSection:_lastSelectedSection animated:animated];
		return;
	}
	
	// セクション数が増えていたら、_sectionExpandingsを拡張する
	if (sectionCount > _sectionExpandings.count) {
		_sectionExpandings = [[NSMutableArray alloc] initWithCapacity:sectionCount];
		for (int index = 0; index < sectionCount; ++index) {
			// 前回開いていたセクションのみYESを設定する
			[_sectionExpandings addObject:@(index == _lastSelectedSection)];
		}
	}
	
	if (animated) {
		// 前回開いていたセクションを閉じる
		[self shrinkSection:_lastSelectedSection animated:animated];

		// 指定のセクションをYESに設定する
		[_sectionExpandings replaceObjectAtIndex:section withObject:@(YES)];

		NSInteger rowCount = [self.dataSource tableView:self numberOfRowsInSection:section];
		if (_lastSelectedSection >= 0 || rowCount > 0) {
			// セクションを更新する
			NSMutableArray* indexPathes = [NSMutableArray new];
			for (int index = 0; index < rowCount; ++index) {
				[indexPathes addObject:[NSIndexPath indexPathForRow:index inSection:section]];
			}
			[self insertRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationNone];
		}
	}
	else {
		// 前回開いていたセクションにNOを設定する
		if (_lastSelectedSection >= 0) {
			[_sectionExpandings replaceObjectAtIndex:_lastSelectedSection withObject:@(NO)];
		}

		// 指定のセクションをYESに設定する
		[_sectionExpandings replaceObjectAtIndex:section withObject:@(YES)];

		[super reloadData];
	}
	
	_lastSelectedSection = section;
}

- (void)shrinkSection:(int)section animated:(BOOL)animated
{
	if (section < 0) {
		return;
	}

	NSInteger rowCount = [self.dataSource tableView:self numberOfRowsInSection:section];

	[_sectionExpandings replaceObjectAtIndex:section withObject:@(NO)];
	
	// 前回選択されていたセクションを閉じる
//	[self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
	{
		NSMutableArray* indexPathes = [NSMutableArray new];
		for (int index = 0; index < rowCount; ++index) {
			[indexPathes addObject:[NSIndexPath indexPathForRow:index inSection:section]];
		}
		[self deleteRowsAtIndexPaths:indexPathes withRowAnimation:animated ? UITableViewRowAnimationTop : UITableViewRowAnimationNone];
	}

	_lastSelectedSection = -1;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch* touch = [[touches allObjects] objectAtIndex:0];
	CGPoint pt = [touch locationInView:self];
	
	// セクションを列挙して
	for (int section = (int)[self.dataSource numberOfSectionsInTableView:self] - 1; section >= 0; --section) {
		CGRect headerArea = [self rectForHeaderInSection:section];

		// タッチ位置がセクションヘッダ内であれば
		if (CGRectContainsPoint(headerArea, pt)) {
			if ([self sectionIsExpanding:section]) {
				// そのセクションを閉じる
				[self shrinkSection:section animated:YES];
			}
			else {
				// そのセクションを開く
				[self expandSection:section animated:YES];

				// セクションが全て表示されるようにスクロールする
				NSInteger rowCount = [self numberOfRowsInSection:section];
				if (rowCount > 0) {
//					[self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowCount - 1 inSection:section] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
				}
			}
			
			// 
			if ([self.delegate conformsToProtocol:@protocol(S2CollapsibleTableViewDelegate)]) {
				[(id)self.delegate tableView:self didSelectSectionHeaderAtSection:section];
			}
			break;
		}
	}
	
	[super touchesEnded:touches withEvent:event];
}

// セクションの数が変わったとき、展開状態をクリアする
- (void)reloadData
{
	_lastSelectedSection = -1;

	_sectionExpandings = [NSMutableArray new];

	[super reloadData];
}

@end
