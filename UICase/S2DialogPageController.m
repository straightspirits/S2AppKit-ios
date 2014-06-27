//
//  S2DialogPageController.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/11/20.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2DialogPageController.h"



@interface S2DialogPageController ()

@end

@implementation S2DialogPageController {
	S2DialogContext* _pageContext;
	UIBarButtonItem* _cancelButton;
	UIBarButtonItem* _nextButton;
	UIBarButtonItem* _doneButton;
}

+ (id)new_uicase:(S2UICase *)uicase;
{
	id object = [uicase loadViewController:self.identifier];
	
	S2Assert(object, @"view '%@' not found.", self.identifier);
	S2Assert(S2ObjectIsKindOf(object, self), @"view '%@' not %@.", self.identifier, NSStringFromClass(self.class));
	
	return object;
}

- (S2DialogContext *)pageContext;
{
	return _pageContext;
}

- (void)setPageContext:(S2DialogContext *)context;
{
	_pageContext = context;
}

- (UIBarButtonItem*)cancelButton;
{
	if (!_cancelButton) {
		_cancelButton = [S2BarButtonItem newWithTitle:[S2UIKit localizedStringForKey:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
	}
	return _cancelButton;
}

- (UIBarButtonItem*)nextButton;
{
	if (!_nextButton) {
		_nextButton = [S2BarButtonItem newWithTitle:[S2UIKit localizedStringForKey:@"Next"] style:UIBarButtonItemStyleDone target:self action:@selector(nextButtonPressed:)];
	}
	return _nextButton;
}

- (UIBarButtonItem*)doneButton;
{
	if (!_doneButton) {
		_doneButton = [S2BarButtonItem newWithTitle:[S2UIKit localizedStringForKey:@"Done"] style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
	}
	return _doneButton;
}

- (void)cancelButtonPressed:(id)sender;
{
	[self.pageContext cancelDialog];
}

- (void)nextButtonPressed:(id)sender;
{
	[self.pageContext transitionToNext:self];
}

- (void)doneButtonPressed:(id)sender;
{
	[self.pageContext dismissDialog];
}

@end
