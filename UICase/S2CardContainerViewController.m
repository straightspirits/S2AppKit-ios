//
//  S2CardContainerViewController.m
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/15.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2CardContainerViewController.h"



@implementation S2CardContainerViewController {
	NSMutableArray* _cardStacks;
	int _activeCardStackIndex;
}

#pragma mark - S2CardViewController methods

- (void)initializeInstance;
{
	[super initializeInstance];

	_cardStacks = [NSMutableArray new];
	_activeCardStackIndex = -1;
}

- (NSInteger)addCardStack:(S2CardStack*)cardStack;
{
	[_cardStacks addObject:cardStack];
	
	return _cardStacks.count - 1;
}

- (NSInteger)cardStackCount;
{
	return _cardStacks.count;
}

- (S2CardStack*)cardStackAtIndex:(int)index;
{
	return index >= 0 ? [_cardStacks objectAtIndex:_activeCardStackIndex] : nil;
}

- (S2CardStack*)exchangeCardStack:(int)index;
{
	S2CardStack* nextCardStack = [_cardStacks objectAtIndex:index];
	S2CardStack* activeCardStack = self.activeCardStack;

	if (nextCardStack == activeCardStack) {
		return activeCardStack;
	}
	
	if (activeCardStack) {
		[activeCardStack.view removeFromSuperview];
		[activeCardStack removeFromParentViewController];
	}
	
	[self addChildViewController:nextCardStack];
	[self.view addSubview:nextCardStack.view];
	
	nextCardStack.view.frame = self.view.bounds;
	
	_activeCardStackIndex = index;
	
	return nextCardStack;
}

- (S2CardStack *)activeCardStack;
{
	return [self cardStackAtIndex:_activeCardStackIndex];
}

- (BOOL)canChangeViewController
{
	if (!self.currentEditor)
		return YES;

	// 編集中ではないか、自動保存の場合は画面遷移可能
	if (!self.currentEditor.editing || self.currentEditor.autoSave)
		return YES;

	[S2MessageView show_message:@"編集を完了してください" seconds:2];
	
	return NO;
}

@end
