//
//  S2EditorViewController.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/05.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2ViewControllers.h"
#import "S2TableDialogController.h"
#import "S2TablePopoverViewController.h"



/*
 *	表示モードと編集モードを持つエディタビューコントローラー
 *		viewDidLoad:		編集開始(loadTargetを呼ぶ)
 *		viewWillDisappear:	編集終了(modified==YES && autoSave==YESの場合、saveTargetを呼ぶ)
 */
@interface S2EditorViewController : S2ViewController

@property BOOL autoSave;	// default is YES

@property (readonly) BOOL modified;

- (void)setModified;

- (void)loadTargets;

- (void)saveTargets;

//- (void)presentDialogController:(S2TableDialogController*)dialogController animated:(BOOL)animated completion:(S2DialogInputCompletion)completion;

@end



