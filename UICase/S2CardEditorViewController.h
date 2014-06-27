//
//  S2CardEditorViewController.h
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/18.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2EditorViewController.h"


@class S2CardListViewController, S2CardContainerViewController;


/*
 *	カードエディタービュー
 *	※SplitViewの中に入れる
 *		・カードリストビュー
 *		・カードコンテナビュー
 */
@interface S2CardEditorViewController : S2EditorViewController

- (S2CardListViewController*)cardListViewController;

- (S2CardContainerViewController*)cardContainerViewController;

@end



/*
 *	テーブルビューベースのカードエディター
 *		・グループ形式テーブルビュー、コールバックのインストール
 *		・リスト編集機能(編集・完了ボタン、ハンドラ)
 *		・ダイアログ表示サポート
 */
@interface S2TableCardEditorViewController : S2CardEditorViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak) UITableView *tableView;
@property (readonly) S2TableViewAdapter *tableViewAdapter;

- (void)editingChanged:(BOOL)animated;

@property BOOL listEditable;
@property (readonly) BOOL listEditing;
- (void)setListEditing:(BOOL)listEditing animated:(BOOL)animated;
- (void)didBeginListEditing;
- (void)didEndListEditing;

- (void)presentDialogController:(S2TableDialogController *)dialogController;
//- (void)presentDialogController:(S2TableDialogController *)dialogController animated:(BOOL)animated;
- (void)presentDialogController:(S2TableDialogController *)dialogController completion:(S2DialogCompletion)completion;
//- (void)presentDialogController:(S2TableDialogController *)dialogController animated:(BOOL)animated completion:(S2DialogCompletion)completion;
- (void)presentDialogController:(S2TableDialogController *)dialogController editMode:(BOOL)editMode completion:(S2DialogCompletion)completion;
//- (void)presentDialogController:(S2TableDialogController *)dialogController editMode:(BOOL)editMode animated:(BOOL)animated completion:(S2DialogCompletion)completion;
- (void)clearSelections;

@end
