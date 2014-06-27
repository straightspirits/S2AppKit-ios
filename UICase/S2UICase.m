//
//  S2UICase.m
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/08.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2UICase.h"
#import "S2StringTable.h"



@interface S2UICaseNavigationBar : UINavigationBar @end

@implementation S2UICaseNavigationBar {
	S2UICase* _uicase;
}

+ (id)new:(S2UICase*)uicase;
{
	return [[self alloc] init:uicase];
}

- (id)init:(S2UICase*)uicase;
{
	if (self = [self init]) {
		_uicase = uicase;
		self.barStyle = UIBarStyleDefault;
	}
	return self;
}

- (UINavigationItem *)popNavigationItemAnimated:(BOOL)animated;
{
	return [super popNavigationItemAnimated:_uicase.enableAnimation];
}

@end



@interface S2UICase () <UINavigationBarDelegate, UIPopoverControllerDelegate>

@end

@implementation S2UICase {
	MBProgressHUD* _progressHud;
}

#pragma mark -

+ (id)new;
{
	return [self new_name:S2ClassName(self)];
}

+ (id)new_name:(NSString*)name;
{
	return [[self alloc] init_name:name];
}

- (id)init;
{
	if (self = [super init]) {
		_viewControllerStack = [NSMutableArray new];
	}
	return self;
}

- (id)init_name:(NSString*)name;
{
	S2AssertParameter(name);
	
	if (self = [self init]) {
		_container = nil;
		_name = name;
		
		// プロパティリストをロードする
		if (name) {
			NSString* plistFilepath = [[NSBundle mainBundle] pathForResource:self.name ofType:@"plist"];
			_properties = [NSDictionary dictionaryWithContentsOfFile:plistFilepath];
		}

		// ナビゲーションバーを生成する
		_navigationBar = [S2UICaseNavigationBar new:self];
		_navigationBar.delegate = self;
		_navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	}
	return self;
}

- (S2UIModel *)model;
{
	return _container.uiModel;
}

- (NSString *)storyboardName;
{
	return self.name;
}

// 遅延ローディング
- (UIViewController *)currentViewController
{
	if (!_currentViewController) {
		// プログレスHUDを準備する
		_progressHud = [[MBProgressHUD alloc] initWithView:_container.contentView];
		
		// 初期ビューコントローラーを表示する
		[self loadInitialViewController];
		S2AssertNonNil(_currentViewController);

		// ナビゲーションバーをカスタマイズする
		UIColor* tintColor = [self navigationTintColor];
		if (tintColor) {
			_navigationBar.tintColor = tintColor;
		}

		// ナビゲーションアイテムを表示する
		[self displayNavigationItem:_currentViewController animated:NO];
	}
	
	return _currentViewController;
}

- (void)setCurrentViewController:(UIViewController *)viewController
{
	[_currentViewController removeFromParentViewController];
	//[currentViewController.view removeFromSuperview];
	
	_currentViewController = viewController;
}

- (BOOL)enableAnimation;
{
	return YES;
}

- (BOOL)canSwipeGestureTransition;
{
	return YES;
}

#pragma mark -

- (void)loadInitialViewController;
{
	// ストーリーボードから初期表示ビューコントローラーを生成する
	NSString* identifier = [self propertyForKey:@"InitialViewController.identifier"];

	_currentViewController = [self loadViewController:identifier];
}

- (BOOL)isInitialViewControllerLoaded;
{
	return _currentViewController != nil;
}

- (id)loadViewController:(NSString*)identifier
{
	// ストーリーボードをロードする
	if (!_storyboard)
		_storyboard = [UIStoryboard storyboardWithName:[self storyboardName] bundle:[NSBundle mainBundle]];

	// 識別子からビューコントローラーを生成する
	UIViewController* viewController;
	if (identifier)
		viewController = [_storyboard instantiateViewControllerWithIdentifier:identifier];
	else
		viewController = [_storyboard instantiateInitialViewController];

	S2AssertNonNil(viewController);

	[self setupViewController:viewController identifier:identifier];
	
	return viewController;
}

- (void)setupViewController:(UIViewController*)viewController identifier:(NSString*)identifier
{
	// ビューのタイトルを設定する
	viewController.title = [self navigationTitle:identifier];

	// ビューの戻るボタンを設定する
	NSString* viewBarBackButtonTitle = [self navigationBackButtonTitle:identifier];
	if (viewBarBackButtonTitle) {
		UIBarButtonItem* backButton = [UIBarButtonItem new];
		backButton.title = viewBarBackButtonTitle;
		viewController.navigationItem.backBarButtonItem = backButton;
	}

	// ビューのプロンプトを設定する
	viewController.navigationItem.prompt = [self navigationPrompt:identifier];
	
	// ビューにアプレットを関連付ける
	viewController.uicase = self;
}

- (NSString*)navigationPrompt:(NSString*)viewIdentifier
{
	NSString* viewPromptStringKey = [viewIdentifier stringByAppendingString: @".prompt"];

	NSString* value = [self localizedStringForKey:viewPromptStringKey defaultValue:@"__"];
	return [value isEqualToString:@"__"] ? nil : value;
}

- (NSString*)navigationTitle:(NSString*)viewIdentifier
{
	NSString* viewTitleStringKey = [viewIdentifier stringByAppendingString: @".title"];
	
	return [self localizedStringForKey:viewTitleStringKey defaultValue:viewTitleStringKey];
}

- (NSString*)navigationBackButtonTitle:(NSString*)viewIdentifier
{
	NSString* viewBarBackButtonTitleKey = [viewIdentifier stringByAppendingString: @".barBackButton.title"];
	
	NSString* value = [self localizedStringForKey:viewBarBackButtonTitleKey];
	return value ? value : nil;
}

- (UIColor*)navigationTintColor;
{
	return nil;
}

#pragma mark - static resources

- (id)propertyForKey:(NSString*)key
{
	return [self propertyForKey:key defaultValue:nil];
}

- (id)propertyForKey:(NSString*)key defaultValue:(id)value
{
	id property = [_properties objectForKey:key];
	return property ? property : value;
}

- (NSString*)localizedStringForKey:(NSString*)key
{
	return [self localizedStringForKey:key defaultValue:nil];
}

- (NSString*)localizedStringForKey:(NSString*)key defaultValue:(NSString*)defaultValue
{
	NSString* value = S2LocalizedStringFromTable(_name, key);

	return value ? value : defaultValue;
}

#pragma mark - push/pop ViewController

- (void)pushViewController:(UIViewController*)viewController;
{
	[self pushViewController:viewController animated:self.enableAnimation];
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated
{
	viewController.view.frame = _container.contentView.bounds;

	[_container addChildViewController:viewController];
//	[_container.contentView addSubview:viewController.view];

	// init animations
	UIView* targetView = viewController.view;
	{
		CGRect frame = targetView.frame;
		frame.origin.x = frame.size.width;
		frame.origin.y = 0;
		targetView.frame = frame;
	}

	// start animations
	__weak S2UICase* _self = self;
    [_container transitionFromViewController:_currentViewController
		toViewController:viewController
		duration:animated ? 0.5 : 0.0
		options:UIViewAnimationOptionTransitionNone
		animations:^ {
			CGRect frame = targetView.frame;
			frame.origin.x = 0;
			frame.origin.y = 0;
			targetView.frame = frame;
		}
		completion:^(BOOL finished) {
			[_self pushToViewControllerStack:viewController];
		}
	];

	[self displayNavigationItem:viewController animated:animated];
}

- (void)pushToViewControllerStack:(UIViewController*)viewController;
{
	[_viewControllerStack addObject:_currentViewController];

	_currentViewController = viewController;
}

- (void)displayNavigationItem:(UIViewController*)viewController animated:(BOOL)animated
{
	UINavigationItem* navigationItem = viewController.navigationItem;
	
	[_navigationBar pushNavigationItem:navigationItem animated:animated];
}

- (UIViewController*)popViewController;
{
	return [self popViewControllerAnimated:self.enableAnimation];
}

- (UIViewController*)popViewControllerAnimated:(BOOL)animated;
{
	UIViewController* previousViewController = _viewControllerStack.lastObject;

	if (!previousViewController)
		return nil;

	self.navigationBar.delegate = nil;
	[_viewControllerStack removeLastObject];
	[self.navigationBar popNavigationItemAnimated:animated];
	self.navigationBar.delegate = self;
	
	return [self popViewController:previousViewController animated:animated];
}

- (UIViewController*)popToRootViewController;
{
	return [self popToRootViewControllerAnimated:self.enableAnimation];
}

- (UIViewController*)popAndPushViewController:(UIViewController*)viewController;
{
	UIViewController* previousViewController = [self popViewControllerAnimated:NO];
	
	if (self.enableAnimation) {
		[self performSelector:@selector(pushViewController:) withObject:viewController afterDelay:0.5];
	}
	else {
		[self pushViewController:viewController animated:self.enableAnimation];
	}
	
	return previousViewController;
}

- (UIViewController*)popToRootViewControllerAnimated:(BOOL)animated
{
	// 一つ残してpopする
	self.navigationBar.delegate = nil;
	while (_viewControllerStack.count > 1) {
		[_viewControllerStack removeLastObject];
		[self.navigationBar popNavigationItemAnimated:animated];
	}
	self.navigationBar.delegate = self;

	return [self popViewControllerAnimated:animated];
}

- (UIViewController*)popViewController:(UIViewController*)toViewController animated:(BOOL)animated
{
	S2AssertNonNil(toViewController);

	// 開いているPopoverビューを閉じる
	[self dismissPopover];
	
	toViewController.view.frame = _container.contentView.bounds;

	// アニメーションなしの場合
	if (!animated) {
		[self.container transitionFromViewController:self.currentViewController toViewController:toViewController duration:0.0 options:UIViewAnimationOptionTransitionNone animations:nil completion:nil];
		self.currentViewController = toViewController;
		return toViewController;
	}
	
	// キャプチャ画像を作成する
	UIImageView* imageView = [UIImageView new];
	imageView.frame = _currentViewController.view.bounds;
	UIGraphicsBeginImageContext(_currentViewController.view.frame.size);
	[_currentViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	imageView.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	// キャプチャ画像ビューを追加する
	imageView.layer.ZPosition = 1;
	[_container.contentView addSubview:imageView];
	
	// init animations
	UIView* targetView = imageView;
	{
		CGRect frame = targetView.frame;
		frame.origin.x = 0;
		frame.origin.y = 0;
		targetView.frame = frame;
	}
	
	// start animations
	__weak S2UICase* _self = self;
    [self.container transitionFromViewController:self.currentViewController
		toViewController:toViewController
		duration:0.5
		options:UIViewAnimationOptionTransitionNone
		animations:^ {
			// キャプチャ画像をフレームアウトさせる
			CGRect frame = targetView.frame;
			frame.origin.x = frame.size.width;
			frame.origin.y = 0;
			targetView.frame = frame;
		}
		completion:^(BOOL finished) {
			// キャプチャ画像ビューを削除する
			[imageView removeFromSuperview];

			_self.currentViewController = toViewController;
		}
	];
	
	return toViewController;
}

#pragma mark - UINavigationBarDelegate methods

// [◀戻る]ボタンが押された
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
	UIViewController* previousViewController = _viewControllerStack.lastObject;
	[_viewControllerStack removeLastObject];

	[self popViewController:previousViewController animated:self.enableAnimation];

	return YES;
}

#pragma mark - popover supports

- (void)presentPopover:(UIViewController*)viewController barButtonItem:(UIBarButtonItem*)barButtonItem permittedArrowDirections:(UIPopoverArrowDirection)directions;
{
	[self dismissPopoverAnimated:NO];
	
	UIPopoverController* popoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
	popoverController.delegate = self;
	
	// MEMO: ここでやるとviewがロードされてしまい、クラス固有のプロパティを設定する前にviewDidLoadが呼ばれてしまうため、却下
//	popoverController.popoverContentSize = viewController.view.frame.size;
	
	// popover
	[popoverController presentPopoverFromBarButtonItem:barButtonItem permittedArrowDirections:directions animated:self.enableAnimation];

	_popoverController = popoverController;
}

- (void)presentPopover:(UIViewController*)viewController view:(UIView*)view permittedArrowDirections:(UIPopoverArrowDirection)directions;
{
	[self presentPopover:viewController
								  rect:[view convertRect:view.bounds toView:view.window]
								inView:view.window
			  permittedArrowDirections:directions];
}

- (void)presentPopover:(UIViewController*)viewController rect:(CGRect)rect inView:(UIView*)view permittedArrowDirections:(UIPopoverArrowDirection)directions;
{
	[self dismissPopoverAnimated:NO];
	
	UIPopoverController* popoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
	popoverController.delegate = self;

	// MEMO: ここでやるとviewがロードされてしまい、クラス固有のプロパティを設定する前にviewDidLoadが呼ばれてしまうため、却下
//	popoverController.popoverContentSize = viewController.view.frame.size;
	
	// popover
	[popoverController presentPopoverFromRect:rect inView:view  permittedArrowDirections:directions animated:self.enableAnimation];
	
	_popoverController = popoverController;
}

- (void)presentActionSheet:(UIActionSheet*)actionSheet showFromToolbar:(UIToolbar*)toolBar;
{
	[self dismissPopoverAnimated:NO];
	
	[actionSheet showFromToolbar:toolBar];
	
	_popoverActionSheet = actionSheet;
}

- (void)presentActionSheet:(UIActionSheet*)actionSheet showFromTabBar:(UITabBar*)tabBar;
{
	[self dismissPopoverAnimated:NO];
	
	[actionSheet showFromTabBar:tabBar];
	
	_popoverActionSheet = actionSheet;
}

- (void)presentActionSheet:(UIActionSheet*)actionSheet showFromBarButtonItem:(UIBarButtonItem*)barButtonItem;
{
	[self dismissPopoverAnimated:NO];
	
	[actionSheet showFromBarButtonItem:barButtonItem animated:self.enableAnimation];
	
	_popoverActionSheet = actionSheet;
}

- (void)presentActionSheet:(UIActionSheet*)actionSheet showFromRect:(CGRect)rect inView:(UIView*)view;
{
	[self dismissPopoverAnimated:NO];
	
	[actionSheet showFromRect:rect inView:view animated:self.enableAnimation];
	
	_popoverActionSheet = actionSheet;
}

- (void)presentActionSheet:(UIActionSheet*)actionSheet inView:(UIView*)view;
{
	[self dismissPopoverAnimated:NO];
	
	[actionSheet showInView:view];
	
	_popoverActionSheet = actionSheet;
}

- (void)dismissPopoverAnimated:(BOOL)animated;
{
	if (self.popoverController) {
		[_popoverController dismissPopoverAnimated:self.enableAnimation && animated];
		_popoverController = nil;
	}
	
	if (_popoverActionSheet) {
		[_popoverActionSheet dismissWithClickedButtonIndex:_popoverActionSheet.cancelButtonIndex animated:self.enableAnimation && animated];
		_popoverActionSheet = nil;
	}
}

- (void)dismissPopover;
{
	if (self.popoverController) {
		[_popoverController dismissPopoverAnimated:self.enableAnimation];
		_popoverController = nil;
	}
	
	if (_popoverActionSheet) {
		[_popoverActionSheet dismissWithClickedButtonIndex:_popoverActionSheet.cancelButtonIndex animated:self.enableAnimation];
		_popoverActionSheet = nil;
	}
}

- (BOOL)popoverPresented
{
	return self.popoverController != nil || self.popoverActionSheet != nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
	id contentViewController = popoverController.contentViewController;

	if ([contentViewController respondsToSelector:@selector(popoverControllerShouldDismissPopover:)]) {
		return [contentViewController popoverControllerShouldDismissPopover:popoverController];
	}

	[popoverController dismissPopoverAnimated:self.enableAnimation];
	return NO;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	id contentViewController = popoverController.contentViewController;
	
	if ([contentViewController respondsToSelector:@selector(popoverControllerDidDismissPopover:)]) {
		[contentViewController popoverControllerDidDismissPopover:popoverController];
	}

	_popoverController = nil;
}

- (UIActionSheet *)popoverActionSheet
{
	return _popoverActionSheet;
}

- (void)setPopoverActionSheet:(UIActionSheet *)popoverActionSheet
{
	[self dismissPopoverAnimated:NO];

	_popoverActionSheet = popoverActionSheet;
}

#pragma mark - progress

- (void)run:(NSString*)title progressMode:(MBProgressHUDMode)progressMode execution:(dispatch_block_t)execution completion:(void (^)())completion;
{
	S2AssertNonNil(_progressHud);
	
	_progressHud.mode = progressMode;
	_progressHud.labelText = title;
	_progressHud.progress = 0.0;
	[self.container.contentView addSubview:_progressHud];
	_progressHud.removeFromSuperViewOnHide = YES;
	[_progressHud showAnimated:self.enableAnimation whileExecutingBlock:execution completionBlock:completion];
}

- (void)setProgressTitle:(NSString*)title;
{
	_progressHud.labelText = title;
}

- (void)setProgressMessage:(NSString*)message;
{
	_progressHud.detailsLabelText = message;
}

- (void)setProgressValue:(float)value;
{
	_progressHud.progress = value;
}

#pragma mark -

- (void)removeAllNotificationHandlers:(UIViewController*)controller;
{
	// 通知受け取りを解除する
	[self.model removeAllNotificationHandlers:controller];
}

@end



@implementation S2UICase (Protected)

- (void)didAttachedToContainer {}

- (void)willUICaseActivate {}

- (void)didUICaseActivate {}

- (void)updateNavigationItem:(UINavigationItem*)navigationItem {}

@end
