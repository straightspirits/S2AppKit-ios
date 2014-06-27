//
//  S2ViewController.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/08/14.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2ViewController.h"
#import "UIKit+S2AppKit.h"



@implementation UIViewController (S2UIKit)

+ (NSString *)identifier
{
	NSString* identifier = NSStringFromClass(self.class);
	
	// クラス名から末尾の"Controller"を削る
	return S2StringRemoveSuffix(identifier, @"Controller");
}

- (NSString *)identifier;
{
	return [self.class identifier];
}

- (void)initializeInstance {}

- (void)initializeObservers {}

- (void)installKeyboardVisibilityNotificationObserver;
{
	NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
	
    // キーボード表示時
    [notificationCenter addObserver:self selector:@selector(keyboardWillShow:)
							   name: UIKeyboardWillShowNotification object:nil];
    // キーボード非表示時
	[notificationCenter addObserver:self selector:@selector(keyboardWillHide:)
							   name: UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotificationObserver;
{
	// デフォルト通知センターからの通知を解除する
	// ex) keyboard
	NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter removeObserver:self];
}

- (CGFloat)baseTopOnKeyboardShowing;
{
	return self.view.y;
}

- (void)keyboardWillShow:(NSNotification*)notification;
{
	NSNumber* duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	
	// キーボードに合わせたアニメーション処理
	[UIView animateWithDuration:duration ? duration.doubleValue : 0.25
					 animations: ^{
						 self.view.y = -self.baseTopOnKeyboardShowing;
					 }
	 ];
}

- (void)keyboardWillHide:(NSNotification*)notification;
{
	NSNumber* duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	
	// キーボードに合わせたアニメーション処理
	[UIView animateWithDuration:duration ? duration.doubleValue : 0.25
					 animations: ^{
						 self.view.y = 0;
					 }
	 ];
}

- (UIView*)nextResponder:(UIView*)view;
{
	NSInteger nextTag = 1;
	if (view) {
		nextTag = view.tag + 1;
	}
	
	return [self.view viewWithTag:nextTag];
}

//- (UIView*)nextResponder:(UIView*)view;
//{
//	BOOL targetIsFounded = view ? NO : YES;
//
//	return [self nextResponder:self.view target:view :&targetIsFounded];
//}

- (UIView*)nextResponder:(UIView *)baseView target:(UIView*)target :(BOOL*)targetIsFounded;
{
	for (UIView* subview in baseView.subviews) {
		UIView* foundedView = [self nextResponder:subview target:target :targetIsFounded];
		if (foundedView)
			return foundedView;
	}
	
	if (!*targetIsFounded) {
		if (baseView == target) {
			*targetIsFounded = YES;
		}
	}
	else {
		if (baseView.canBecomeFirstResponder) {
			return baseView;
		}
	}
	
	return nil;
}

@end



@implementation S2ViewController

+ (id)new;
{
	return [[self alloc] init];
}

+ (id)new_nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
	return [[self alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

// override
- (id)init;
{
	if (self = [super init]) {
		[self initializeInstance];
	}
	return self;
}

// override
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self initializeInstance];
	}
	return self;
}

@end
