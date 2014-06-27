//
//  S2ViewController.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/08/14.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2UIKitDefines.h"



@interface UIViewController (S2UIKit)

// クラスの識別子
// 	クラス名末尾の'Controller'を削除したものを返す。
// 	ローカライズ文字列のキー、ストーリーボードのオブジェクト識別子として使われる。
+ (NSString*)identifier;

@property (readonly) NSString* identifier;

// テンプレートメソッド
- (void)initializeInstance;
- (void)initializeObservers;

// 通知受け取り
- (void)installKeyboardVisibilityNotificationObserver;
- (void)removeNotificationObserver;

// キーボード
- (CGFloat)baseTopOnKeyboardShowing;	// default is self.view.y
- (void)keyboardWillShow:(NSNotification*)notificationUserInfo;
- (void)keyboardWillHide:(NSNotification*)notificationUserInfo;

- (UIView*)nextResponder:(UIView*)view;

@end



@interface S2ViewController : UIViewController

+ (id)new;
+ (id)new_nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
