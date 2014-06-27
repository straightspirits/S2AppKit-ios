//
//  S2CardPropertyEditorViewController.m
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/23.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2CardPropertyEditorViewController.h"



@implementation S2CardPropertyEditorViewController {
	S2TableViewAdapter* _tableViewAdapter;
}

- (NSArray*)tableSections;
{
	S2AssertMustOverride();
	return nil;
}

- (S2TableViewAdapter *)tableViewAdapter;
{
	if (!_tableViewAdapter) {
		_tableViewAdapter = [S2TableViewAdapter new];
		for (S2TableViewSection* section in self.tableSections) {
			[_tableViewAdapter addSection:section];
		}
	}
	
	return _tableViewAdapter;
}

@end
