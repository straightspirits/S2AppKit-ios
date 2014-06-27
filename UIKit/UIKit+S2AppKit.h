//
//  UIKit+StraightSpiritsExtension.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/08/04.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Foundation.h"
#import <UIKit/UIKit.h>



@interface UIColor (S2AppKit)

+ (UIColor*)whiteColor:(CGFloat)white :(CGFloat)alpha;

+ (UIColor*)rgbColor:(CGFloat)red :(CGFloat)green :(CGFloat)blue;
+ (UIColor*)rgbColor:(CGFloat)red :(CGFloat)green :(CGFloat)blue :(CGFloat)alpha;

+ (UIColor*)hsbColor:(CGFloat)hue :(CGFloat)saturation :(CGFloat)brightness;
+ (UIColor*)hsbColor:(CGFloat)hue :(CGFloat)saturation :(CGFloat)brightness :(CGFloat)alpha;

//- (int)hue360;
- (UIColor*)colorWithHue360:(int)hue360;
- (UIColor*)colorWithBrightness100:(int)brightness100;

- (NSString*)whiteString;
- (NSString*)rgbString;
- (NSString*)hsbString;

@end



static inline UIColor* S2WhiteColor(int white100)
	{ return [UIColor colorWithWhite:white100 / 100.0 alpha:1.0]; }
static inline UIColor* S2WhiteaColor(int white100, int alpha100)
	{ return [UIColor colorWithWhite:white100 / 100.0 alpha:alpha100 / 100.0]; }

static inline UIColor* S2RgbColor(int r256, int g256, int b256)
	{ return [UIColor colorWithRed:r256 / 256.0 green:g256 / 256.0 blue:b256 / 256.0 alpha:1.0]; }
static inline UIColor* S2RgbaColor(int r256, int g256, int b256, int a100)
	{ return [UIColor colorWithRed:r256 / 256.0 green:g256 / 256.0 blue:b256 / 256.0 alpha:a100 / 100.0]; }

static inline UIColor* S2HsbColor(int h360, int s100, int b100)
	{ return [UIColor colorWithHue:h360 / 360.0 saturation:s100 / 100.0 brightness:b100 / 100.0 alpha:1.0]; }
static inline UIColor* S2HsbaColor(int h360, int s100, int b100, int a100)
	{ return [UIColor colorWithHue:h360 / 360.0 saturation:s100 / 100.0 brightness:b100 / 100.0 alpha:a100 / 100.0]; }

static inline UIColor* S2AlphaColor(UIColor* color, int alpha100)
	{ return [color colorWithAlphaComponent:alpha100 / 100.0]; }



@interface UIImage (S2AppKit)

- (CGFloat)width;
- (CGFloat)height;
- (UIImage*)imageByShrinkingWithSize:(CGSize)size;

@end



@interface UIView (S2AppKit)

+ (id)blankView;

+ (id)loadFromNib;
+ (id)loadFromNibName:(NSString*)nibName;

@property CGFloat x;
@property CGFloat y;
@property CGFloat width;
@property CGFloat height;
@property (getter=x, setter=setX:) CGFloat left;
@property (getter=y, setter=setY:) CGFloat top;
@property CGFloat right;
@property CGFloat bottom;
@property CGPoint topLeft;
@property CGPoint bottomRight;
@property CGSize size;

- (void)sizeToFitKeepRight;

@end



@interface UIControl (S2AppKit)

- (void)addEventHandler:(void(^)(id sender))handler forControlEvents:(UIControlEvents)events;
- (void)removeEventHandlersForControlEvents:(UIControlEvents)events;

- (void)setValueChanged:(void(^)(id sender))handler;

@end



@interface UITableView (S2AppKit)

- (id)cellForRow:(NSInteger)row section:(NSInteger)section;

- (CGRect)rectForRow:(NSInteger)row section:(NSInteger)section;
- (CGRect)rectForContents;
- (CGRect)rectForTableFooter;

- (void)selectRow:(NSInteger)row section:(NSInteger)section animated:(BOOL)animated;
- (void)selectRow:(NSInteger)row section:(NSInteger)section animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectAllRows;	// animated = YES
- (void)deselectAllRowsAnimated:(BOOL)animated;

- (void)reloadDataWithRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRow:(NSInteger)row section:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertRow:(NSInteger)row section:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)insertSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRow:(NSInteger)row section:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

@end



