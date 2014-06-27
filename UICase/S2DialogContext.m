//
//  S2DialogContext.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/11/20.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2DialogContext.h"
#import "S2DialogPageController.h"



// プライベートインターフェースの定義
@interface S2DialogContext ()

@end

// インターフェースの実装
@implementation S2DialogContext {
	UIViewController* _parentViewController;
	S2NavigationDialogController* _navigationController;
	NSArray* _pageIdentifiers;
	NSInteger _currentPageIndex;
}

+ (id)new:(UIViewController *)parentViewController;
{
	return [[self alloc] init:parentViewController];
}

- (id)init:(UIViewController *)parentViewController;
{
	if (self = [super init]) {
		_parentViewController = parentViewController;
	}
	return self;
}

- (S2UICase*)uicase;
{
	return _parentViewController.uicase;
}

- (void)startWizard:(NSArray*)pageIdentifiers startPageIndex:(int)startPageIndex allowCancel:(BOOL)allowCancel;
{
	_pageIdentifiers = pageIdentifiers;
	_currentPageIndex = startPageIndex;

	// 最初のページをロードする
	NSString* rootPageIdentifier = [pageIdentifiers objectAtIndex:_currentPageIndex];
	S2DialogPageController* rootPageController = [self loadPage:rootPageIdentifier];
	if (allowCancel) {
		rootPageController.navigationItem.leftBarButtonItem = rootPageController.cancelButton;
	}
	_navigationController = [S2NavigationDialogController new_rootViewController:rootPageController];
	
	// PageSheetスタイルで表示する(サイズは768x[MAX]固定)
	//	navigationController.modalPresentationStyle = UIModalPresentationPageSheet;
	_navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	_navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[_parentViewController presentViewController:_navigationController animated:YES completion:nil];
}

- (int)pageIndexByIdentifier:(NSString*)pageIdentifier;
{
	int index = 0;
	for (NSString* identifier in _pageIdentifiers) {
		if (S2StringEquals(identifier, pageIdentifier))
			return index;
		++index;
	}
	return -1;
}

- (NSUInteger)pageCount;
{
	return _pageIdentifiers.count;
}

- (id)loadPage:(NSString*)identifier;
{
	S2DialogPageController* pageController = [self.uicase loadViewController:identifier];
	
	S2Assert(pageController, @"view '%@' not found.", identifier);
	S2Assert(S2ObjectIsKindOf(pageController, S2DialogPageController), @"view '%@' not %@.", identifier, NSStringFromClass(S2DialogPageController.class));
	
	pageController.pageContext = self;
	pageController.pageIndex = _currentPageIndex;
	
	// 最終ページならDoneボタン、そうでないならNextボタン
	if (_currentPageIndex >= _pageIdentifiers.count - 1) {
		pageController.navigationItem.rightBarButtonItem = pageController.doneButton;
	}
	else {
		pageController.navigationItem.rightBarButtonItem = pageController.nextButton;
	}
	
	return pageController;
}

// override point
- (NSInteger)nextPage:(S2DialogPageController*)pageController;
{
	return pageController.pageIndex + 1;
}

- (void)transitionToNext:(S2DialogPageController *)pageController
{
	_currentPageIndex = [self nextPage:pageController];

	// 次ページが存在しなければ
	if (_currentPageIndex < 0 || _currentPageIndex >= _pageIdentifiers.count) {
		// ダイアログを閉じる
		[self dismissDialog];
		return;
	}
	
	// 次ページを表示する
	S2DialogPageController* nextPageController = [self loadPage:[_pageIdentifiers objectAtIndex:_currentPageIndex]];
	[_navigationController pushViewController:nextPageController animated:YES];
}

- (void)cancelDialog;
{
	[_navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissDialog;
{
	[_navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
