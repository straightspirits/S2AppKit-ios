//
//  S2Objc.h
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2012/11/06.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "S2Debug.h"


#define S2StringSymbolDefinition(key) 				extern NSString* key
#define S2StringSymbolImplementation(key) 			NSString* key = @#key

#define S2StringValueDefinition(prefix, value) 		extern NSString* prefix ## _ ## value
#define S2StringValueImplementation(prefix, value) 	NSString* prefix ## _ ## value = @#value



@protocol S2Complarable <NSObject>

- (NSComparisonResult)compareTo:(id)target;

@end



@interface NSObject (S2AppKit)

- (NSString*)className;

- (NSString*)toString;

- (void)logRetainCount;

@end

static inline BOOL S2ObjectEquals(NSObject* o1, NSObject* o2)
	{ return [o1 isEqual:o2]; }

static inline BOOL S2ObjectIsNSNull(NSObject* object)
	{ return object == NSNull.null; }

static inline NSObject* S2ObjectWrapNil(NSObject* object)
	{ return object != nil ? object : NSNull.null; }

//#define S2ObjectIsMemberOf(object, interfaceName) \
//	[object isMemberOfClass:[interfaceName class]]

#define S2ObjectIsKindOf(object, interfaceName) \
	[object isKindOfClass:[interfaceName class]]

#define S2ObjectConformsToProtocol(object, protocolName) \
	[object conformsToProtocol:@protocol(protocolName)]

#define S2ObjectRespondsToSelector(object, methodSelector) \
	[object respondsToSelector:methodSelector]



@interface NSData (Crypto)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end

@interface NSData (Base64)

+ (NSData *)dataWithBase64String:(NSString *)string;
- (NSString *)base64String;

@end

@interface NSData (S2AppKit)

+ (NSData*)utf8Bom;
+ (NSData*)utf16LEBom;
+ (NSData*)utf16BEBom;

- (NSString*)utf8String;

@end



@interface NSString (S2AppKit) <S2Complarable>

+ (NSString*)stringWithCharacter:(unichar)character repeatCount:(int)repeatCount;

- (NSData*)utf8Data;
- (NSData*)base64Data;

- (NSRange)wholeRange;

@end



@interface NSNumber (S2AppKit) <S2Complarable>

@end



@interface NSDate (S2AppKit) <S2Complarable>

@end



@interface NSArray (S2AppKit)

- (id)firstObject;

- (NSUInteger)indexOfKeyPath:(NSString*)keyPath value:(id)targetValue;
- (NSUInteger)indexOfKey:(NSString*)key object:(id)targetObject;
- (NSUInteger)indexOfKey:(NSString*)key value:(id)targetValue;
- (NSArray *)sortedArray;
- (NSArray *)sortedArrayUsingKey:(NSString*)key ascending:(BOOL)ascending;

@end



@interface NSMutableArray (S2AppKit)

- (NSMutableArray*)shallowCopyWithZone:(NSZone*)zone;
- (NSMutableArray*)deepCopyWithZone:(NSZone*)zone;

- (void)sort;
- (void)sortUsingKey:(NSString*)key ascending:(BOOL)ascending;

@end



@interface NSMutableSet (S2AppKit)

- (NSMutableSet*)shallowCopyWithZone:(NSZone*)zone;
- (NSMutableSet*)deepCopyWithZone:(NSZone*)zone;

@end



@interface NSDictionary (S2AppKit)

- (NSArray *)keysSortedByValue;

@end



@interface NSMutableDictionary (S2AppKit)

- (NSMutableDictionary*)shallowCopyWithZone:(NSZone*)zone;
- (NSMutableDictionary*)deepCopyWithZone:(NSZone*)zone;

@end



@interface NSFileHandle (S2AppKit)

- (void)writeUtf8Data:(NSString*)string;

@end



#define S2ErrorLogPrefix	@"S2ErrorReport-"
#define S2ErrorLogSuffix	@".log"

S2StringValueDefinition(S2ErrorLogType, ClientError);
S2StringValueDefinition(S2ErrorLogType, LibraryError);
S2StringValueDefinition(S2ErrorLogType, ServerError);
S2StringValueDefinition(S2ErrorLogType, DataError);
S2StringValueDefinition(S2ErrorLogType, Crash);

@interface NSException (Logs)

+ (NSString*)errorLogDirectoryPath;
+ (NSArray*)listErrorLogFileNames;

- (NSString*)saveToLogFile_type:(NSString*)type;
- (NSString*)saveToLogFile_type:(NSString*)type additionalInfo:(NSArray*)additionalInfo;
- (void)saveToLogFile_path:(NSString*)errorLogFilePath;
- (void)saveToLogFile_path:(NSString*)errorLogFilePath additionalInfo:(NSArray*)additionalInfo;

@end



@interface S2AppException : NSException

+ (S2AppException *)new:(NSString *)name reason:(NSString *)reason;
+ (S2AppException *)new:(NSString *)name format:(NSString *)format, ...;
+ (S2AppException *)new:(NSString *)name error:(NSError *)error;
+ (S2AppException *)new:(NSException*)exception;

+ (S2AppException *)exceptionWithName:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo;

@end



@interface NSBundle (S2AppKit)

- (NSString*)bundleName;

@end
