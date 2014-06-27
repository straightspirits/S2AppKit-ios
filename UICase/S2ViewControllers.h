//
//  S2ViewControllers.h
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/11.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2UICase.h"



@interface S2ViewController (S2UICase) <UIPopoverControllerDelegate>

+ (id)new_uicase:(S2UICase*)uicase;
+ (id)new_uicase:(S2UICase*)uicase nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (id)init_uicase:(S2UICase*)uicase;
- (id)init_uicase:(S2UICase*)uicase nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end



/*
 *	UITableViewControllerのApplet対応版
 */
@interface S2TableViewController : UITableViewController

+ (id)new_uicase:(S2UICase*)uicase style:(UITableViewStyle)style;
- (id)init_uicase:(S2UICase*)uicase style:(UITableViewStyle)style;

@end



/*
 *	UITabBarControllerのApplet対応版
 */
@interface S2TabBarController : UITabBarController

@end



/*
 *	UINavigationControllerのApplet対応版
 */
@interface S2NavigationController : UINavigationController

+ (id)new_rootViewController:(S2ViewController*)rootViewController;

@property BOOL transitAnimation;

@end



/*
 *	UISplitViewControllerのApplet対応版
 */
@interface S2SplitViewController (S2UICase)

@end



@interface S2NavigationDialogController : S2NavigationController

- (BOOL)disablesAutomaticKeyboardDismissal;

@end

