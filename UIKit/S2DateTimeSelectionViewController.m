//
//  S2DateTimeSelectionViewController.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/11/02.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2DateTimeSelectionViewController.h"



@implementation S2DateTimeSelectionViewController

- (UIDatePicker *)datePicker;
{
	return (UIDatePicker*)self.view;
}

- (void)loadView;
{
	UIDatePicker* datePicker = [UIDatePicker new];
	
//	[datePicker addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
	
	self.view = datePicker;
}

- (CGSize)contentSizeForViewInPopover;
{
	return self.view.size;
}

//- (void)valueChanged;
//{
//	[self.delegate dateTimeChanged];
//}

@end
