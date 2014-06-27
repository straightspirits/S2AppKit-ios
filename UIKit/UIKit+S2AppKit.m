//
//  UIKit+StraightSpiritsExtension.m
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2012/08/04.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "UIKit+S2AppKit.h"



@implementation UIColor (S2AppKit)

+ (UIColor*)whiteColor:(CGFloat)white :(CGFloat)alpha;
{
	return [self colorWithWhite:white alpha:alpha];
}

+ (UIColor*)rgbColor:(CGFloat)red :(CGFloat)green :(CGFloat)blue;
{
	return [self colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor*)rgbColor:(CGFloat)red :(CGFloat)green :(CGFloat)blue :(CGFloat)alpha;
{
	return [self colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor*)hsbColor:(CGFloat)hue :(CGFloat)saturation :(CGFloat)brightness;
{
	return [self colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

+ (UIColor*)hsbColor:(CGFloat)hue :(CGFloat)saturation :(CGFloat)brightness :(CGFloat)alpha;
{
	return [self colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
}

- (UIColor*)colorWithHue360:(int)hue360;
{
	CGFloat h, s, b, a;
	[self getHue:&h saturation:&s brightness:&b alpha:&a];
	
	return [UIColor colorWithHue:hue360 / 360.0 saturation:s brightness:b alpha:a];
}

- (UIColor*)colorWithBrightness100:(int)brightness100;
{
	CGFloat h, s, b, a;
	[self getHue:&h saturation:&s brightness:&b alpha:&a];
	
	return [UIColor colorWithHue:h saturation:s brightness:brightness100 / 100.0 alpha:a];
}

- (NSString*)whiteString;
{
	CGFloat w, a;
	[self getWhite:&w alpha:&a];
	return S2StringFormat(@"white:%.1f%%, alpha:%.1f%%", w * 100, a * 100);
}

- (NSString*)rgbString;
{
	CGFloat r, g, b, a;
	[self getRed:&r green:&g blue:&b alpha:&a];
	return S2StringFormat(@"#%02X%02X%02X alpha:%.1f%%", (int)(r * 256), (int)(g * 256), (int)(b * 256), a * 100);
}

- (NSString*)hsbString;
{
	CGFloat h, s, b, a;
	[self getHue:&h saturation:&s brightness:&b alpha:&a];
	return S2StringFormat(@"h:%.1f, s:%.1f%%, b:%.1f%%, alpha:%.1f%%", h * 360, s * 100, b * 100, a * 100);
}

@end



@implementation UIImage (S2AppKit)

- (CGFloat)width;
{
	return self.size.width;
}

- (CGFloat)height;
{
	return self.size.height;
}

- (UIImage*)imageByShrinkingWithSize:(CGSize)size;
{
	CGFloat widthRatio  = size.width  / self.size.width;
	CGFloat heightRatio = size.height / self.size.height;
	
	CGFloat ratio = MIN(widthRatio, heightRatio);
	
	if (ratio >= 1.0) {
		// 既に指定サイズに収まっているので、元のイメージを返す
		return self;
	}
	
	CGRect rect = CGRectMake(0, 0, self.size.width * ratio, self.size.height * ratio);
	
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
	
	[self drawInRect:rect];
	
	UIImage* shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return shrinkedImage;
}

@end


@implementation UIView (S2AppKit)

+ (id)blankView;
{
	return [[self alloc] initWithFrame:CGRectZero];
}

+ (id)loadFromNib;
{
	return [self loadFromNibName:NSStringFromClass(self.class)];
}

+ (id)loadFromNibName:(NSString*)nibName;
{
	UINib* nib = [UINib nibWithNibName:nibName bundle:nil];
	
	if (!nib) {
		@throw [S2AppException new:@"NibLoadFailed"
			format:@"%@: nib file is not found '%@'", NSStringFromClass(self.class), nibName
		];
	}
	
	NSArray* views = [nib instantiateWithOwner:nil options:nil];
	if (!views || views.count == 0) {
		@throw [S2AppException new:@"NibLoadFailed"
			format:@"%@: nib not found '%@'", NSStringFromClass(self.class), nibName
		];
	}
	
	id view = views.firstObject;
	
	if (![view isKindOfClass:self.class]) {
		@throw [S2AppException new:@"NibLoadFailed"
			format:@"%@: nib '%@.nib' is class '%@'", NSStringFromClass(self.class), nibName, [view className]
		];
	}

	return view;
}

- (CGFloat)x
{
	return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)y
{
	return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)width
{
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)height
{
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGFloat)right
{
	return CGRectGetMaxX(self.frame);
}

- (void)setRight:(CGFloat)right
{
	CGRect frame = self.frame;
	frame.size.width = right - frame.origin.x;
	self.frame = frame;
}

- (CGFloat)bottom
{
	return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom
{
	CGRect frame = self.frame;
	frame.size.height = bottom - frame.origin.y;
	self.frame = frame;
}

- (CGPoint)topLeft
{
	return self.frame.origin;
}

- (void)setTopLeft:(CGPoint)topLeft
{
	CGRect frame = self.frame;
	frame.origin = topLeft;
	self.frame = frame;
}

- (CGPoint)bottomRight
{
	CGRect frame = self.frame;
	return CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
}

- (void)setBottomRight:(CGPoint)bottomRight
{
	CGRect frame = self.frame;
//	frame.size.width = bottomRight.x - frame.origin.x;
//	frame.size.height = bottomRight.y - frame.origin.y;
	frame.origin.x = bottomRight.x - frame.size.width;
	frame.origin.y = bottomRight.y - frame.size.height;
	self.frame = frame;
}

- (CGSize)size
{
	return self.frame.size;
}

- (void)setSize:(CGSize)size
{
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

// 右端固定でsiteToFit
- (void)sizeToFitKeepRight
{
	int right = self.right;

	// MEMO これだとheightも変更されてしまう
	[self sizeToFit];

	self.right = right;
}

@end



@interface UILabel (S2AppKit)

@end

@implementation UILabel (S2AppKit)

// heightを維持したまま、xとwidthをテキストに合わせる
- (void)sizeToFitKeepRight;
{
	CGSize textSize = [self.text sizeWithFont:self.font];
	CGRect frame = self.frame;
	{
		int right = frame.origin.x + frame.size.width;
		frame.size.width = textSize.width;
		frame.origin.x = right - textSize.width;
	}
	self.frame = frame;
}

@end



@interface UIControlEventHandler : NSObject {
	void (^handler)(id);
}

@end

@implementation UIControlEventHandler

+ (id)new:(void (^)(id))handler
{
	UIControlEventHandler* instance = [self new];
	instance->handler = handler;
	return instance;
}

- (void)invoke:(id)sender
{
	if (handler)
		handler(sender);
}

@end


@implementation UIControl (S2AppKit)

#define ASSOCIATE_KEY_HANDLERS	"handlers"

- (NSMutableDictionary*)__handlers
{
	NSMutableDictionary* handlers = [self associatedValueForKey:ASSOCIATE_KEY_HANDLERS];
	if (!handlers) {
		handlers = [NSMutableDictionary new];
		[self associateValue:handlers withKey:ASSOCIATE_KEY_HANDLERS];
	}
	return handlers;
}

- (void)addEventHandler:(void(^)(id))handler forControlEvents:(UIControlEvents)events
{
	NSParameterAssert(handler != nil);

	NSMutableDictionary* allHandlers = self.__handlers;

	NSMutableArray* handlers = [allHandlers objectForKey:@(events)];
	
	if (!handlers) {
		handlers = [NSMutableArray new];
		
		[allHandlers setObject:handlers forKey:@(events)];
	}

	UIControlEventHandler* eventHandler = [UIControlEventHandler new:handler];

	[handlers addObject:eventHandler];
	
	[self addTarget:eventHandler action:@selector(invoke:) forControlEvents:events];
}

- (void)removeEventHandlersForControlEvents:(UIControlEvents)events
{
	NSMutableDictionary* allHandlers = self.__handlers;

	for (UIControlEventHandler* eventHandler in [allHandlers objectForKey:@(events)]) {
		[self removeTarget:eventHandler action:@selector(invoke) forControlEvents:events];
	}

	[allHandlers removeObjectForKey:@(events)];
}

- (void)setValueChanged:(void(^)(id))handler
{
	NSParameterAssert(handler != nil);

	[self removeEventHandlersForControlEvents:UIControlEventValueChanged];

	[self addEventHandler:handler forControlEvents:UIControlEventValueChanged];
}

@end



@implementation UITableView (S2AppKit)

- (id)cellForRow:(NSInteger)row section:(NSInteger)section
{
	return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

- (CGRect)rectForRow:(NSInteger)row section:(NSInteger)section
{
	return [self rectForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
}

- (CGRect)rectForContents
{
	NSInteger sectionCount = self.numberOfSections;
	
	if (sectionCount == 0)
		return CGRectZero;

	CGRect lastSectionRect = [self rectForSection:sectionCount - 1];
	
	return CGRectMake(0, 0, CGRectGetMaxX(lastSectionRect), CGRectGetMaxY(lastSectionRect));
}

- (CGRect)rectForTableFooter;
{
	CGSize contentsSize = [self rectForContents].size;
	
	return CGRectMake(0, contentsSize.height, contentsSize.width, self.frame.size.height - contentsSize.height);
}

- (void)selectRow:(NSInteger)row section:(NSInteger)section animated:(BOOL)animated
{
	[self selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:animated scrollPosition:UITableViewScrollPositionNone];
}

- (void)selectRow:(NSInteger)row section:(NSInteger)section animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
	[self selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] animated:animated scrollPosition:scrollPosition];
}

- (void)deselectAllRows
{
	[self deselectAllRowsAnimated:YES];
}

- (void)deselectAllRowsAnimated:(BOOL)animated
{
	for (NSIndexPath* indexPath in [self indexPathsForSelectedRows]) {
		[self deselectRowAtIndexPath:indexPath animated:animated];
		
		// 上記メソッドで呼ばれないので、自分でコールバックする
		if (self.delegate && S2ObjectRespondsToSelector(self.delegate, @selector(tableView:didDeselectRowAtIndexPath:))) {
			[self.delegate tableView:self didDeselectRowAtIndexPath:indexPath];
		}
	}
}

- (void)reloadDataWithRowAnimation:(UITableViewRowAnimation)animation
{
	NSRange range = {.location = 0, .length=[self numberOfSections]};
	
	[self reloadSections:[NSIndexSet indexSetWithIndexesInRange:range] withRowAnimation:animation];
}

- (void)reloadSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
	[self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:animation];
}

- (void)reloadRow:(NSInteger)row section:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
	[self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:animation];
}

- (void)reloadRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
	[self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)insertRow:(NSInteger)row section:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
	[self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:animation];
}

- (void)insertRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
	[self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)insertSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
	[self insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:animation];
}

- (void)deleteRow:(NSInteger)row section:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
	[self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:animation];
}

- (void)deleteRowAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
	[self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)deleteSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation;
{
	[self deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:animation];

}

@end



