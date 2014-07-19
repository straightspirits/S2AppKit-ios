//
//  S2UIKit.m
//  S2AppKit/S2UIKit
//
//  Created by 古川 文生 on 12/07/17.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2UIKit.h"



@implementation S2UIKit

#define DEFAULT_VALUE	@"__"

+ (NSString*)localizedStringForKey:(NSString*)key
{
	return [self localizedStringForKey:key defaultValue:key];
}

+ (NSString*)localizedStringForKey:(NSString*)key defaultValue:(NSString *)defaultValue
{
	NSString* value;
	
	value = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] localizedStringForKey:key value:DEFAULT_VALUE table:nil];
	if (![value isEqualToString:DEFAULT_VALUE]) {
		return value;
	}
	
	value = [[NSBundle mainBundle] localizedStringForKey:key value:DEFAULT_VALUE table:nil];
	if (![value isEqualToString:DEFAULT_VALUE]) {
		return value;
	}
	
	return defaultValue;
}

@end



@implementation S2BarButtonItem

+ (id)newWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
{
	return [[self alloc] initWithImage:image style:style target:target action:action];
}

+ (id)newWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
{
	return [[self alloc] initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:target action:action];
}

+ (id)newWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
{
	return [[self alloc] initWithTitle:title style:style target:target action:action];
}

+ (id)newWithSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action;
{
	return [[self alloc] initWithBarButtonSystemItem:systemItem target:target action:action];
}

+ (id)newWithCustomView:(UIView *)customView;
{
	return [[self alloc] initWithCustomView:customView];
}

+ (id)newFlexibleSpace;
{
	return [[self alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

+ (id)newFixedSpace:(int)width;
{
	S2BarButtonItem* item = [[self alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	
	item.width = width;
	
	return item;
}

@end



@implementation S2Toolbar

+ (id)new;
{
	S2Toolbar* instance = [[super alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];

	return instance;
}

- (id)initWithFrame:(CGRect)frame;
{
	if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	}
	return self;
}

- (void)layoutSubviews
{
	self.width = self.superview.width;
	
	[super layoutSubviews];
}

- (BOOL)visible;
{
	return !self.hidden;
}

- (void)setVisible:(BOOL)visible;
{
	[self setHidden:!visible];
}

@end



@implementation S2ContextToolbar

+ (id)new;
{
	return [super new];
}

- (id)initWithFrame:(CGRect)frame;
{
	if (self = [super initWithFrame:frame]) {
		self.hidden = YES;
	}
	return self;
}

- (void)setVisible:(BOOL)visible animated:(BOOL)animated;
{
	[self setHidden:!visible animated:animated];
}

// ツールバーをアニメーションしながら表示する
- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;
{
	if (self.hidden == hidden) {
		return;
	}

	// アニメーションなし
	if (!animated) {
		if (!hidden) {
			self.y = self.superview.height - self.height;
		}
		self.hidden = hidden;
		return;
	}

	// アニメーションあり
		
	if (!hidden) {
		self.y = self.superview.height;
		self.hidden = NO;
		[self.superview bringSubviewToFront:self];
	}
	
	[UIView animateWithDuration:0.3
		animations:^{
			if (!hidden)
				self.y -= self.height;
			else
				self.y += self.height;
		}
		completion:^(BOOL finished) {
			if (hidden)
				self.hidden = YES;
		}
	];
}

- (void)setItems:(NSArray*)items animated:(BOOL)animated;
{
	if (self.visible && animated) {
		[UIView animateWithDuration:0.3
			 animations:^{
				 self.y += self.height;
			 }
			 completion:^(BOOL finished) {
				 self.hidden = YES;
				 [super setItems:items animated:animated];
				 [self setHidden:NO animated:YES];
			 }
		 ];
	}
	else {
		[super setItems:items animated:animated];
	}
}

@end



@interface S2AlertView () <UIAlertViewDelegate>

@end

@implementation S2AlertView {
	int _firstOtherButtonIndex;
	S2AlertViewClosure _closure;
}

+ (S2AlertView*)show_message:(NSString*)message;
{
	S2AlertView* view = [[self alloc] initOkOnly_title:nil message:message closure:nil];
	
	[view show];
	
	return view;
}

+ (S2AlertView*)show_message:(NSString *)message closure:(S2AlertViewClosure)closure;
{
	S2AlertView* view = [[self alloc] initOkOnly_title:nil message:message closure:closure];
	
	[view show];
	
	return view;
}

+ (S2AlertView*)show_title:(NSString *)title
				   message:(NSString *)message
{
	S2AlertView* view = [[self alloc] initOkOnly_title:title message:message closure:nil];
	
	[view show];
	
	return view;
}

+ (S2AlertView*)show_title:(NSString *)title
				   message:(NSString *)message
				   closure:(S2AlertViewClosure)closure;
{
	S2AlertView* view = [[self alloc] initOkOnly_title:title message:message closure:closure];
	
	[view show];
	
	return view;
}

+ (S2AlertView*)show_message:(NSString *)message cancelButton:(NSString*)cancelButton otherButton:(NSString*)otherButton closure:(S2AlertViewClosure)closure;
{
	S2AlertView* view =  [[self alloc] init_title:nil message:message closure:closure cancelButtonTitle:cancelButton otherButtonTitles:otherButton, nil];

	[view show];
	
	return view;
}

+ (S2AlertView*)show_title:(NSString *)title message:(NSString *)message cancelButton:(NSString*)cancelButton otherButton:(NSString*)otherButton closure:(S2AlertViewClosure)closure;
{
	S2AlertView* view =  [[self alloc] init_title:title message:message closure:closure cancelButtonTitle:cancelButton otherButtonTitles:otherButton, nil];

	[view show];
	
	return view;
}

+ (S2AlertView*)showOkCancel_message:(NSString *)message
							 closure:(S2AlertViewClosure)closure;
{
	S2AlertView* view = [[self alloc] initOkCancel_title:nil message:message closure:closure];
	
	[view show];
	
	return view;
}

+ (S2AlertView*)showOkCancel_title:(NSString *)title
						   message:(NSString *)message
						   closure:(S2AlertViewClosure)closure;
{
	S2AlertView* view = [[self alloc] initOkCancel_title:title message:message closure:closure];
	
	[view show];
	
	return view;
}

+ (S2AlertView*)showYesNo_message:(NSString *)message
						  closure:(S2AlertViewClosure)closure;
{
	S2AlertView* view = [[self alloc] initYesNo_title:nil message:message closure:closure];
	
	[view show];
	
	return view;
}

+ (S2AlertView*)showYesNo_title:(NSString *)title
						message:(NSString *)message
						closure:(S2AlertViewClosure)closure;
{
	S2AlertView* view = [[self alloc] initYesNo_title:title message:message closure:closure];
	
	[view show];
	
	return view;
}


+ (S2AlertView*)show_error:(NSError *)error;
{
	NSString* title;
	NSString* message;
	
	if (error.localizedFailureReason.length != 0) {
		title = error.localizedDescription;
		message = error.localizedFailureReason;
	}
	else {
		title = [NSString stringWithFormat:@"%@:%ld", error.domain, (long)error.code];
		message = error.localizedDescription;
	}
	
	S2AlertView* view = [[self alloc] initOkOnly_title:title message:message closure:nil];
	
	[view show];
	
	return view;
}

+ (S2AlertView*)show_exception:(NSException *)exception;
{
	S2AlertView* view = [[self alloc] initOkOnly_title:exception.name message:exception.reason closure:nil];

	[view show];
	
	return view;
}

- (id)initOkOnly_title:(NSString *)title
			   message:(NSString *)message
			   closure:(S2AlertViewClosure)closure;
{
	return [self init_title:title message:message closure:closure cancelButtonTitle:[S2UIKit localizedStringForKey:@"OK"] otherButtonTitles:nil];
}

- (id)initOkCancel_title:(NSString *)title
				 message:(NSString *)message
				 closure:(S2AlertViewClosure)closure;
{
	return [self init_title:title message:message closure:closure cancelButtonTitle:[S2UIKit localizedStringForKey:@"Cancel"] otherButtonTitles:[S2UIKit localizedStringForKey:@"OK"], nil];
}

- (id)initYesNo_title:(NSString *)title
			  message:(NSString *)message
			  closure:(S2AlertViewClosure)closure;
{
	return [self init_title:title message:message closure:closure cancelButtonTitle:[S2UIKit localizedStringForKey:@"No"] otherButtonTitles:[S2UIKit localizedStringForKey:@"Yes"], nil];
}

- (id)initCancel_title:(NSString *)title message:(NSString *)message closure:(S2AlertViewClosure)closure
{
	return [self init_title:title message:message closure:closure cancelButtonTitle:[S2UIKit localizedStringForKey:@"Cancel"] otherButtonTitles:nil];
}

- (id)init_title:(NSString *)title message:(NSString *)message closure:(S2AlertViewClosure)closure cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
	self = [super initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	
	if (self) {
		// MEMO キャンセルボタンの追加時にaddButtonWithTitle:が呼ばれるため、initで初期化しても意味がなかった
		_firstOtherButtonIndex = -1;

		// otherButtonTitles, ... を手動でセット
		va_list args;
		va_start(args, otherButtonTitles);
		for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*)) {
			[self addButtonWithTitle:arg];
		}
		va_end(args);

		self.delegate = self;

		_closure = closure;
	}
	
	return self;
}

- (NSInteger)firstOtherButtonIndex;
{
	return _firstOtherButtonIndex;
}

- (NSInteger)addButtonWithTitle:(NSString *)title;
{
	NSInteger buttonIndex = [super addButtonWithTitle:title];
	
	if (_firstOtherButtonIndex == -1)
		_firstOtherButtonIndex = (int)buttonIndex;
	
	return buttonIndex;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (_closure) {
		_closure(self, buttonIndex);
	}
}

//- (void)alertViewCancel:(UIAlertView *)alertView;
//{
//	
//}

//- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;
//{
//	return YES;
//}

@end



@interface S2MessageView () <UIAlertViewDelegate>

@end

@implementation S2MessageView {
}

+ (S2MessageView*)show_message:(NSString*)message seconds:(NSTimeInterval)seconds;
{
	S2MessageView* view = [[self alloc] init_title:nil message:message];
	
	[view show_seconds:seconds completion:nil];
	
	return view;
}

+ (S2MessageView*)show_message:(NSString*)message seconds:(NSTimeInterval)seconds completion:(S2MessageViewClosed)completion;
{
	S2MessageView* view = [[self alloc] init_title:nil message:message];
	
	[view show_seconds:seconds completion:completion];
	
	return view;
}

+ (S2MessageView*)show_title:(NSString*)title message:(NSString*)message seconds:(NSTimeInterval)seconds;
{
	S2MessageView* view = [[self alloc] init_title:title message:message];
	
	[view show_seconds:seconds completion:nil];
	
	return view;
}

+ (S2MessageView*)show_title:(NSString*)title message:(NSString*)message seconds:(NSTimeInterval)seconds completion:(S2MessageViewClosed)completion;
{
	S2MessageView* view = [[self alloc] init_title:title message:message];
	
	[view show_seconds:seconds completion:completion];
	
	return view;
}

- (id)init_title:(NSString *)title message:(NSString *)message
{
	return [super initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
}

- (void)show_seconds:(NSTimeInterval)seconds completion:(S2MessageViewClosed)completion
{
	[NSTimer scheduledTimerWithTimeInterval:seconds
                                     target:self
                                   selector:@selector(doDismiss:)
                                   userInfo:completion
									repeats:NO];
	[self show];
}

- (void)doDismiss:(NSTimer*)sender
{
	[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
	
	S2MessageViewClosed completion = sender.userInfo;
	if (completion)
		completion();
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
	// ボタン分の高さを引く
	self.height -= 50;
}

@end



@interface S2TextInputAlertView () <UIAlertViewDelegate, UITextFieldDelegate>

@end

@implementation S2TextInputAlertView {
	S2TextInputAlertViewInputCompletion _completion;
}

+ (id)new_title:(NSString *)title message:(NSString *)message completion:(S2TextInputAlertViewInputCompletion)completion;
{
	return [[self alloc] init_title:title message:message style:UIAlertViewStylePlainTextInput completion:completion];
}

+ (id)new_title:(NSString *)title message:(NSString *)message style:(UIAlertViewStyle)style completion:(S2TextInputAlertViewInputCompletion)completion;
{
	return [[self alloc] init_title:title message:message style:style completion:completion];
}

- (UITextField *)textField
{
	return [self textFieldAtIndex:0];
}

- (id)init_title:(NSString *)title message:(NSString*)message style:(UIAlertViewStyle)style completion:(S2TextInputAlertViewInputCompletion)completion
{
	if (self = [super initWithTitle:title
							message:message
						   delegate:self
				  cancelButtonTitle:[S2UIKit localizedStringForKey:@"Cancel"]
				  otherButtonTitles:[S2UIKit localizedStringForKey:@"OK"], nil]) {
		// delegateを設定する
		self.delegate = self;
		
		self.alertViewStyle = style;
		
		UITextField* tf = self.textField;
		tf.returnKeyType = UIReturnKeyDone;
		tf.enablesReturnKeyAutomatically = YES;
		tf.delegate = self;
		
		_completion = completion;
	}
	return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.firstOtherButtonIndex) {
		if (_completion) {
			_completion(YES, self.textField.text);
		}
	}
	else if (buttonIndex == alertView.cancelButtonIndex) {
		if (_completion) {
			_completion(NO, nil);
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.textField resignFirstResponder];
	
	[self alertView:self clickedButtonAtIndex:self.firstOtherButtonIndex];
	
	[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];

	return YES;
}

@end



@interface S2LoginInputAlertView () <UIAlertViewDelegate, UITextFieldDelegate>

@end

@implementation S2LoginInputAlertView {
	S2LoginInputAlertViewInputCompletion _completion;
}

+ (id)new_title:(NSString *)title
		message:(NSString *)message
	 completion:(S2LoginInputAlertViewInputCompletion)completion;
{
	return [[self alloc] init_title:title message:message completion:completion];
}

- (id)init_title:(NSString *)title
		 message:(NSString *)message
	  completion:(S2LoginInputAlertViewInputCompletion)completion;
{
	if (self = [super initWithTitle:title
							message:message
						   delegate:self
				  cancelButtonTitle:[S2UIKit localizedStringForKey:@"Cancel"]
				  otherButtonTitles:[S2UIKit localizedStringForKey:@"OK"], nil]) {
		// delegateを設定する
		self.delegate = self;
		
		self.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
		
		self.passwordField.returnKeyType = UIReturnKeyNext;
		self.accountField.enablesReturnKeyAutomatically = YES;
		self.accountField.delegate = self;
		self.passwordField.returnKeyType = UIReturnKeyJoin;
		self.passwordField.enablesReturnKeyAutomatically = YES;
		self.passwordField.delegate = self;

		_completion = completion;
	}
	return self;
}

- (UITextField *)accountField;
{
	return [self textFieldAtIndex:0];
}

- (UITextField *)passwordField;
{
	return [self textFieldAtIndex:1];
}

// 子要素がついてかない
//- (void)willPresentAlertView:(UIAlertView *)alertView
//{
//	// 幅広くする
//	self.width += 100;
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.firstOtherButtonIndex) {
		if (_completion) {
			_completion(YES, self.accountField.text, self.passwordField.text);
		}
	}
	else if (buttonIndex == alertView.cancelButtonIndex) {
		if (_completion) {
			_completion(NO, nil, nil);
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.accountField) {
		if (textField.text.length == 0)
			return NO;
		// 明示的にフォーカスを当てず、このまま流すとうまく動作する
		//[self.passwordField becomeFirstResponder];
	}
	else if (textField == self.passwordField) {
		[self alertView:self clickedButtonAtIndex:self.firstOtherButtonIndex];
		
		[self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
	}
	
	return YES;
}

@end



@interface S2ActionSheet () <UIActionSheetDelegate>

@end

@implementation S2ActionSheet {
	S2ActionSheetCompletion _completion;
	NSMutableArray* _actions;
}

+ (id)new;
{
	return [[self alloc] init_title:nil completion:nil];
}

+ (id)new_title:(NSString *)title;
{
	return [[self alloc] init_title:title completion:nil];
}

+ (id)new_completion:(S2ActionSheetCompletion)completion;
{
	return [[self alloc] init_title:nil completion:completion];
}

+ (id)new_title:(NSString *)title completion:(S2ActionSheetCompletion)completion;
{
	return [[self alloc] init_title:title completion:completion];
}

+ (id)new_delegate:(id<UIActionSheetDelegate>)delegate;
{
	return [[self alloc] init_title:nil delegate:delegate];
}

+ (id)new_title:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate;
{
	return [[self alloc] init_title:title delegate:delegate];
}

- (id)init_title:(NSString *)title completion:(S2ActionSheetCompletion)completion;
{
	if (self = [self init_title:title delegate:self]) {
		_completion = completion;
		_actions = [NSMutableArray new];
	}
	return self;
}

- (id)init_title:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate;
{
	if (self = [super initWithTitle:title delegate:delegate cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]) {
		
	}
	return self;
}

S2_DEALLOC_LOGGING_IMPLEMENT

// override
- (NSInteger)addButtonWithTitle:(NSString *)title;
{
	return [self addButton_title:title action:nil];
}

- (NSInteger)addButton_title:(NSString *)title;
{
	return [self addButton_title:title action:nil];
}

- (NSInteger)addButton_title:(NSString *)title action:(S2ActionSheetAction)action;
{
	NSInteger buttonIndex = [super addButtonWithTitle:title];
	
	for (NSInteger index = _actions.count; index < buttonIndex; ++index) {
		[_actions addObject:NSNull.null];
	}

	[_actions addObject:action ? (id)action : NSNull.null];
	
	return buttonIndex;
}

- (void)addCancelButton;
{
	[self addCancelButton_title:[S2UIKit localizedStringForKey:@"Cancel"]];
}

- (void)addCancelButton_title:(NSString *)title;
{
	self.cancelButtonIndex = [self addButton_title:title];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
	if (buttonIndex >= 0) {
		S2ActionSheetAction action = _actions[buttonIndex];
	
		if (action) {
			action();
		}
	}

	if (_completion) {
		_completion();
	}
}

@end



/*
 *	グラデーションビュー
 */
@implementation S2GradientView

+ (id)new
{
	S2GradientView* instance = [super new];
	
	// MEMO iOS5のナビゲーションバーのグラデーションを再現（不完全）
	instance.startColor = S2HsbColor(225, 0, 100);
	instance.endColor = S2HsbColor(225, 9, 71);
	
	return instance;
}

- (void)setColorHue360:(int)hue360;
{
	self.startColor = [self.startColor colorWithHue360:hue360];
	self.endColor = [self.endColor colorWithHue360:hue360];
}

- (void)drawRect:(CGRect)rect;
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGGradientRef gradient = [self createGradient:colorSpace];

	CGPoint startPoint = {0.0, 0.0};
	CGPoint endPoint = {0.0, self.height};
	CGContextDrawLinearGradient(context,
                                gradient,
                                startPoint,
                                endPoint,
                                0);

	CGGradientRelease(gradient);
	
	CGColorSpaceRelease(colorSpace);
}

- (CGGradientRef)createGradient:(CGColorSpaceRef)colorSpace
{
	NSArray* colors = @[(id)self.startColor.CGColor, (id)self.endColor.CGColor];
	
	CGFloat locations[] = {0.0, 1.0};
	
	return CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
}

@end



