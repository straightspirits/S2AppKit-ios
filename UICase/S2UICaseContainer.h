//
//  S2UICaseContainer.h
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/06/30.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2UIKit.h"


@class S2UICase, S2UIModel;


typedef enum {
	S2UICaseContainerTransitionNormal,
	S2UICaseContainerTransitionRotate,
} S2UICaseContainerTransitionMode;



/*
 *	UIケースコンテナ
 */
@interface S2UICaseContainer : UIViewController

@property (readonly) S2UIModel* uiModel;

@property (readonly) NSUserDefaults* userDefaults;
- (void)loadUserDefaults:(NSUserDefaults*)userDefaults;	// override if needed.

@property BOOL startupAnimation;
@property S2UICaseContainerTransitionMode transitionMode;

- (void)setupUICases:(NSArray*)uicases initialUICaseName:(NSString*)uicaseName privateSettings:(NSDictionary*)privateSettings;
- (void)setupUICases:(NSArray*)uicases initialUICase:(S2UICase*)uicase privateSettings:(NSDictionary*)privateSettings;

- (S2UICase*)uicaseByName:(NSString*)uicaseName;

- (void)transitionStartupUICase:(S2UICase*)uicase animation:(BOOL)animation;
- (void)transitionUICaseWithName:(NSString*)uicaseName;
- (void)transitionUICase:(S2UICase*)toUICase animated:(BOOL)animated;
@property (readonly) S2UICase* currentUICase;

// タイトルバー
@property (readonly) UINavigationBar *titleBar;
// コンテンツビュー
@property (readonly) UIView *contentView;

@end



@interface S2UICaseContainer (LicenseCheck)

// ライセンスチェック
- (BOOL)needServiceLicenseCheck;
- (void)checkServiceLicense;

@end



@interface S2UICaseContainer (Events)

- (void)worldStarted:(S2UICase*)initialUICase;

@end




/*
 *	iPad専用の、アプレットナビゲーションバー付きコンテナ
 */
@interface S2TitledUICaseContainer : S2UICaseContainer

@end
