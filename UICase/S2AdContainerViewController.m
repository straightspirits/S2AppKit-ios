//
//  S2AdContainerViewController.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2013/01/16.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "S2AdContainerViewController.h"



@interface S2AdContainerViewController ()

@end

@implementation S2AdContainerViewController {
	UIViewController* _contentViewController;
}

- (void)loadView;
{
	[super loadView];
	
	// コンテナビューを設定する
	self.view.frame = CGRectMake(0, 0, 100, 100);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)contentViewController;
{
	return _contentViewController;
}

- (void)setContentViewController:(UIViewController *)contentViewController;
{
	if (_contentViewController) {
		[_contentViewController removeFromParentViewController];
		[_contentViewController.view removeFromSuperview];
	}
	
	_contentViewController = contentViewController;
	_contentViewController.view.frame = self.view.bounds;
	[self addChildViewController:_contentViewController];
	[self.view addSubview:_contentViewController.view];
}

#pragma mark - for Ad

- (void)startAd;
{
	if (self.adBanner == nil || self.adBanner.running)
		return;
	
	S2LogPass(nil, @"");

	[self.view addSubview:self.adBanner.view];

	_contentViewController.view.bottom -= self.adBanner.view.height;

	[self.adBanner startAd];
}

- (void)stopAd;
{
	if (self.adBanner == nil || !self.adBanner.running)
		return;

	S2LogPass(nil, @"");

	[self.adBanner stopAd];

	_contentViewController.view.bottom += self.adBanner.view.height;

	[self.adBanner.view removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated;
{
	[super viewDidAppear:animated];
	
	// 広告バナー位置を設定する
	if (self.adBanner) {
		self.adBanner.view.top = self.view.bottom - self.adBanner.view.height;
		self.adBanner.view.left = (self.view.width - self.adBanner.view.width) / 2;

		self.adBanner.view.hidden = NO;
	}
}

- (void)viewDidDisappear:(BOOL)animated;
{
	[super viewDidDisappear:animated];
	
	if (self.adBanner) {
		self.adBanner.view.hidden = YES;
	}
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
{
	self.adBanner.view.hidden = YES;
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	self.adBanner.view.top = self.view.bottom - self.adBanner.view.height;
	self.adBanner.view.left = (self.view.width - self.adBanner.view.width) / 2;
	self.adBanner.view.hidden = NO;
}

@end
