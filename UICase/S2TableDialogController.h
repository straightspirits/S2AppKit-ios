//
//  S2TableDialogController.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/04.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2ViewControllers.h"
#import "S2TableViewRowCollection.h"



@interface S2TableEditableViewController : S2TableViewController

+ (id)new_uicase:(S2UICase*)uicase editMode:(BOOL)editMode;

@property BOOL editMode;
@property BOOL editOnActivate;

@property (readonly) NSArray* tableSections;

- (void)didReturnKeyPressed:(UIView*)sender;

@end



/*
 *	テーブルビューベースの編集可能ダイアログ
 *		スタイルはPlain
 */
typedef void (^S2DialogDismissed)();
typedef void (^S2DialogCompletion)(id newItem);

@interface S2TableDialogController : S2TableEditableViewController

+ (id)new_uicase:(S2UICase*)uicase;

- (id)targetItem;

- (void)showItem:(UIViewController*)superViewController dismissed:(S2DialogDismissed)dismissed;
//- (void)showItem:(UIViewController*)superViewController animated:(BOOL)animated dismissed:(S2DialogDismissed)dismissed;
- (void)editItem:(UIViewController*)superViewController completion:(S2DialogCompletion)completion dismissed:(S2DialogDismissed)dismissed;
//- (void)editItem:(UIViewController*)superViewController animated:(BOOL)animated completion:(S2DialogCompletion)completion dismissed:(S2DialogDismissed)dismissed;

- (void)didReturnKeyPressed:(UIView*)sender;
- (void)doneButtonPressed:(id)sender;
- (void)cancelButtonPressed:(id)sender;

- (BOOL)validateInput;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
