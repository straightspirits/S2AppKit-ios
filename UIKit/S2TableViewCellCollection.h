//
//  S2TableViewCellCollection.h
//  S2AppKit/S2UIKit
//
//  Created by 古川 文生 on 12/07/18.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2Foundation.h"
#import <UIKit/UIKit.h>



@interface S2TableViewCell : UITableViewCell

// must override
@property NSString* title;
// need override
@property NSString* detail;
// need override
@property UIImage* image;

@property BOOL enabled;

- (void)addSubviewAtRight:(UIView*)view;

@end



/*
 *	iOS5標準のTableViewCell
 */
@interface S2TableViewStandardCell : S2TableViewCell

+ (id)newCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;

+ (id)newBasicCell:(NSString*)reuseIdentifier;
+ (id)newLeftDetailCell:(NSString*)reuseIdentifier;
+ (id)newRightDetailCell:(NSString*)reuseIdentifier;
+ (id)newSubtitleCell:(NSString*)reuseIdentifier;

+ (id)instantiateCell:(UITableView*)tableView style:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;

+ (id)instantiateBasicCell:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier;
+ (id)instantiateLeftDetailCell:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier;
+ (id)instantiateRightDetailCell:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier;
+ (id)instantiateSubtitleCell:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier;

- (void)setTitle:(NSString*)title detail:(NSString*)detail;
- (void)setTitle:(NSString*)title subtitle:(NSString*)subtitle;
- (void)setDetail:(NSString*)detail;
- (void)setSubtitle:(NSString*)subtitle;

@end



/*
 *	カスタムセル
 */
@interface S2TableViewCustomCell : S2TableViewCell

+ (id)newCell;
+ (id)newCellWithNibName:(NSString*)nibName;

+ (NSString*)reuseIdentifier;
+ (id)dequeueCell:(UITableView*)tableView;

+ (id)instantiateCell:(UITableView*)tableView;
+ (id)instantiateCell:(NSString*)nibName tableView:(UITableView*)tableView;
+ (id)instantiateCell:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier;
+ (id)instantiateCell:(NSString*)nibName tableView:(UITableView*)tableView reuseIdentifier:(NSString*)reuseIdentifier;

@end



/*
 *	タイトルのみのTableViewCell
 */
@interface S2TableViewTitleCell : S2TableViewCustomCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end



/*
 *	タイトルと詳細テキストのTableViewCell
 */
@interface S2TableViewTitleDetailCell : S2TableViewCustomCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

- (void)setTitle:(NSString*)title detail:(NSString*)detail;

@end



/*
 *	画像のTableViewCell
 */
@interface S2TableViewImageCell : S2TableViewCustomCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageRightView;

@end



/*
 *	追加行のTableViewCell
 */
@interface S2TableViewRowAddCell : S2TableViewCustomCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end



/*
 *	UITextFieldを持つ編集用TableViewCell
 */
@interface S2TableViewTextEditCell : S2TableViewCustomCell <UITextFieldDelegate>

typedef BOOL (^S2TableViewTextEditCellReturnPressed)(UITextField* sender);
typedef void (^S2TableViewTextEditCellValueChanged)(UITextField* sender);

@property (strong, nonatomic) NSString* defaultValue;
@property BOOL selectAllAtBeginEdit;
@property (strong, nonatomic) S2TableViewTextEditCellReturnPressed returnPressed;
@property (strong, nonatomic) S2TableViewTextEditCellValueChanged valueChanged;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end



/*
 *	UISwitchを持つ編集用TableViewCell
 */

@interface S2TableViewSwitchEditCell : S2TableViewCustomCell

typedef void (^S2TableViewSwitchEditCellClosure)(UISwitch* sender);

@property (strong, nonatomic) S2TableViewSwitchEditCellClosure valueChanged;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *valueSwitch;

- (IBAction)valueChanged:(id)sender;

@end



/*
 *	UISegmentedControlを持つ編集用TableViewCell
 */

@interface S2TableViewSegmentedEditCell : S2TableViewCustomCell

typedef void (^S2TableViewSegmentedEditCellClosure)(UISegmentedControl* sender);

@property (strong, nonatomic) S2TableViewSegmentedEditCellClosure valueChanged;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *valueSegmentedControl;

- (void)setValueNames:(NSArray*)valueNames;

- (IBAction)valueChanged:(id)sender;

@end



