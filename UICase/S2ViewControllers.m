//
//  S2ViewControllers.m
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/11.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2ViewControllers.h"



@implementation S2ViewController (S2UICase)

+ (id)new_uicase:(S2UICase*)uicase;
{
	return [[self alloc] init_uicase:uicase];
}

+ (id)new_uicase:(S2UICase*)uicase nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
	return [[self alloc] init_uicase:uicase nibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (id)init_uicase:(S2UICase*)uicase;
{
	if (self = [self init]) {
		[self initializeInstance];
		[uicase setupViewController:self identifier:self.identifier];
	}
	return self;
}

- (id)init_uicase:(S2UICase*)uicase nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
	if (self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		[self initializeInstance];
		[uicase setupViewController:self identifier:self.identifier];
	}
	return self;
}

- (void)dealloc;
{
	// 通知受け取りを解除する
	[self removeNotificationObserver];
	[self.uicase removeAllNotificationHandlers:self];
}

// override
- (void)awakeFromNib;
{
	[super awakeFromNib];
	[self initializeInstance];
}

// override
/*
- (void)loadView;
{
	[super loadView];
	
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.autoresizesSubviews = YES;
}
*/

// override
- (void)viewDidLoad;
{
	[self initializeObservers];

	[super viewDidLoad];

	// MEMO: nibで定義したUIを使う場合に必要
	if (!self.storyboard) {
		self.contentSizeForViewInPopover = self.view.frame.size;
	}
}

@end



@implementation S2TableViewController

+ (id)new_uicase:(S2UICase*)uicase style:(UITableViewStyle)style;
{
	return [[self alloc] init_uicase:uicase style:style];
}

- (id)init_uicase:(S2UICase*)uicase style:(UITableViewStyle)style;
{
	if (self = [self initWithStyle:style]) {
		[self initializeInstance];
		[uicase setupViewController:self identifier:self.identifier];
	}
	return self;
}

- (void)dealloc;
{
	// 通知受け取りを解除する
	[self removeNotificationObserver];
	[self.uicase removeAllNotificationHandlers:self];
}

- (void)awakeFromNib;
{
	[super awakeFromNib];
	[self initializeInstance];
}

- (void)viewDidLoad;
{
	[self initializeObservers];

    [super viewDidLoad];
}

@end



@implementation S2TabBarController

- (void)dealloc;
{
	// 通知受け取りを解除する
	[self removeNotificationObserver];
	[self.uicase removeAllNotificationHandlers:self];
}

- (void)awakeFromNib;
{
	[super awakeFromNib];
	[self initializeInstance];
}

- (void)viewDidLoad;
{
	[self initializeObservers];

    [super viewDidLoad];
	
	for (UIViewController* controller in self.viewControllers) {
		controller.uicase = self.uicase;
	}
}

@end



@implementation S2NavigationController

+ (id)new_rootViewController:(S2ViewController*)rootViewController;
{
	return [[self alloc] initWithRootViewController:rootViewController];
}

// override
- (id)initWithRootViewController:(UIViewController *)rootViewController;
{
	if (self = [super initWithRootViewController:rootViewController]) {
		// 初期値y=20になっている(iOS5.1, 6.0)
		self.navigationBar.y = 0;
		self.transitAnimation = YES;

		[self initializeInstance];
	}
	return self;
}

- (void)dealloc;
{
	// 通知受け取りを解除する
	[self removeNotificationObserver];
	[self.uicase removeAllNotificationHandlers:self];
}

- (void)awakeFromNib;
{
	[super awakeFromNib];
	[self initializeInstance];
}

- (void)viewDidLoad;
{
	[self initializeObservers];
	
	[super viewDidLoad];
	
	self.topViewController.uicase = self.uicase;
}

// override
- (void)setTitle:(NSString *)title;
{
	[super setTitle:title];
	
	self.topViewController.title = title;
}

// override
- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
{
	return [super popViewControllerAnimated:animated && self.transitAnimation];
}

@end



@implementation S2SplitViewController (S2UICase)

- (void)dealloc;
{
	// 通知受け取りを解除する
	[self removeNotificationObserver];
	[self.uicase removeAllNotificationHandlers:self];
}

- (void)awakeFromNib;
{
	[super awakeFromNib];

	self.delegate = self;
	
	[self initializeInstance];
}

- (void)viewDidLoad;
{
	for (UIViewController* controller in self.viewControllers) {
		controller.uicase = self.uicase;
	}

	[self initializeObservers];

    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
	else {
		return YES;
	}
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation;
{
	return NO;
}

@end



@implementation S2NavigationDialogController

// MEMO: [UITextField resignFirstResponder] でキーボードを閉じるようにするおまじない
- (BOOL)disablesAutomaticKeyboardDismissal;
{
	return NO;
}

@end
