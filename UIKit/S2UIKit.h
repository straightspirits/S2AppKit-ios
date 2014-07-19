//
//  S2UIKit.h
//  S2AppKit/S2UIKit
//
//  Created by 古川 文生 on 12/07/17.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2UIKitDefines.h"

#import "UIKit+S2AppKit.h"
#import "UIDevice+Extensions.h"
#import "S2Colors.h"
#import "S2Button.h"
#import "S2TableView.h"
#import "S2ViewController.h"
#import "S2SplitViewController.h"
#import "S2GradientButton.h"
#import "S2ListView.h"
#import "S2AppDelegate.h"



@interface S2BarButtonItem : UIBarButtonItem

+ (id)newWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
+ (id)newWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
+ (id)newWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
+ (id)newWithSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action;
+ (id)newWithCustomView:(UIView *)customView;
+ (id)newFlexibleSpace;
+ (id)newFixedSpace:(int)width;

@end



@interface S2Toolbar : UIToolbar

+ (id)new;

@property BOOL visible;

@end



@interface S2ContextToolbar : S2Toolbar

+ (id)new;

- (void)setVisible:(BOOL)visible animated:(BOOL)animated;
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

- (void)setItems:(NSArray*)items animated:(BOOL)animated;

@end



/*
 *	OKボタン付きメッセージ出力
 *	OK、キャンセルボタン付きのメッセージ出力
 *	エラー出力 (NSError)
 *	例外出力 (NSException)
 */
@interface S2AlertView : UIAlertView

typedef void (^S2AlertViewAction)();
typedef void (^S2AlertViewClosure)(S2AlertView* view, NSInteger buttonIndex);

+ (S2AlertView*)show_message:(NSString*)message;
+ (S2AlertView*)show_message:(NSString*)message closure:(S2AlertViewClosure)closure;
+ (S2AlertView*)show_title:(NSString*)title message:(NSString*)message;
+ (S2AlertView*)show_title:(NSString*)title message:(NSString*)message closure:(S2AlertViewClosure)closure;

+ (S2AlertView*)show_message:(NSString *)message cancelButton:(NSString*)cancelButton otherButton:(NSString*)otherButton closure:(S2AlertViewClosure)closure;
+ (S2AlertView*)show_title:(NSString *)title message:(NSString *)message cancelButton:(NSString*)cancelButton otherButton:(NSString*)otherButton closure:(S2AlertViewClosure)closure;

+ (S2AlertView*)showOkCancel_message:(NSString *)message closure:(S2AlertViewClosure)closure;
+ (S2AlertView*)showOkCancel_title:(NSString *)title message:(NSString *)message closure:(S2AlertViewClosure)closure;

+ (S2AlertView*)showYesNo_message:(NSString *)message closure:(S2AlertViewClosure)closure;
+ (S2AlertView*)showYesNo_title:(NSString *)title message:(NSString *)message closure:(S2AlertViewClosure)closure;

+ (S2AlertView*)show_error:(NSError*)error;
+ (S2AlertView*)show_exception:(NSException*)exception;

- (id)initOkOnly_title:(NSString *)title
				  message:(NSString *)message
				  closure:(S2AlertViewClosure)closure;

- (id)initOkCancel_title:(NSString *)title
				    message:(NSString *)message
					closure:(S2AlertViewClosure)closure;

- (id)initYesNo_title:(NSString *)title
				    message:(NSString *)message
					closure:(S2AlertViewClosure)closure;

- (id)initCancel_title:(NSString *)title
				  message:(NSString *)message
				  closure:(S2AlertViewClosure)closure;

- (id)init_title:(NSString *)title
		 message:(NSString *)message
		 closure:(S2AlertViewClosure)closure
cancelButtonTitle:(NSString *)cancelButtonTitle
otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end



/*
 *	表示時間指定のメッセージ出力
 */
@interface S2MessageView : UIAlertView

typedef void (^S2MessageViewClosed)();

+ (S2MessageView*)show_message:(NSString*)message seconds:(NSTimeInterval)seconds;
+ (S2MessageView*)show_message:(NSString*)message seconds:(NSTimeInterval)seconds completion:(S2MessageViewClosed)completion;
+ (S2MessageView*)show_title:(NSString*)title message:(NSString*)message seconds:(NSTimeInterval)seconds;
+ (S2MessageView*)show_title:(NSString*)title message:(NSString*)message seconds:(NSTimeInterval)seconds completion:(S2MessageViewClosed)completion;

- (id)init_title:(NSString *)title message:(NSString *)message;

- (void)show_seconds:(NSTimeInterval)seconds completion:(S2MessageViewClosed)completion;

@end


/*
 *	一行テキスト入力
 *	パスワード入力
 */
typedef void (^S2TextInputAlertViewInputCompletion)(BOOL done, NSString* text);

@interface S2TextInputAlertView : UIAlertView

@property (strong, readonly, nonatomic) UITextField* textField;

+ (id)new_title:(NSString *)title
		message:(NSString *)message
	 completion:(S2TextInputAlertViewInputCompletion)completion;

+ (id)new_title:(NSString *)title
		message:(NSString *)message
		  style:(UIAlertViewStyle)style
	 completion:(S2TextInputAlertViewInputCompletion)completion;

- (id)init_title:(NSString *)title
		 message:(NSString *)message
		   style:(UIAlertViewStyle)style
	  completion:(S2TextInputAlertViewInputCompletion)completion;

@end



/*
 *	アカウントとパスワード入力
 */
typedef void (^S2LoginInputAlertViewInputCompletion)(BOOL done, NSString* account, NSString* password);

@interface S2LoginInputAlertView : UIAlertView

@property (strong, readonly, nonatomic) UITextField* accountField;
@property (strong, readonly, nonatomic) UITextField* passwordField;

+ (id)new_title:(NSString *)title
		message:(NSString *)message
	 completion:(S2LoginInputAlertViewInputCompletion)completion;

- (id)init_title:(NSString *)title
		 message:(NSString *)message
	  completion:(S2LoginInputAlertViewInputCompletion)completion;

@end



typedef void (^S2ActionSheetCompletion)();
typedef void (^S2ActionSheetAction)();

@interface S2ActionSheet : UIActionSheet

+ (id)new;
+ (id)new_title:(NSString *)title;
+ (id)new_completion:(S2ActionSheetCompletion)completion;
+ (id)new_title:(NSString *)title completion:(S2ActionSheetCompletion)completion;

- (id)init_title:(NSString *)title completion:(S2ActionSheetCompletion)completion;

- (NSInteger)addButton_title:(NSString *)title action:(S2ActionSheetAction)action;
- (void)addCancelButton;
- (void)addCancelButton_title:(NSString *)title;

@end



@interface S2GradientView : UIView

+ (id)new;

@property UIColor* startColor;
@property UIColor* endColor;

- (void)setColorHue360:(int)hue360;

@end

