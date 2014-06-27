//
//  S2PickerViewController.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2013/01/22.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "S2ViewController.h"



@interface S2PickerViewController : S2ViewController

@property (readonly) UIPickerView* pickerView;
@property NSArray* targetItems;
@property (copy) void (^selected)(UIPickerView* view, NSInteger row);

@end
