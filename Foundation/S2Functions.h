//
//  S2Functions
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2012/11/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "S2Objc.h"


#define S2ClassName(interface) \
	NSStringFromClass([interface class])
extern NSString* S2ObjectToString(NSObject* value);
extern NSString* S2BoolToString(BOOL value);
extern NSString* S2IntToString(int value);
extern NSString* S2DoubleToString(double value);
extern NSString* S2DateToDateTimeString(NSDate* value);
extern NSString* S2DateToDateTimeZoneString(NSDate* value);
extern NSString* S2DateToDateString(NSDate* value);
extern NSString* S2DateToTimeString(NSDate* value);
extern NSString* S2DateToLocalizedDateString(NSDate* value);
extern NSString* S2DateToLocalizedTimeString(NSDate* value);
extern NSString* S2DateFormatString(NSString* format, NSDate* value);

static inline NSData* S2StringToUtf8Data(NSString* string)
	{ return [string dataUsingEncoding:NSUTF8StringEncoding]; }
static inline NSString* S2Utf8DataToString(NSData* data)
	{ return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; }
static inline NSString* S2AsciiDataToString(NSData* data)
	{ return [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding]; }

extern NSDate* S2StringToDate(NSString* value, NSString* format);

static inline BOOL S2StringIsEmpty(NSString* string)
	{ return string == nil || string.length == 0; }
static inline NSString* S2StringNilToBlank(NSString* string)
	{ return string == nil ? @"" : string; }
static inline NSString* S2StringConcat(NSString* s1, NSString* s2)
	{ return [s1 stringByAppendingString:s2]; }
static inline BOOL S2StringEquals(NSString* s1, NSString* s2)
	{ return [s1 isEqualToString:s2]; }
static inline BOOL S2StringEqualsInsensitive(NSString* s1, NSString* s2)
	{ return [s1 caseInsensitiveCompare:s2] == NSOrderedSame; }
#define S2StringFormat(format, ...) \
	((NSString*)[NSString stringWithFormat:format, ##__VA_ARGS__])
static inline NSString* S2StringSubstring(NSString* string, int from, int length)
	{ return [string substringWithRange:NSMakeRange(from, length)]; }
static inline NSString* S2StringSubstringFrom(NSString* string, int from)
	{ return [string substringFromIndex:from]; }
static inline NSString* S2StringSubstringTo(NSString* string, int to)
	{ return [string substringToIndex:to]; }
static inline NSString* S2StringTrimSpaces(NSString* string)
	{ return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; }
extern BOOL S2StringMatch(NSString* string, NSString* pattern);
extern NSString* S2StringSearch(NSString* string, NSString* pattern);
extern NSString* S2StringReplace(NSString* string, NSString* pattern, NSString* replaceString);
extern NSString* S2StringRemovePrefix(NSString* string, NSString* prefix);
extern NSString* S2StringRemoveSuffix(NSString* string, NSString* suffix);

// path
static inline NSString* S2PathConcat(NSString* basePath, NSString* name)
	{ return [basePath stringByAppendingPathComponent:name]; }
extern NSString* S2PathCombine(NSString* basePath, ...);
static inline NSString* S2PathDirectory(NSString* path)
	{ return [path stringByDeletingLastPathComponent]; }
static inline NSString* S2PathFileName(NSString* path)
	{ return [path lastPathComponent]; }
static inline NSString* S2PathExtension(NSString* path)
	{ return [path pathExtension]; }
extern BOOL S2PathExists(NSString* path, NSString** fileType);
extern BOOL S2PathFileExists(NSString* path);
extern BOOL S2PathDirectoryExists(NSString* path);

// url
static inline NSURL* S2URL(NSString* urlString)
	{ return [NSURL URLWithString:urlString]; }
static inline NSURL* S2URLWithBase(NSURL* baseUrl, NSString* urlString)
	{ return [NSURL URLWithString:urlString relativeToURL:baseUrl]; }
static inline NSURL* S2FileURL(NSString* filePath)
	{ return [NSURL fileURLWithPath:filePath]; }
static inline NSURL* S2URLConcat(NSURL* baseUrl, NSString* name)
	{ return [baseUrl URLByAppendingPathComponent:name]; }
extern NSURL* S2URLCombine(NSURL* baseUrl, ...);
static inline NSURL* S2URLDirectory(NSURL* url)
	{ return [url URLByDeletingLastPathComponent]; }
static inline NSString* S2URLFileName(NSURL* url)
	{ return [url lastPathComponent]; }
static inline NSString* S2URLExtension(NSURL* url)
	{ return [url pathExtension]; }

// predicate
#define S2PredicateFormat(format, ...) \
	([NSPredicate predicateWithFormat:format, ##__VA_ARGS__])

// date
static inline NSDate* S2DateNow()
	{ return [NSDate date]; }
extern NSInteger S2DateWeekday(NSDate* date);
extern BOOL S2DateBetween(NSDate* date, NSDate* termBegin, NSDate* termEnd);

extern NSDateComponents* S2DateComponentsByNSDate(NSDate* date);
extern NSDateComponents* S2DateComponentsByDate(int year, int month, int day);
extern NSDateComponents* S2DateComponentsByTime(int hour, int minute, int second);
extern NSDateComponents* S2DateComponentsByDateTime(int year, int month, int day, int hour, int minute, int second);

extern double S2CurrencyRound(NSLocale* locale, double value);
extern double S2CurrencyFromString(NSLocale* locale, NSString* value);
extern NSString* S2CurrencyToString(NSLocale* locale, double value);
extern NSString* S2CurrencySymbol(NSLocale* locale);

// crypt/hash
extern NSString* S2UuidGenerate();
extern NSString* S2CryptHashSHA1(NSString* string);
extern NSString* S2CryptHashMD5(NSString* string);



#ifdef DEBUG

#define	S2_DEALLOC_LOGGING_IMPLEMENT	- (void)dealloc; { S2DebugLog(@"Runtime", @"%@: object disposed.", NSStringFromClass(self.class)); }

#else

#define	S2_DEALLOC_LOGGING_IMPLEMENT

#endif
