//
//  S2TablePopoverViewController.h
//  S2AppKit/S2UICase
//
//  Created by Fumio Furukawa on 2012/08/07.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2ViewControllers.h"
#import "S2TableViewCellCollection.h"



typedef enum {
	S2PopoverTableViewDecideOnceTap,
	S2PopoverTableViewDecideTwiceTap,
	S2PopoverTableViewDecideOnceTapNoDismiss,
} S2PopoverTableViewDecideMode;



@protocol S2TablePopoverViewDelegate <NSObject>

@property NSInteger selectedIndex;

- (NSInteger)numberOfRowCount;

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRow:(NSInteger)row;

- (void)dismissPopover;

@end



@interface S2TablePopoverViewController : S2ViewController

+ (id)new_uicase:(S2UICase*)uicase size:(CGSize)size;

@property S2PopoverTableViewDecideMode decideMode;
@property id<S2TablePopoverViewDelegate> delegate;
@property UITableView* tableView;

@end



@interface S2StringListPopoverViewController : S2TablePopoverViewController <S2TablePopoverViewDelegate>

+ (id)new_uicase:(S2UICase*)uicase width:(CGFloat)width strings:(NSArray *)strings;
+ (id)new_uicase:(S2UICase*)uicase width:(CGFloat)width strings:(NSArray*)strings selected:(void (^)(NSInteger index, id item))selected dismissed:(void(^)())dismissed;
+ (id)new_uicase:(S2UICase*)uicase width:(CGFloat)width items:(NSArray*)items stringer:(NSString* (^)(id item))stringer selected:(void (^)(NSInteger index, id item))selected dismissed:(void(^)())dismissed;

@end
