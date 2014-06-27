//
//  S2TableView.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/11/19.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "UIKit+S2AppKit.h"

@class S2TableView, S2TableViewAdapter, S2TableViewSection;



typedef enum {
	S2TableViewCellStateView,
	S2TableViewCellStateEditing,
} S2TableViewCellState;



@interface UITableView (CellSetSupport)

@property S2TableViewCellState cellState;

- (void)attach:(S2TableViewAdapter *)adapter;

@end



#define	S2TableViewDefaultBackground S2HsbColor(220, 4, 90)

@interface S2TableView : UITableView

+ (id)newPlainStyle:(BOOL)showUnlimitedSeparator;
+ (id)newGroupedStyle;

@property S2TableViewCellState cellState;

@end



/*
 *	テーブルビューのDataSouce, Delegateをセクションごとに振り分ける
 */
@interface S2TableViewAdapter : NSObject <UITableViewDataSource, UITableViewDelegate>

+ (id)new;

- (void)addSection:(S2TableViewSection*)section;
- (void)addSections:(NSArray*)sections;
- (NSArray*)sections;

@end


/*
 *	テーブルビューセクション
 */
@interface S2TableViewSection : NSObject <UITableViewDataSource, UITableViewDelegate>

@property BOOL visible;

- (NSInteger)index;
- (void)reload;
- (void)reloadWithRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadHeader;
- (void)reloadFooter;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end



/*
 *	セル状態によりセルを切り替えるインターフェース
 */
@interface S2TableViewRow : NSObject

+ (id)new;
+ (id)new:(id)object;
- (id)initWithObject:(id)object;

@property id object;
@property BOOL visible;
@property (readonly) NSString* title;
@property NSInteger height;
@property NSIndexPath* indexPath;

- (UITableViewCell*)chooseCell:(S2TableViewCellState)cellState;

@end

@interface S2TableViewRow (Events)

- (void)didSelected:(S2TableViewCellState)cellState;

@end



@interface S2TableViewPropertySection : S2TableViewSection

+ (id)new:(NSString*)sectionTitle rows:(NSArray*)rows;

@property (readonly) NSArray* rows;

//@property NSString* sectionHeader;
//@property NSString* sectionFooter;

@end



@interface S2TableViewEditableListSection : S2TableViewSection

@property (readonly) NSMutableArray* items;

@end

@interface S2TableViewEditableListSection (Delegate)

- (UITableViewCell*)tableView:(UITableView *)tableView cellForItem:(id)item at:(NSIndexPath*)indexPath;
- (void)tableView:(UITableView *)tableView itemSelected:(id)item at:(NSIndexPath*)indexPath;
- (NSString*)addRowTitle;
- (id)tableView:(UITableView *)tableView newItem:(NSIndexPath*)indexPath;
- (void)tableView:(UITableView *)tableView removeItem:(id)item at:(NSIndexPath*)indexPath;

@end



@interface S2TableViewSectionCommand : S2TableViewSection

+ (id)new:(NSString*)title completion:(void(^)())completion;

@property NSString* title;
@property NSString* footer;
		   
@end
