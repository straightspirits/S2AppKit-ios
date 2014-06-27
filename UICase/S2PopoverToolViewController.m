//
//  S2PopoverToolViewController.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/13.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2PopoverToolViewController.h"



@implementation S2PopoverToolViewController {
	CGSize _initialSize;
}

+ (id)new_uicase:(S2UICase*)uicase size:(CGSize)size;
{
	S2PopoverToolViewController* instance = [super new_uicase:uicase];
	
	instance->_initialSize = size;
	instance.contentSizeForViewInPopover = size;
	
	return instance;
}

- (void)loadView
{
	UIView* wholeView = [[UIView alloc] initWithFrame:S2RectFromSize(_initialSize)];

	// トップツールバーを作成する
	S2Toolbar* toolbar = [[S2Toolbar alloc] initWithFrame:CGRectMake(0, 0, _initialSize.width, 44)];
	[wholeView addSubview:toolbar];
	_topToolbar = toolbar;

	// コンテキストツールバーを作成する
	S2ContextToolbar* contextToolbar = [S2ContextToolbar new];
	[wholeView addSubview:contextToolbar];
//	contextToolbar.layer.zPosition = 1;
	_contextToolbar = contextToolbar;
	
	// コンテンツビューを取得し、追加する
	UIView* contentView = self.contentView;
	if (contentView) {
		int contentTop = toolbar.height;
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
