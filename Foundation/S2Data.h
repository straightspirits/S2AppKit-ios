//
//  S2Data.h
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/09/18.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



@class S2DataObject, S2DataEntity, S2DataRef, S2DataHistoryPool;



#define S2DataEntityIdNil		0
#define S2DataRevisionNil		0
#define S2DataHistoryIdNil		nil



@protocol S2DataSerialize <NSObject>

- (void)serializeTo:(NSMutableDictionary*)dictionary;
- (void)deserializeFrom:(NSDictionary*)dictionary;

@end



@protocol S2DataSerializationHook <NSObject>

@optional
- (NSDictionary*)hookDeserialize:(NSDictionary*)dictionary;

@end



@interface S2DataObject : NSObject <NSCopying>

+ (NSString*)entityType;
+ (NSString*)idKey:(NSString*)name;

- (id)copyWithZone:(NSZone*)zone;
- (id)initWithSource:(id)source zone:(NSZone*)zone;

- (void)fixReferenceRevisions;

@end



@interface S2DataEntity : S2DataObject <S2Complarable> {
//@protected
	int _id;
	int _revision;
	BOOL _use;
	NSString* _name;
	NSString* _explanation;
	BOOL _fixed;
}

// + (id)new;
+ (id)newEntity:(int)id revision:(int)revision name:(NSString*)name;

// ID
+ (NSString*)idKey;
+ (NSString*)adhocIdKey;
@property int id;

// リビジョン
+ (NSString*)revisionKey;
@property int revision;

// 履歴プールID
@property (readonly) NSString* historyId;

// 使用フラグ
@property BOOL use;

// 名称
@property NSString* name;

// 説明
@property NSString* explanation;

// 固定フラグ（trueの場合、削除できない）（システム固定の場合、true）
@property BOOL fixed;

- (S2DataRef*)latestRef;
- (S2DataRef*)historyRef;

- (BOOL)isEqual:(id)object;
- (NSComparisonResult)compareTo:(id)target;

@end



@interface S2DataRef : S2DataObject <S2DataSerialize> {
	__strong S2DataEntity* _entity;
	NSString* _entityType;
	int _id;
	int _revision;
}

//+ (id)new;
+ (id)newLatestRefById:(int)id;
+ (id)newLatestRef:(S2DataEntity*)entity;
+ (id)newHistoryRefById:(int)id revision:(int)revision;
+ (id)newHistoryRef:(S2DataEntity*)entity;

@property S2DataEntity* entity;
@property NSString* entityType;
@property int id;
@property int revision;
@property (readonly) NSString* historyId;
@property (readonly) id target;	// == entity

- (void)fixRevision;
- (void)fixEntity;
- (BOOL)match:(S2DataRef*)target;

@end



/*
 *	データ参照のされ方
 */
typedef enum _S2DataRefType {
	S2DataRefTypeHard,		// 削除不可、編集不可
	S2DataRefTypeSoft,		// 削除不可、編集可
	S2DataRefTypeNone,		// 削除可、編集可
} S2DataRefType;



@interface S2DataFormat : S2DataObject

+ (id)new:(NSString*)formatType :(NSString*)formatVersion;

@property NSString* formatType;
@property NSString* formatVersion;

@end



@interface S2DateComponents : S2DataObject

+ (id)new:(int)year :(int)month :(int)day;

@property int year;
@property int month;
@property int day;

- (NSDateComponents*)toNSDateComponents;

@end



@interface S2TimeComponents : S2DataObject

+ (id)new:(int)hour :(int)minute :(int)second;

@property int hour;
@property int minute;
@property int second;

- (NSDateComponents*)toNSDateComponents;

@end



@interface S2DateTimeComponents : S2DataObject

+ (id)new:(int)year :(int)month :(int)day :(int)hour :(int)minute :(int)second;

@property int year;
@property int month;
@property int day;
@property int hour;
@property int minute;
@property int second;

- (NSDateComponents*)toNSDateComponents;

@end



@interface S2DataHistoryPool : S2DataObject

// データバージョン (初期化のたびにインクリメントされる。初期値は1)
@property int dataVersion;

// データ型をキーにした履歴辞書 ({entityType:NSString => {historyId:NSString => entity:S2DataEntity}})
@property NSMutableDictionary* pool;

- (BOOL)isContained:(S2DataEntity*)entity;
- (id)dataById:(NSString*)entityType :(NSString*)historyId;
- (id)dataByRef:(S2DataRef*)ref;

- (void)setEntity:(S2DataEntity*)entity;
- (void)addEntity:(S2DataEntity*)entity;
- (void)removeEntity:(S2DataEntity*)entity;

@end



extern BOOL S2DataRefArrayIdContains(NSArray* array, int id);
extern BOOL S2DataRefArrayEquals(NSArray* array1, NSArray* array2);
extern NSMutableArray* S2DataEntityArrayToLatestRefArray(NSArray* array);
extern NSMutableArray* S2DataEntityArrayToHistoryRefArray(NSArray* array);
extern NSMutableArray* S2DataRefArrayToEntityArray(NSArray* array);

extern NSMutableArray* S2DataEntitySetToIndex(NSSet* set);
extern NSMutableSet* S2DataEntitySetToLatestRefSet(NSSet* set);
extern NSMutableSet* S2DataEntitySetToHistoryRefSet(NSSet* set);
extern NSMutableSet* S2DataRefSetToEntitySet(NSSet* set);


