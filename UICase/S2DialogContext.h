//
//  S2DialogContext.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/11/20.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2UICase.h"


@class S2DialogContext, S2DialogPageController;



@interface S2DialogContext : NSObject

+ (id)new:(UIViewController*)appletViewController;

- (S2UICase*)uicase;

- (void)startWizard:(NSArray*)pageIdentifiers startPageIndex:(int)startPageIndex allowCancel:(BOOL)allowCancel;

- (int)pageIndexByIdentifier:(NSString*)pageIdentifier;
- (NSUInteger)pageCount;

- (id)loadPage:(NSString*)identifier;
- (NSInteger)nextPage:(S2DialogPageController*)pageController;

// for PageController
- (void)transitionToNext:(S2DialogPageController*)pageController;
- (void)cancelDialog;
- (void)dismissDialog;

@end
