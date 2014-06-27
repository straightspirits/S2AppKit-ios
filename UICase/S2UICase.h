//
//  S2UICase.h
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/08.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2UIKit.h"
#import "S2UIModel.h"
#import "S2UICaseContainer.h"
#import "UIViewController+UICase.h"
#import "MBProgressHUD.h"



@interface S2UICase : NSObject {
	@package
	S2UICaseContainer* _container;
	NSString* _name;
	NSDictionary* _properties;
	UIStoryboard* _storyboard;
	UIViewController* _currentViewController;
	NSMutableArray* _viewControllerStack;
	__weak UIActionSheet* _popoverActionSheet;
}

+ (id)new;
+ (id)new_name:(NSString*)name;
- (id)init_name:(NSString*)name;

@property (readonly) NSString* name;
@property (readonly) S2UIModel* model;
@property (readonly) S2UICaseContainer* container;
@property (readonly) UIStoryboard* storyboard;
@property (readonly) NSString* storyboardName;
@property (readonly) UINavigationBar* navigationBar;
@property UIViewController* currentViewController;
@property (readonly) UIPopoverController* popoverController;
@property (readonly) UIActionSheet* popoverActionSheet;
@property (readonly) BOOL enableAnimation;
@property (readonly) BOOL canSwipeGestureTransition;

- (void)loadInitialViewController;
- (BOOL)isInitialViewControllerLoaded;

- (id)loadViewController:(NSString*)identifier;
- (void)setupViewController:(UIViewController*)viewController identifier:(NSString*)identifier;

- (NSString*)navigationPrompt:(NSString*)viewIdentifier;
- (NSString*)navigationTitle:(NSString*)viewIdentifier;
- (NSString*)navigationBackButtonTitle:(NSString*)viewIdentifier;
- (UIColor*)navigationTintColor;

- (id)propertyForKey:(NSString*)key;
- (id)propertyForKey:(NSString*)key defaultValue:(id)value;

- (NSString*)localizedStringForKey:(NSString*)key;
- (NSString*)localizedStringForKey:(NSString*)key defaultValue:(NSString*)value;

- (void)pushViewController:(UIViewController*)viewController;
- (UIViewController*)popViewController;
- (UIViewController*)popToRootViewController;
- (UIViewController*)popAndPushViewController:(UIViewController*)viewController;

- (void)presentPopover:(UIViewController*)viewController barButtonItem:(UIBarButtonItem*)barButtonItem permittedArrowDirections:(UIPopoverArrowDirection)direction;
- (void)presentPopover:(UIViewController*)viewController view:(UIView*)view permittedArrowDirections:(UIPopoverArrowDirection)directions;
- (void)presentPopover:(UIViewController*)viewController rect:(CGRect)rect inView:(UIView*)view permittedArrowDirections:(UIPopoverArrowDirection)direction;
- (void)presentActionSheet:(UIActionSheet*)actionSheet showFromToolbar:(UIToolbar*)toolBar;
- (void)presentActionSheet:(UIActionSheet*)actionSheet showFromTabBar:(UITabBar*)tabBar;
- (void)presentActionSheet:(UIActionSheet*)actionSheet showFromBarButtonItem:(UIBarButtonItem*)barButtonItem;
- (void)presentActionSheet:(UIActionSheet*)actionSheet showFromRect:(CGRect)rect inView:(UIView*)view;
- (void)presentActionSheet:(UIActionSheet*)actionSheet inView:(UIView*)view;
- (void)dismissPopover;
- (BOOL)popoverPresented;

- (void)run:(NSString*)title progressMode:(MBProgressHUDMode)progressMode execution:(dispatch_block_t)execution completion:(void (^)())completion;
- (void)setProgressTitle:(NSString*)title;
- (void)setProgressMessage:(NSString*)message;
- (void)setProgressValue:(float)value;		// 0.0 to 1.0

- (void)removeAllNotificationHandlers:(UIViewController*)controller;

@end



@interface S2UICase (Protected)

- (void)didAttachedToContainer;
- (void)willUICaseActivate;
- (void)didUICaseActivate;

- (void)updateNavigationItem:(UINavigationItem*)navigationItem;

@end
