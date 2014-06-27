//
//  S2EditorViewController.m
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/05.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2EditorViewController.h"



@implementation S2EditorViewController {
	BOOL _autoSave;
	
	BOOL _modified;
	
	NSTimer* _autoSaveTimer;
}

- (void)viewDidLoad
{
	_autoSave = YES;
	_modified = NO;
	
	[self loadTargets];

	[super viewDidLoad];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];

	if (self.autoSave) {
		[self saveAutomatic];
	}
}

- (BOOL)autoSave
{
	return _autoSave;
}

- (void)setAutoSave:(BOOL)autoSave
{
	if (autoSave == _autoSave)
		return;
	
	if (autoSave) {
		if (_modified) {
			[self startAutoSaveTimer];
		}
	}
	else {
		[self stopAutoSaveTimer];
	}
	
	_autoSave = autoSave;
}

- (void)setModified;
{
	if (_autoSave) {
		[self startAutoSaveTimer];
	}
	
	_modified = YES;
}

- (void)startAutoSaveTimer
{
	[_autoSaveTimer invalidate];
	
	_autoSaveTimer = [NSTimer scheduledTimerWithTimeInterval:10
													  target:self
													selector:@selector(saveAutomatic)
													userInfo:nil
													 repeats:NO];
}

- (void)stopAutoSaveTimer
{
	[_autoSaveTimer invalidate];
}

- (void)saveAutomatic
{
	if (_modified) {
		[self saveTargets];
		
		_modified = NO;
	}
}

- (void)loadTargets
{
	// optional override
}

- (void)saveTargets
{
	// optional override
}

@end
