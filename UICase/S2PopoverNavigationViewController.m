//
//  S2PopoverNavigationViewController.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/13.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2PopoverNavigationViewController.h"



@implementation S2PopoverNavigationViewController {
	CGSize _initialSize;
}

+ (id)new_uicase:(S2UICase*)uicase size:(CGSize)size;
{
	S2PopoverNavigationViewController* instance = [super new_uicase:uicase];
	
	instance->_initialSize = size;
	instance.preferredContentSize = size;
	
	return instance;
}

- (void)loadView
{
	UIView* wholeView = [[UIView alloc] initWithFrame:S2RectFromSize(_initialSize)];

	// トップツールバーを作成する
	UINavigationBar* navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, _initialSize.width, 44)];
	[wholeView addSubview:navigationBar];
	_navigationBar = navigationBar;

	// コンテキストツールバーを作成する
	S2ContextToolbar* contextToolbar = [S2ContextToolbar new];
	[wholeView addSubview:contextToolbar];
//	contextToolbar.layer.zPosition = 1;
	_contextToolbar = contextToolbar;

	// コンテンツビューを取得し、追加する
	UIView* contentView = self.contentView;
	if (contentView) {
		int contentTop = navigationBar.height;
		contentView.frame = CGRectMake(0, contentTop, _initialSize.width, _initialSize.height - contentTop);
		contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		[wholeView addSubview:contentView];
	}

	self.view = wholeView;
}

// override point
- (UIView *)contentView
{
	return [UIView blankView];
}

@end
