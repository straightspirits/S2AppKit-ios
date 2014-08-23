//
//  S2Functions.h
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2012/11/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Functions.h"
#import <CommonCrypto/CommonDigest.h>



NSString* S2ObjectToString(NSObject* value)
{
	return [value toString];
}

NSString* S2BoolToString(BOOL value)
{
	return [NSString stringWithFormat:@"%@", value ? @"YES" : @"NO"];
}

NSString* S2IntToString(int value)
{
	return [NSString stringWithFormat:@"%d", value];
}

NSString* S2DoubleToString(double value)
{
	return [NSString stringWithFormat:@"%f", value];
}

NSString* S2DateToDateTimeString(NSDate* value)
{
	return S2DateFormatString(@"yyyy/MM/dd HH:mm:ss", value);
}

NSString* S2DateToDateTimeZoneString(NSDate* value)
{
	return S2DateFormatString(@"yyyy/MM/dd HH:mm:ss z", value);
}

NSString* S2DateToDateString(NSDate* value)
{
	return S2DateFormatString(@"yyyy/MM/dd", value);
}

NSString* S2DateToTimeString(NSDate* value)
{
	return S2DateFormatString(@"HH:mm:ss", value);
}

NSString* S2DateToLocalizedDateString(NSDate* value)
{
	return S2DateFormatString(@"yyyy年MM月dd日 (w)", value);
}

NSString* S2DateToLocalizedTimeString(NSDate* value)
{
	return S2DateFormatString(@"HH時mm分ss秒", value);
}

NSString* S2DateFormatString(NSString* format, NSDate* value)
{
	if (!value)
		return nil;
	
	NSDateFormatter* formatter = [NSDateFormatter new];
	[formatter setDateFormat:format];
	return [formatter stringFromDate:value];
}

NSDate* S2StringToDate(NSString* value, NSString* format)
{
	if (!value)
		return nil;
	
	NSDateFormatter* formatter = [NSDateFormatter new];
	[formatter setDateFormat:format];
	return [formatter dateFromString:value];
}

BOOL S2StringMatch(NSString* string, NSString* pattern)
{
	if (!string)
		return NO;

	NSError* error;
	NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
	if (error) {
		return NO;
	}

	NSRange range = {.location=0, .length=string.length};
	return [regex numberOfMatchesInString:string options:0 range:range] > 0;
}

NSString* S2StringSearch(NSString* string, NSString* pattern)
{
	if (!string)
		return NO;
	
	NSError* error;
	NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
	if (error) {
		return NO;
	}
	
	NSRange range = {.location=0, .length=string.length};
	NSTextCheckingResult* result = [regex firstMatchInString:string options:0 range:range];

	return result ? [string substringWithRange:result.range] : nil;
}

NSString* S2StringReplace(NSString* string, NSString* pattern, NSString* replaceString)
{
	if (!string)
		return string;

	NSError* error;
	NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
	if (error) {
		return nil;
	}
	
	NSRange range = {.location=0, .length=string.length};
	return [regex stringByReplacingMatchesInString:string
										   options:NSMatchingReportProgress
											 range:range
									  withTemplate:replaceString];
}

NSString* S2StringRemovePrefix(NSString* string, NSString* prefix)
{
	if ([string hasPrefix:prefix]) {
		string = [string substringFromIndex:prefix.length];
	}
	
	return string;
}

NSString* S2StringRemoveSuffix(NSString* string, NSString* suffix)
{
	if ([string hasSuffix:suffix]) {
		string = [string substringToIndex:string.length - suffix.length];
	}
	
	return string;
}

// -- file path --

NSString* S2PathCombine(NSString* basePath, ...)
{
	NSString* path = basePath;

	va_list args;
	va_start(args, basePath);
	while (true) {
		NSString* arg = va_arg(args, NSString*);
		if (arg == nil)
			break;
		path = S2PathConcat(path, arg);
	}
	va_end(args);
	
	return path;
}

BOOL S2PathExists(NSString* path, NSString** fileType)
{
	// アイテムの属性を取得する
	NSError* error;
	NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
	
	if (error) {
		return NO;
	}

	if (fileType) {
		*fileType = attributes[NSFileType];
	}

	return YES;
}

BOOL S2PathFileExists(NSString* path)
{
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

BOOL S2PathDirectoryExists(NSString* path)
{
	BOOL isDirectory;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
	return exists && isDirectory;
}

// url

NSURL* S2URLCombine(NSURL* baseUrl, ...)
{
	NSURL* url = baseUrl;
	
	va_list args;
	va_start(args, baseUrl);
	while (true) {
		NSString* arg = va_arg(args, NSString*);
		if (arg == nil)
			break;
		url = S2URLConcat(url, arg);
	}
	va_end(args);
	
	return url;
}

// date

NSInteger S2DateWeekday(NSDate* date)
{
	NSDateComponents* dateComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date];

	return dateComponents.weekday - 1;
}

BOOL S2DateBetween(NSDate* date, NSDate* termBegin, NSDate* termEnd)
{
	if ([date compare:termBegin] == NSOrderedAscending)
		return NO;

	if ([date compare:termEnd] == NSOrderedDescending)
		return NO;
	
	return YES;
}

NSDateComponents* S2DateComponentsByNSDate(NSDate* date)
{
	NSDateComponents* dateComponents = [[NSCalendar currentCalendar]
										components:(NSCalendarCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
										fromDate:date];
	
	return dateComponents;
}

NSDateComponents* S2DateComponentsByDate(int year, int month, int day)
{
	NSDateComponents* dateComponents = [NSDateComponents new];
	
	dateComponents.calendar = [NSCalendar currentCalendar];
	dateComponents.year = year;
	dateComponents.month = month;
	dateComponents.day = day;
	
	return dateComponents;
}

NSDateComponents* S2DateComponentsByTime(int hour, int minute, int second)
{
	//	NSDateComponents* dateComponents = [NSDateComponents new];
	NSDateComponents* dateComponents = S2DateComponentsByNSDate(S2DateNow());
	
	dateComponents.hour = hour;
	dateComponents.minute = minute;
	dateComponents.second = second;
	
	return dateComponents;
}

NSDateComponents* S2DateComponentsByDateTime(int year, int month, int day, int hour, int minute, int second)
{
	NSDateComponents* dateComponents = [NSDateComponents new];
	
	dateComponents.calendar = [NSCalendar currentCalendar];
	dateComponents.year = year;
	dateComponents.month = month;
	dateComponents.day = day;
	dateComponents.hour = hour;
	dateComponents.minute = minute;
	dateComponents.second = second;
	
	return dateComponents;
}



double S2CurrencyRound(NSLocale* locale, double value)
{
	if (isnan(value))
		return value;

	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.locale = locale;
	formatter.formatterBehavior = NSNumberFormatterBehaviorDefault;
	formatter.numberStyle = NSNumberFormatterCurrencyStyle;
	
	NSString* currencyString = [formatter stringFromNumber:@(value)];
	NSNumber* currencyNumber = [formatter numberFromString:currencyString];
	return currencyNumber.doubleValue;
}

double S2CurrencyFromString(NSLocale* locale, NSString* value)
{
	value = S2StringTrimSpaces(value);
	if (S2StringIsEmpty(value))
		return NAN;

	// 先頭にマイナス記号がついていたら、負の値とする
	BOOL negative = NO;
	if ([value hasPrefix:@"-"]) {
		negative = YES;
		value = [value substringFromIndex:1];
	}
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.locale = locale;
	formatter.formatterBehavior = NSNumberFormatterBehaviorDefault;
	formatter.numberStyle = NSNumberFormatterCurrencyStyle;
	
	// 先頭が「通貨記号+スペース(*)」で始まる場合、取り除く
	// MEMO UITextFieldがU+00A0(NBSP)をU+0020(SPACE)に変換してしまうため、numberFromStringがnilを返す。
	//      SPACEをNBSPに変換する必要がある。
	NSString* currencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];
	
	if ([value hasPrefix:currencySymbol]) {
		value = [value substringFromIndex:currencySymbol.length];
	}
	value = S2StringTrimSpaces(value);

	// 先頭に通貨記号を追加する。
	NSNumber* currencyNumber = [formatter numberFromString:S2StringConcat(currencySymbol, value)];
	if (currencyNumber)
		return negative ? -currencyNumber.doubleValue : currencyNumber.doubleValue;

	// 先頭に通貨記号+NBSPを追加する。(意味ないかも)
	currencyNumber = [formatter numberFromString:S2StringFormat(@"%@\u00A0%@", currencySymbol, value)];
	if (currencyNumber)
		return negative ? -currencyNumber.doubleValue : currencyNumber.doubleValue;
	
	return NAN;
}

NSString* S2CurrencyToString(NSLocale* locale, double value)
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.locale = locale;
	formatter.formatterBehavior = NSNumberFormatterBehaviorDefault;
	formatter.numberStyle = NSNumberFormatterCurrencyStyle;
	
	return [formatter stringFromNumber:@(value)];
}

NSString* S2CurrencySymbol(NSLocale* locale)
{
	return [locale objectForKey:NSLocaleCurrencySymbol];
}



NSString* S2UuidGenerate()
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
	NSString *uuidString = (__bridge NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	
	return uuidString;
}

NSString* S2CryptHashSHA1(NSString* string)
{
	if (S2StringIsEmpty(string))
        return nil;
	
	// C文字列に変換する
    const char* value = [string UTF8String];
	
	// ハッシュ値を取得する
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(value, (CC_LONG)strlen(value), result);
	
	// 文字列に変換する
    NSMutableString* cryptedString = [[NSMutableString alloc] initWithCapacity:sizeof(result) * 2];
    for(NSInteger count = 0; count < sizeof(result); count++){
        [cryptedString appendFormat:@"%02x", result[count]];
    }
    
    return cryptedString;
}

NSString* S2CryptHashMD5(NSString* string)
{
	if (S2StringIsEmpty(string))
        return nil;
    
	// C文字列に変換する
    const char* value = [string UTF8String];
    
	// ハッシュ値を取得する
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), result);
    
	// 文字列に変換する
    NSMutableString* cryptedString = [[NSMutableString alloc] initWithCapacity:sizeof(result) * 2];
    for(NSInteger count = 0; count < sizeof(result); count++){
        [cryptedString appendFormat:@"%02x", result[count]];
    }
    
    return cryptedString;
}

NSString* S2CryptEncryptAES(NSString* string, NSString* salt)
{
	NSData* encryptedBytes = [string.utf8Data AES256EncryptWithKey:salt];
	
	return encryptedBytes.base64String;
}

NSString* S2CryptDecryptAES(NSString* string, NSString* salt)
{
	NSData* encryptedBytes = string.base64Data;
	
	return [encryptedBytes AES256DecryptWithKey:salt].utf8String;
}
