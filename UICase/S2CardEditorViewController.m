//
//  S2CardEditorViewController.m
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/18.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2CardEditorViewController.h"
#import "S2CardListViewController.h"
#import "S2CardContainerViewController.h"



@implementation S2CardEditorViewController

#pragma mark - S2CardViewController support

- (S2CardListViewController *)cardListViewController
{
	UISplitViewController* splitViewController = self.splitViewController;
	
	if (!splitViewController) {
		S2LogWarning(nil, S2ClassTag, @"%@.splitViewController is nil", NSStringFromClass(self.class));
		return nil;
	}
	
	UINavigationController* navigationController = splitViewController.viewControllers[0];

	if (![navigationController.topViewController isKindOfClass:S2CardListViewController.class]) {
		S2LogWarning(nil, S2ClassTag, @"%@.splitViewController.viewControllers[0].topViewController is not %@", NSStringFromClass(S2CardListViewController.class));
		return nil;
	}

	return (S2CardListViewController *)navigationController.topViewController;
}

- (S2CardContainerViewController*)cardContainerViewController
{
	UISplitViewController* splitViewController = self.splitViewController;

	if (!splitViewController) {
		return nil;
	}

//	NSAssert(splitViewController.viewControllers.count == 2, @"Require=2, Value=%ld.", splitViewController.viewControllers.count);

	return splitViewController.viewControllers.lastObject;
}

- (void)viewDidAppear:(BOOL)animated
{
	// 複数回呼び出された場合のガード
	if (self.cardContainerViewController.currentEditor == self)
		return;

	[super viewDidAppear:animated];
	
	self.cardContainerViewController.currentEditor = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	if (!self.cardContainerViewController.currentEditor)
		return;
	
	self.cardContainerViewController.currentEditor = nil;
}

@end



@implementation S2TableCardEditorViewController {
	UIBarButtonItem* _editButtonItem;
	UIBarButtonItem* _doneButtonItem;
}

- (void)loadView
{
	if (!self.nibBundle || !self.nibName) {
		// グループスタイルのテーブルビューを作成する
		UITableView* view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
		self.view = view;
		self.tableView = view;
	}
	else {
		[super loadView];
	}

	// リスト編集可能な場合、編集ボタンを表示する
	if (self.editing && self.listEditable) {
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// tableViewプロパティが設定されていない場合、viewプロパティがUITableViewならそれをtableViewとして扱う
	if (!self.tableView) {
		if ([self.view isKindOfClass:UITableView.class]) {
			self.tableView = (UITableView*)self.view;
		}
	}
	
	// デリゲートを設定する
	S2TableViewAdapter* adapter = self.tableViewAdapter;
	if (adapter) {
		[self.tableView attach:adapter];
	}
	else {
		if (!self.tableView.dataSource) {
			self.tableView.dataSource = self;
		}
		if (!self.tableView.delegate) {
			self.tableView.delegate = self;
		}
	}
	
//	// 編集中も行選択を許可する
//	self.tableView.allowsSelectionDuringEditing = YES;
}

// MEMO: UITableViewController#@clearsSelectionOnViewWillAppear と同等の実装
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.tableView deselectAllRowsAnimated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	if (self.editing == editing)
		return;

	[super setEditing:editing animated:animated];

	if (editing) {
		self.tableView.cellState = S2TableViewCellStateEditing;
		
		if (self.listEditable) {
			self.navigationItem.rightBarButtonItem = self.listEditButtonItem;
		}
	}
	else {
		self.tableView.cellState = S2TableViewCellStateView;

		self.navigationItem.rightBarButtonItem = nil;
	}
	
	// 表示中の時のみ、プロパティ変化を通知する
	if (self.isViewLoaded) {
		[self editingChanged:animated];
	}
}

- (void)editingChanged:(BOOL)animated;
{
	if (!self.editing && self.listEditing) {
		// リスト編集を強制終了する
		[self.tableView setEditing:NO animated:YES];
		
		// 自動保存モードを設定する
		self.autoSave = YES;
		
		[self didEndListEditing];
	}

	[self.tableView reloadData];
}

- (UIBarButtonItem *)listEditButtonItem
{
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(listEditButtonPressed:)];
}

- (UIBarButtonItem *)listDoneButtonItem
{
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(listDoneButtonPressed:)];
}

- (void)listEditButtonPressed:(UIBarButtonItem*)sender
{
	[self setListEditing:YES animated:YES];
	
	self.navigationItem.rightBarButtonItem = self.listDoneButtonItem;
	self.navigationItem.hidesBackButton = YES;
}

- (void)listDoneButtonPressed:(UIBarButtonItem*)sender
{
	[self setListEditing:NO animated:YES];
	
	self.navigationItem.rightBarButtonItem = self.listEditButtonItem;
	self.navigationItem.hidesBackButton = NO;
}

- (BOOL)listEditing
{
	return self.tableView.editing;
}

- (void)setListEditing:(BOOL)listEditing animated:(BOOL)animated;
{
	if (self.tableView.editing == listEditing)
		return;
	
	[self.tableView setEditing:listEditing animated:animated];

	if (listEditing) {
		// 自動保存モードを解除する
		self.autoSave = NO;
		
		[self didBeginListEditing];
	}
	else {
		// 自動保存モードを設定する
		self.autoSave = YES;
		
		[self didEndListEditing];
	}
}

- (void)didBeginListEditing
{
	// optional override
}

- (void)didEndListEditing
{
	// optional override
}

- (void)presentDialogController:(S2TableDialogController *)dialogController
{
	[self presentDialogController:dialogController editMode:self.editing completion:nil];
}

//- (void)presentDialogController:(S2TableDialogController *)dialogController animated:(BOOL)animated
//{
//	[self presentDialogController:dialogController editMode:self.editing animated:animated completion:nil];
//}

- (void)presentDialogController:(S2TableDialogController *)dialogController completion:(S2DialogCompletion)completion
{
	[self presentDialogController:dialogController editMode:self.editing completion:completion];
}

//- (void)presentDialogController:(S2TableDialogController *)dialogController animated:(BOOL)animated completion:(S2DialogCompletion)completion
//{
//	[self presentDialogController:dialogController editMode:self.editing animated:animated completion:completion];
//}

- (void)presentDialogController:(S2TableDialogController *)dialogController editMode:(BOOL)editMode completion:(S2DialogCompletion)completion;
{
	// 表示モード
	if (!editMode) {
		[dialogController showItem:self
			dismissed:^{
				[self clearSelections];
			}
		];
	}
	// 編集モード
	else {
		[dialogController editItem:self
			completion:^(id newItem) {
				if (completion) {
					completion(newItem);
				}
			}
			dismissed:^{
				[self clearSelections];
			}
		];
	}
}

/*
- (void)presentDialogController:(S2TableDialogController *)dialogController editMode:(BOOL)editMode animated:(BOOL)animated completion:(S2DialogCompletion)completion;
{
	// 表示モード
	if (!editMode) {
		[dialogController showItem:self
			animated:animated
			dismissed:^{
				[self clearSelections];
			}
		];
	}
	// 編集モード
	else {
		[dialogController editItem:self
			animated:animated
			completion:^(id newItem) {
				if (completion) {
					completion(newItem);
				}
			}
			dismissed:^{
				[self clearSelections];
			}
		];
	}
}*/

- (void)clearSelections;
{
	// リストの選択を解除する
	[self.tableView deselectAllRows];
}

#pragma mark - TableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end