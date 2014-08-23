//
//  S2AdBanner+iAd.m
//  S2AppKit/S2UIKit
//
//  Created by ふみお on 2012/11/05.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2AdBanner+iAd.h"
#import <iAd/iAd.h>



@interface __iAdBanner : S2AdBanner <ADBannerViewDelegate>

- (id)init:(NSDictionary*)appPrivateSettings;

@end



@implementation S2AdBanner (iAd)

S2_DEALLOC_LOGGING_IMPLEMENT

+ (id)iAdBanner:(NSDictionary*)appPrivateSettings;
{
	__iAdBanner* adBanner = [[__iAdBanner alloc] init:appPrivateSettings];

	return adBanner;
}

@end



@implementation __iAdBanner {
	NSDictionary* _appPrivateSettings;
	BOOL _bannerIsVisible;
}

- (id)init:(NSDictionary*)appPrivateSettings;
{
	if (self = [super init]) {
		_appPrivateSettings = appPrivateSettings;
        _view = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
	}
	return self;
}

- (void)startAd;
{
    _running = YES;
}

- (void)stopAd;
{
    _running = NO;
}

#pragma mark - ADBannerView delegate

// 広告のロード
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    // バナーが表示されていない場合は表示する
    if (!_bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, +banner.frame.size.height);
        [UIView commitAnimations];
        _bannerIsVisible = YES;
    }
}

// 広告のタップ
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    // いつでも広告表示OK
    return YES;
}

// 広告読み込みエラー
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_bannerIsVisible == YES) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        _bannerIsVisible = NO;
    }
}

@end
