//
//  S2TableDialogController.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/04.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2TableDialogController.h"



@implementation S2TableEditableViewController

+ (id)new_uicase:(S2UICase*)uicase editMode:(BOOL)editMode;
{
	S2TableEditableViewController* instance = [self new_uicase:uicase style:UITableViewStylePlain];

	instance->_editMode = editMode;

	return instance;
}

- (NSArray*)tableSections;
{
	S2AssertMustOverride();
	return nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.tableView.dataSource = self;
	self.tableView.delegate = self;

	// 編集モードに移行する
	if (self.editMode) {
		self.tableView.cellState = S2TableViewCellStateEditing;
//		self.tableView.editing = YES;
//		self.tableView.allowsSelectionDuringEditing = YES;
	}
	else {
		self.tableView.cellState = S2TableViewCellStateView;
	}
}

#pragma mark - 

- (void)didReturnKeyPressed:(UIView *)sender;
{
	UIView* nextResponder = [self nextResponder:sender];
	if (nextResponder) {
		[nextResponder becomeFirstResponder];
	}
	else {
		[self.navigationController popViewControllerAnimated:self.uicase.enableAnimation];
	}
}

#pragma mark - UITableView dataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return self.tableSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)index;
{
	S2TableViewSection* section = self.tableSections[index];
	return [section tableView:tableView numberOfRowsInSection:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	S2TableViewSection* section = self.tableSections[indexPath.section];
	return [section tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
	S2TableViewSection* section = self.tableSections[indexPath.section];
	if ([section respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
		[section tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 50.0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	S2TableViewSection* section = self.tableSections[indexPath.section];
	if ([section respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
		return [section tableView:tableView willSelectRowAtIndexPath:indexPath];
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	S2TableViewSection* section = self.tableSections[indexPath.section];
	if ([section respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
		[section tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
	S2TableViewSection* section = self.tableSections[indexPath.section];
	if ([section respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
		[section tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)index;
{
	S2TableViewSection* section = self.tableSections[index];
	if ([section respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
		return [section tableView:tableView titleForHeaderInSection:index];
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)index;
{
	S2TableViewSection* section = self.tableSections[index];
	if ([section respondsToSelector:@selector(tableView:titleForFooterInSection:)])
		return [section tableView:tableView titleForHeaderInSection:index];
	return nil;
}

//-- add/delete --//

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	id<UITableViewDataSource> sectionDelegate = self.tableSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]) {
		return [sectionDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
	}
	
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	id<UITableViewDelegate> sectionDelegate = self.tableSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]) {
		return [sectionDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
	}
	
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
	id<UITableViewDataSource> sectionDelegate = self.tableSections[indexPath.section];
	
	if ([sectionDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
		[sectionDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	}
}

@end



@interface S2TableDialogController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@end

@implementation S2TableDialogController {
	S2DialogDismissed _dismissed;
	S2DialogCompletion _completion;
}

+ (id)new_uicase:(S2UICase *)uicase;
{
	return [self new_uicase:uicase style:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// タイトルバーの設定
	[self initializeTitleBar];
}

- (void)viewDidUnload
{
	[self setTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillLayoutSubviews;
{
	self.tableView.height = [self.tableView rectForContents].size.height;

	[super viewWillLayoutSubviews];
}

#pragma mark -

- (id)targetItem;
{
	return nil;
}

- (void)showItem:(UIViewController*)superViewController dismissed:(S2DialogDismissed)dismissed;
{
	[self showItem:superViewController animated:self.uicase.enableAnimation dismissed:dismissed];
}

- (void)showItem:(UIViewController*)superViewController animated:(BOOL)animated dismissed:(S2DialogDismissed)dismissed;
{
	self.editMode = NO;
	_completion = nil;
	_dismissed = dismissed;

	[self presentViewController:superViewController animated:(BOOL)animated];
}

- (void)editItem:(UIViewController*)superViewController completion:(S2DialogCompletion)completion dismissed:(S2DialogDismissed)dismissed;
{
	[self editItem:superViewController animated:self.uicase.enableAnimation completion:completion dismissed:dismissed];
}

- (void)editItem:(UIViewController*)superViewController animated:(BOOL)animated completion:(S2DialogCompletion)completion dismissed:(S2DialogDismissed)dismissed;
{
	S2AssertParameter(superViewController);
	S2AssertParameter(completion);
	
	self.editMode = YES;
	_completion = completion;
	_dismissed = dismissed;

	[self presentViewController:superViewController animated:(BOOL)animated];
}

- (void)presentViewController:(UIViewController*)superViewController animated:(BOOL)animated;
{
	// ビューをモーダル表示する
	S2NavigationController* navigationController = [[S2NavigationDialogController alloc] initWithRootViewController:self];
	navigationController.navigationBar.barStyle = UIBarStyleBlack;
	navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
	navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	navigationController.delegate = self;
	[superViewController presentViewController:navigationController animated:animated completion:nil];
}

- (void)initializeTitleBar;
{
	UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]
								   initWithTitle:[S2UIKit localizedStringForKey:@"Done"]
								   style:UIBarButtonItemStyleDone
								   target:self action:@selector(doneButtonPressed:)
								   ];
	
	UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
									 initWithTitle:[S2UIKit localizedStringForKey:self.editMode ? @"Cancel" : @"Close"]
									 style:UIBarButtonItemStylePlain
									 target:self action:@selector(cancelButtonPressed:)
									 ];
	
	self.navigationItem.title = self.title;
	if (self.editMode) {
		self.navigationItem.rightBarButtonItem = doneButton;
	}
	self.navigationItem.leftBarButtonItem = cancelButton;
}

#pragma mark -

- (void)didReturnKeyPressed:(UIView*)sender;
{
	UIView* nextResponder = [self nextResponder:sender];
	if (nextResponder) {
		[nextResponder becomeFirstResponder];
	}
	else {
		[self doneButtonPressed:sender];
	}
}

- (void)doneButtonPressed:(id)sender
{
	// 入力中のテキストフィールドを確定させる
	[self.view endEditing:NO];

	// 入力内容のチェック
	if (![self validateInput]) {
		return;
	}

	// ビューを閉じる
	// MEMO: dismissViewControllerAnimated:completion: (アニメーションON)より先に -[UIView endEditing:] を呼び出すと、landscapeモード時におかしなアニメーションが発生してしまう。(Crossなんちゃらのエフェクトの場合のみの現象)
	// MEMO: -[UIView endEditing:] はこの中で呼ばれている。
	[self dismissViewControllerAnimated:self.uicase.enableAnimation completion:nil];

	if (_completion)
		_completion(self.targetItem);

	if (_dismissed)
		_dismissed();
}

- (void)cancelButtonPressed:(id)sender
{
	// ビューを閉じる
	[self dismissViewControllerAnimated:self.uicase.enableAnimation completion:nil];

	if (_dismissed)
		_dismissed();
}

- (BOOL)validateInput;
{
	return YES;
}

@end
