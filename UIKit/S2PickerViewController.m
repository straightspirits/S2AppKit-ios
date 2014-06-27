//
//  S2PickerViewController.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2013/01/22.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "S2PickerViewController.h"
#import "UIKit+S2AppKit.h"



@interface S2PickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation S2PickerViewController

- (UIPickerView *)pickerView;
{
	return (UIPickerView*)self.view;
}

- (void)loadView;
{
	UIPickerView* pickerView = [UIPickerView new];
	pickerView.showsSelectionIndicator = YES;
	pickerView.dataSource = self;
	pickerView.delegate = self;
	
	self.view = pickerView;
}

- (CGSize)contentSizeForViewInPopover;
{
	return self.view.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
	return self.targetItems.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	return [self.targetItems[row] toString];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
	if (_selected) {
		_selected(pickerView, row);
	}
}

@end
