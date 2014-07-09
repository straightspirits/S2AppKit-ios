//
//  S2AdBanner.h
//  S2AppKit/S2UIKit
//
//  Created by ふみお on 2012/11/05.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Foundation.h"

#import <iAd/iAd.h>



@interface S2AdBanner : NSObject

+ (id)iAdBanner:(NSDictionary*)privateSettings;
+ (id)gAdBanner:(NSDictionary*)privateSettings rootViewController:(UIViewController*)rootViewController bannerSize:(CGSize)gAdBannerSize;

@property (readonly) UIView* view;

- (void)startAd;
- (void)stopAd;
@property (readonly) BOOL running;

@end
