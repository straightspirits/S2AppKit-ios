//
//  S2UICaseContainer.m
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/06/30.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2UICaseContainer.h"
#import "S2UICase.h"



// プライベートインターフェースの定義
@interface S2UICaseContainer () <UIGestureRecognizerDelegate>

@end

// インターフェースの実装
@implementation S2UICaseContainer {
@package
    NSArray* _uicases;
	BOOL _worldStarted;
	S2UICase* _initialUICase;
    S2UICase* _currentUICase;

	BOOL _bannerIsVisible;
}

#pragma mark -

- (void)initializeInstance;
{
	_startupAnimation = YES;
#ifdef DEBUG
	_startupAnimation = NO;
#endif
	_transitionMode = S2UICaseContainerTransitionNormal;
	_userDefaults = [NSUserDefaults standardUserDefaults];
	
	// ユーザーデフォルトの変更を検知した時に通知するよう依頼する
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserDefaultChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
}

#pragma mark -

- (UINavigationBar *)titleBar;
{
	return nil;
}

- (UIView *)contentView;
{
	return self.view;
}

- (void)setupUICases:(NSArray *)uicases initialUICaseName:(NSString *)uicaseName privateSettings:(NSDictionary *)privateSettings;
{
	// 開始アプレットのインデックスを探す
	S2UICase* initialUICase = nil;
	for (S2UICase* uicase in uicases) {
		if ([uicase.name isEqualToString:uicaseName]) {
			initialUICase = uicase;
		}
	}
	if (!initialUICase) {
		S2LogWarning(nil, S2ClassTag, @"uicase '%@' not found.", uicaseName);
		initialUICase = uicases[0];
	}
	
	[self setupUICases:uicases initialUICase:initialUICase privateSettings:privateSettings];
}

- (void)setupUICases:(NSArray *)uicases initialUICase:(S2UICase *)uicase privateSettings:(NSDictionary *)privateSettings;
{
	[self loadUserDefaults:self.userDefaults];

	_uiModel = [S2UIModel new:privateSettings];
	_uicases = uicases;
	_initialUICase = uicase;
	_currentUICase = nil;	// viewDidLoad〜transitionStartAppletで設定される
	
	for (S2UICase* uicase in uicases) {
		// コンテナを設定する
		uicase->_container = self;

		// 通知する
		[uicase didAttachedToContainer];
	}
}

- (void)loadUserDefaults:(NSUserDefaults*)userDefaults;
{
	// override
	return;
}

/*
 *	ユーザーデフォルトの変更を検知した
 *	MEMO どのキーが変更されたかまではわからない。
 */
- (void)didUserDefaultChanged:(NSNotification*)sender;
{
//	S2LogPass(nil, @"UserDefault changed: userInfo=%@", sender.userInfo);
	
	[self loadUserDefaults:self.userDefaults];
}

- (S2UICase*)uicaseByName:(NSString*)uicaseName;
{
	for (S2UICase* uicase in _uicases) {
		if ([uicase.name isEqualToString:uicaseName]) {
			return uicase;
		}
	}
	
	return nil;
}

#pragma mark - 

- (void)viewWillLayoutSubviews;
{
	[super viewWillLayoutSubviews];
	
	for (UIView* appletContentPane in self.contentView.subviews) {
		appletContentPane.frame = self.contentView.bounds;
	}
}

// MEMO: 表示完了のタイミングで子ビューを追加しないと、ビューの位置が[y:20pixel]ずれることがある。
- (void)viewDidAppear:(BOOL)animated;
{
	[super viewDidAppear:animated];

	if (!_worldStarted) {
		// ワールド開始
		[self worldStarted:_initialUICase];
		
		// 最初のアプレットを表示する
		if (_initialUICase) {
			[_initialUICase willUICaseActivate];
			[self transitionStartupUICase:_initialUICase animation:self.startupAnimation];
			[_initialUICase didUICaseActivate];
		}
		
		_worldStarted = YES;
	}
}

#pragma mark - Global command handling

- (void)transitionStartupUICase:(S2UICase*)uicase animation:(BOOL)animation;
{
	S2AssertNonNil(uicase);
	
	S2LogPass(nil, @"to:%@", uicase.name);
//	S2DebugLog(S2ClassTag, @"Title Bar: [%.0f:%.0f]", self.titleBar.width, self.titleBar.height);
//	S2DebugLog(S2ClassTag, @"Applet Content Size: [%.0f:%.0f]", self.contentView.width, self.contentView.height);

	// サイズを設定する
	uicase.navigationBar.alpha = 0.0;
	uicase.navigationBar.size = self.titleBar.size;
	uicase.currentViewController.view.alpha = 0.0;
	uicase.currentViewController.view.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);

	// じんわり表示する
	if (animation) {
		[UIView animateWithDuration:2.0 animations:^{
			uicase.navigationBar.alpha = 1.0;
			uicase.currentViewController.view.alpha = 1.0;
		}];
	}
	// すぐ表示する
	else {
		uicase.navigationBar.alpha = 1.0;
		uicase.currentViewController.view.alpha = 1.0;
	}
	
	[self addChildViewController:uicase.currentViewController];
	
    [self addUICaseViews:uicase];
	
    _currentUICase = uicase;
}

- (void)transitionUICaseWithName:(NSString*)uicaseName;
{
	for (S2UICase* uicase in _uicases) {
		if ([uicase.name isEqualToString:uicaseName]) {
			[self transitionUICase:uicase animated:uicase.enableAnimation];
			break;
		}
	}
}

- (void)transitionUICase:(S2UICase*)toUICase animated:(BOOL)animated;
{
	S2LogPass(nil, @"to:%@", toUICase.name);
//	S2DebugLog(S2ClassTag, @"AppletContentSize: [%.0f:%.0f]", self.contentView.width, self.contentView.height);

	[self addChildViewController:toUICase.currentViewController];
	
	// toUICaseのナビゲーションバーとコンテンツビューの位置とサイズを設定する
	toUICase.navigationBar.frame = self.titleBar.frame;
	toUICase.currentViewController.view.frame = self.contentView.bounds;
	[toUICase.currentViewController.view layoutIfNeeded];

	[toUICase willUICaseActivate];
	
	// ナビゲーションバーのアニメーションを設定する
	[UIView transitionFromView:_currentUICase.navigationBar
						toView:toUICase.navigationBar
					  duration:0.8
					   options:animated ? UIViewAnimationOptionTransitionFlipFromBottom : UIViewAnimationOptionTransitionNone
					completion:nil];
	
	// コンテンツビューのアニメーションを設定する
	[UIView transitionFromView:_currentUICase.currentViewController.view
						toView:toUICase.currentViewController.view
					  duration:0.8
					   options:animated ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionNone
					completion:^(BOOL finished) {
						[_currentUICase.currentViewController removeFromParentViewController];
						
						_currentUICase = toUICase;
						
						[toUICase didUICaseActivate];
					}
	 ];
}

- (void)transitionPreviousUICase:(UIGestureRecognizer*)sender
{
    NSUInteger index = [_uicases indexOfObject:_currentUICase];

	while (index > 0) {
	    S2UICase* previousUICase = _uicases[--index];
		
	    if (previousUICase.canSwipeGestureTransition) {
			S2LogPass(nil, @"to:%@ canSwipeGestureTransition=%@", previousUICase.name, S2BoolToString(previousUICase.canSwipeGestureTransition));
		
        	[self transitionUICaseVerticalFlipAnimated:previousUICase options:UIViewAnimationOptionTransitionFlipFromBottom];
			break;
		}
    }
}

- (void)transitionNextUICase:(UIGestureRecognizer*)sender
{
    NSUInteger index = [_uicases indexOfObject:_currentUICase];
	
	while (index < _uicases.count - 1) {
	    S2UICase* nextUICase = _uicases[++index];
    
		if (nextUICase.canSwipeGestureTransition) {
			S2LogPass(nil, @"to:%@ canSwipeGestureTransition=%@", nextUICase.name, S2BoolToString(nextUICase.canSwipeGestureTransition));

        	[self transitionUICaseVerticalFlipAnimated:nextUICase options:UIViewAnimationOptionTransitionFlipFromTop];
			break;
		}
    }
}

- (S2UICase*)previousUICase
{
    NSUInteger index = [_uicases indexOfObject:_currentUICase];
    
    if (index == 0) {
        return _transitionMode == S2UICaseContainerTransitionRotate ? _uicases.lastObject : nil;
    }
    else {
        return _uicases[index - 1];
    }
}

- (S2UICase*)nextUICase
{
    NSUInteger index = [_uicases indexOfObject:_currentUICase];
    
    if (index == _uicases.count - 1) {
        return _transitionMode == S2UICaseContainerTransitionRotate ? _uicases.firstObject : nil;
    }
    else {
        return _uicases[index + 1];
    }
}

- (void)transitionUICaseVerticalFlipAnimated:(S2UICase*)toUICase
         options:(UIViewAnimationOptions)options
{
	// タイトルバーなしの場合
	if (!self.titleBar) {
		[toUICase willUICaseActivate];
		[self transitionFromViewController:_currentUICase.currentViewController
						  toViewController:toUICase.currentViewController
								  duration:1.0
								   options:options
								animations:nil
								completion:^(BOOL finished) {
									_currentUICase = toUICase;
								}
		];
		[toUICase didUICaseActivate];
		return;
	}

	// タイトルバーありの場合
	__weak S2UICaseContainer* _self = self;
	
	// for title animation
	int animationInFromY;
	int animationOutToY;
	switch (options) {
		case UIViewAnimationOptionTransitionFlipFromTop:
			animationInFromY = self.titleBar.frame.size.height;
			animationOutToY  = -self.titleBar.frame.size.height;
			break;
			
		case UIViewAnimationOptionTransitionFlipFromBottom:
			animationInFromY = -self.titleBar.frame.size.height;
			animationOutToY  = self.titleBar.frame.size.height;
			break;
			
		default:
			animationInFromY = 0;
			animationOutToY = 0;
	}
	
	// ナビゲーションバーのアニメーション前位置とサイズを設定する
	{
		CGRect navigationBarFrame = toUICase.navigationBar.frame;
		navigationBarFrame.origin.y = animationInFromY;
		navigationBarFrame.size.width = self.contentView.frame.size.width;
		toUICase.navigationBar.frame = navigationBarFrame;
	}
	
	// コンテンツビューの位置とサイズを設定する
	toUICase.currentViewController.view.frame = self.contentView.bounds;

	[toUICase willUICaseActivate];

	// ナビゲーションバーとコンテンツビューを同時にアニメーションさせる
	[self addChildViewController:toUICase.currentViewController];
    [self transitionFromViewController:_currentUICase.currentViewController toViewController:toUICase.currentViewController
        duration:0.5
        options:options
        animations:^ {
			// MEMO: インスタンス変数にアクセスするために、一時的に強参照を得ている
			S2UICaseContainer* _container = _self;

			[_container.titleBar addSubview:toUICase.navigationBar];
			
			// ナビゲーションバーのアニメーション後位置を設定する
			CGRect inViewFrame = toUICase.navigationBar.frame;
			CGRect outViewFrame = _container->_currentUICase.navigationBar.frame;

			inViewFrame.origin.y = 0;
			outViewFrame.origin.y = animationOutToY;

			toUICase.navigationBar.frame = inViewFrame;
			_container->_currentUICase.navigationBar.frame = outViewFrame;
        }
        completion:^(BOOL finished) {
			// MEMO: インスタンス変数にアクセスするために、一時的に強参照を得ている
			S2UICaseContainer* _container = _self;

			[_container->_currentUICase.navigationBar removeFromSuperview];

            _container->_currentUICase = toUICase;

			[toUICase didUICaseActivate];
        }
    ];
}

- (S2UICase *)currentUICase;
{
	return _currentUICase;
}

- (void)addUICaseViews:(S2UICase*)uicase
{
	if (self.titleBar) {
		[self.titleBar addSubview: uicase.navigationBar];
	}
	
    [self.contentView addSubview: uicase.currentViewController.view];
}

- (void)removeUICaseViews:(S2UICase*)uicase
{
	[uicase.currentViewController.view removeFromSuperview];
	
	[uicase.navigationBar removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

@end



@implementation S2UICaseContainer (LicenseCheck)

- (BOOL)needServiceLicenseCheck;
{
	return YES;
}

- (void)checkServiceLicense;
{
}

@end



@implementation S2UICaseContainer (Events)

- (void)worldStarted:(S2UICase*)initialUICase;
{
	// override point
}

@end



// インターフェースの定義
@interface S2UICaseContainerContentView : UIView

@property UIGestureRecognizer* globalGestureRecognizer;

@end

// インターフェースの実装
@implementation S2UICaseContainerContentView

- (void)didAddSubview:(UIView *)subview
{
	[self installRequireGestureRecognizerTo:subview];
}

- (void)installRequireGestureRecognizerTo:(UIView*)view
{
	for (UIGestureRecognizer* gestureRecognizer in view.gestureRecognizers) {
		if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])
			[gestureRecognizer requireGestureRecognizerToFail:self.globalGestureRecognizer];
	}
	
	for (UIView* subview in view.subviews) {
		[self installRequireGestureRecognizerTo:subview];
	}
}

@end



@implementation S2TitledUICaseContainer {
	UINavigationBar* _titleBar;
	S2UICaseContainerContentView* _contentView;

	UISwipeGestureRecognizer* _uicaseChangeSwipeUpGestureRecognizer;
	UISwipeGestureRecognizer* _uicaseChangeSwipeDownGestureRecognizer;
	NSInteger _uicaseChangeGestureSwipeTouchCount;
}

- (id)init;
{
	if (self = [super init]) {
		[self initializeInstance];
	}
	return self;
}

- (void)initializeInstance;
{
	_titleBar = [[UINavigationBar alloc] init];
	_titleBar.barStyle = UIBarStyleBlack;
	
	[super initializeInstance];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// グローバルジェスチャーを登録する
    [self installGlobalGestureRecognizers];
	
	// アプレット固有のNavigationBarのサイズを画面幅に調整する
	for (S2UICase* uicase in _uicases) {
		uicase.navigationBar.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.origin.y);
	}
}

#pragma mark - Global gesture handling

// グローバルジェスチャーの登録
- (void)installGlobalGestureRecognizers;
{
    _uicaseChangeSwipeUpGestureRecognizer =
    [
	 [UISwipeGestureRecognizer alloc]
	 initWithTarget:self action:@selector(transitionNextUICase:)
	 ];
    _uicaseChangeSwipeUpGestureRecognizer.numberOfTouchesRequired = _uicaseChangeGestureSwipeTouchCount;
    _uicaseChangeSwipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
	_uicaseChangeSwipeUpGestureRecognizer.delegate = self;
	
	_uicaseChangeSwipeDownGestureRecognizer =
    [
	 [UISwipeGestureRecognizer alloc]
	 initWithTarget:self action:@selector(transitionPreviousUICase:)
	 ];
    _uicaseChangeSwipeDownGestureRecognizer.numberOfTouchesRequired = _uicaseChangeGestureSwipeTouchCount;
    _uicaseChangeSwipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
	_uicaseChangeSwipeDownGestureRecognizer.delegate = self;
	
    [self.view addGestureRecognizer:_uicaseChangeSwipeUpGestureRecognizer];
    [self.view addGestureRecognizer:_uicaseChangeSwipeDownGestureRecognizer];
	
	// ジェスチャーの依存関係を設定する
	[_uicaseChangeSwipeDownGestureRecognizer requireGestureRecognizerToFail:_uicaseChangeSwipeUpGestureRecognizer];
	_contentView.globalGestureRecognizer = _uicaseChangeSwipeDownGestureRecognizer;
}

- (void)loadUserDefaults:(NSUserDefaults*)userDefaults;
{
	NSInteger swipeTouchCount = [userDefaults integerForKey:@"S2UICaseChangeGesture.SwipeTouchCount"];
	
	if (_uicaseChangeGestureSwipeTouchCount != swipeTouchCount) {
		_uicaseChangeGestureSwipeTouchCount = swipeTouchCount;
		_uicaseChangeSwipeUpGestureRecognizer.numberOfTouchesRequired = _uicaseChangeGestureSwipeTouchCount;
		_uicaseChangeSwipeDownGestureRecognizer.numberOfTouchesRequired = _uicaseChangeGestureSwipeTouchCount;
		
		S2EventLog(nil, S2ClassTag, @"UserDefault changed: %@: %d", @"S2UICaseChangeGesture.SwipeTouchCount", _uicaseChangeGestureSwipeTouchCount);
	}
}

@end
