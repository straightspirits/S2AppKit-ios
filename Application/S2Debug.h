//
//  S2Debug.h
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/09.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import <Foundation/Foundation.h>



#define S2ClassTag	NSStringFromClass(self.class)

extern void __S2DebugLog(NSString* tag, NSString* format, ...);
extern void __S2DebugLogWithArgs(NSString* tag, NSString* format, va_list args);

#ifdef DEBUG

#define S2DebugLog(tag, format, ...) \
	__S2DebugLog(tag, format, ##__VA_ARGS__)

#else

#define S2DebugLog(tag, format, ...)

#endif

#define S2DebugPointLog(tag, point) \
	S2DebugLog(tag, @"point: %@", NSStringFromCGPoint(point))
#define S2DebugSizeLog(tag, size) \
	S2DebugLog(tag, @"size: %@", NSStringFromCGSize(size))
#define S2DebugRectLog(tag, rect) \
	S2DebugLog(tag, @"rect: %@", NSStringFromCGRect(rect))



#define S2Assert NSAssert
#define S2AssertParameter(condition) NSAssert(condition, @"%s: Invalid parameter '%s'", __PRETTY_FUNCTION__, #condition)
#define S2AssertNonNil(object) NSAssert(object != nil, @"'%s' is nil.", #object)
#define S2AssertType(object, type) NSAssert([object isKindOfClass:type.class], @"'%s'#%@ is not type #%@.", #object, NSStringFromClass([object class]), NSStringFromClass(type.class))
#define S2AssertClass(object, class) NSAssert([object isKindOfClass:class], @"'%s'#%@ is not type #%@.", #object, NSStringFromClass([object class]), NSStringFromClass(class))
#define S2AssertMustOverride() NSAssert(NO, @"%s: Must override selector.", __PRETTY_FUNCTION__)
#define S2AssertBadConstructor() NSAssert(NO, @"%s: This constructor can't use.", __PRETTY_FUNCTION__)
#define S2AssertFailed(...) NSAssert(NO, ##__VA_ARGS__)

