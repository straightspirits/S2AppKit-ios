//
//  S2AdContainerViewController.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2013/01/16.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "S2ViewControllers.h"
#import "S2AdBanner.h"



// 下段に広告バナーを表示できるコンテナビュー
// 初期表示はcontentViewが最大化表示
// startAdでadBannerViewが現れ
// stopAdでadBannerViewが消える
@interface S2AdContainerViewController : S2ViewController

@property UIViewController* contentViewController;
@property S2AdBanner* adBanner;

- (void)startAd;
- (void)stopAd;

@end
