//
//  S2AdBanner.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/11/05.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Foundation.h"
#import <UIKit/UIKit.h>



@interface S2AdBanner : NSObject {
@protected
	UIView* _view;
	BOOL _running;
}

@property (readonly) UIView* view;

- (void)startAd;
- (void)stopAd;

@property (readonly) BOOL running;

@end
