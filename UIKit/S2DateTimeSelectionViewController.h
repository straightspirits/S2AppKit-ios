//
//  S2DateTimeSelectionViewController.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/11/02.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2UIKit.h"



//@protocol S2DateTimeSelectionDelegate <NSObject>
//
//- (void)dateTimeChanged;
//
//- (void)dismissPopover;
//
//@end



@interface S2DateTimeSelectionViewController : S2ViewController

@property (readonly) UIDatePicker* datePicker;

//@property (weak) id<S2DateTimeSelectionDelegate> delegate;

@end
