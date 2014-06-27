//
//  S2UIKitDefines.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2013/07/29.
//  Copyright (c) 2013年 Straight Spirits Co.Ltd. All rights reserved.
//

#import "S2Foundation.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "S2Colors.h"



#define S2IndexPath(section, row)	[NSIndexPath indexPathForRow:row inSection:section]



static inline CGRect S2RectFromSize(CGSize size) {
	return CGRectMake(0, 0, size.width, size.height);
}

static inline CGRect S2RectFromPointSize(CGPoint point, CGSize size) {
	return CGRectMake(point.x, point.y, size.width, size.height);
}

static inline CGRect S2RectFromXYSize(CGFloat x, CGFloat y, CGSize size) {
	return CGRectMake(x, y, size.width, size.height);
}




@interface S2UIKit : NSObject

+ (NSString*)localizedStringForKey:(NSString*)key;
+ (NSString*)localizedStringForKey:(NSString*)key defaultValue:(NSString*)defaultValue;

@end
