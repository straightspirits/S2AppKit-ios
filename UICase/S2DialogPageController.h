//
//  S2DialogPageController.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/11/20.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2DialogContext.h"
#import "S2ViewControllers.h"



@interface S2DialogPageController : S2ViewController

+ (id)new_uicase:(S2UICase*)uicase;

- (S2DialogContext*)pageContext;
- (void)setPageContext:(S2DialogContext *)context;
@property NSInteger pageIndex;

- (UIBarButtonItem*)cancelButton;
- (UIBarButtonItem*)nextButton;
- (UIBarButtonItem*)doneButton;

- (void)nextButtonPressed:(id)sender;
- (void)doneButtonPressed:(id)sender;

@end
