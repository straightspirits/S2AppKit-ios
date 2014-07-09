//
//  S2AdBanner.m
//  S2AppKit/S2UIKit
//
//  Created by ふみお on 2012/11/05.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2AdBanner.h"



@interface S2AdBanner ()

@end



@interface __iAdBanner : S2AdBanner <ADBannerViewDelegate>

- (ADBannerView*)makeiAdBannerView;

@end



@implementation S2AdBanner {
	@protected
	NSDictionary* _appPrivateSettings;
//	UIView* _view;
}

S2_DEALLOC_LOGGING_IMPLEMENT

+ (id)iAdBanner:(NSDictionary*)appPrivateSettings;
{
	__iAdBanner* controller = [[__iAdBanner alloc] init:appPrivateSettings];

	controller.view = [controller makeiAdBannerView];

	return controller;
}

+ (id)gAdBanner:(NSDictionary*)appPrivateSettings rootViewController:(UIViewController*)rootViewController bannerSize:(CGSize)gAdBannerSize;
{
	__GAdBanner* controller = [[__GAdBanner alloc] init:appPrivateSettings];
	
	controller.view = [controller makeGADBannerView:rootViewController bannerSize:gAdBannerSize];
	
	return controller;
}

- (id)init:(NSDictionary*)appPrivateSettings;
{
	if (self = [super init]) {
		self->_appPrivateSettings = appPrivateSettings;
	}
	return self;
}

- (void)setView:(UIView *)view;
{
	_view = view;
}

- (void)startAd;
{
	S2AssertMustOverride();
}

- (void)stopAd;
{
	S2AssertMustOverride();
}

- (BOOL)running;
{
	return NO;
}

@end



@implementation __iAdBanner {
	BOOL bannerIsVisible;
}

- (void)startAd;
{
}

- (void)stopAd;
{
}

#pragma mark - iADBannerView

- (ADBannerView*)makeiAdBannerView;
{
//	ADBannerView* view = [[ADBannerView alloc] initWithFrame:CGRectZero];
//	view.delegate = self;
	
	return nil;
}

#pragma mark - ADBannerView delegate

// 広告のロード
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    // バナーが表示されていない場合は表示する
    if (!bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, +banner.frame.size.height);
        [UIView commitAnimations];
        bannerIsVisible = YES;
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
    if (bannerIsVisible == YES) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        bannerIsVisible = NO;
    }
}

@end
