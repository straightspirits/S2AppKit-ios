//
//  S2Data.m
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/09/18.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Functions.h"
#import "S2Data.h"
#import "S2Logger.h"



static NSString* S2MakeDataHistoryId(int id, int revision)
{
	return revision > 0 ? S2StringFormat(@"%d:%d", id, revision) : S2IntToString(id);
}



@implementation S2DataObject

+ (NSString*)entityType;
{
	return NSStringFromClass(self);
}

+ (NSString*)idKey:(NSString*)name;
{
	return S2StringFormat(@"%@.%@", [self entityType], name);
}

- (id)copyWithZone:(NSZone*)zone;
{
	return [[self.class allocWithZone:zone] initWithSource:self zone:zone];
}

- (id)initWithSource:(id)source zone:(NSZone*)zone;
{
	return [super init];
}

- (void)fixReferenceRevisions;
{
}

@end



@implementation S2DataEntity

+ (id)newEntity:(int)id revision:(int)revision name:(NSString*)name;
{
	return [[self alloc] initEntity:id revision:revision name:name];
}

- (id)initEntity:(int)id revision:(int)revision name:(NSString*)name;
{
	if (self = [self init]) {
		self->_id = id;
		self->_revision = revision;
		self->_use = YES;
		self->_name = name;
		self->_fixed = NO;
	}
	
	return self;
}

- (id)initWithSource:(S2DataEntity*)source zone:(NSZone *)zone;
{
	if (self = [super initWithSource:source zone:zone]) {
		self->_id = source->_id;
		self->_revision = source->_revision;
		self->_use = source->_use;
		self->_name = source->_name;
		self->_explanation = source->_explanation;
		self->_fixed = source->_fixed;
	}

	return self;
}

+ (NSString*)idKey;
{
	return [self idKey:@"id"];
}

+ (NSString*)adhocIdKey;
{
	return [self idKey:@"adhocId"];
}

+ (NSString*)revisionKey;
{
	return [self idKey:@"revision"];
}

- (NSString*)historyId;
{
	return S2MakeDataHistoryId(_id, _revision);
}

- (S2DataRef *)latestRef;
{
	return [S2DataRef newLatestRef:self];
}

- (S2DataRef *)historyRef;
{
	return [S2DataRef newHistoryRef:self];
}

- (BOOL)isEqual:(id)object;
{
	S2DataEntity* entity = object;

	if (![entity.class isEqual:self.class]) {
		return NO;
	}
	
	return entity.id == self.id && entity.revision == self.revision;
}

- (NSComparisonResult)compareTo:(S2DataEntity*)target;
{
	if (!S2ObjectIsKindOf(target, self))
		return NSOrderedDescending;
		
	return self.id < target.id;
}

- (NSString *)description;
{
	return S2StringFormat(@"'%@:%d:%d' use=%@", NSStringFromClass(self.class), _id, _revision, _use ? @"YES" : @"NO");
}
	
@end



@implementation S2DataRef

+ (id)newLatestRefById:(int)id;
{
	return [[self alloc] initById:id revision:0];
}

+ (id)newLatestRef:(S2DataEntity*)entity;
{
	return [[self alloc] initLatestRef:entity];
}

+ (id)newHistoryRefById:(int)id revision:(int)revision;
{
	return [[self alloc] initById:id revision:revision];
}

+ (id)newHistoryRef:(S2DataEntity *)entity;
{
	return [[self alloc] initHistoryRef:entity];
}

- (id)initById:(int)id revision:(int)revision;
{
	if (self = [super init]) {
		self->_id = id;
		self->_revision = revision;
	}
	
	return self;
}

- (id)initLatestRef:(S2DataEntity*)entity;
{
	if (self = [super init]) {
		self->_entity = entity;
		self->_entityType = entity.class.entityType;
		self->_id = entity.id;
		self->_revision = 0;
	}
	
	return self;
}

- (id)initHistoryRef:(S2DataEntity*)entity;
{
	if (self = [super init]) {
		self->_entity = entity;
		self->_entityType = entity.class.entityType;
		self->_id = entity.id;
		self->_revision = entity.revision;
	}
	
	return self;
}

- (id)initWithSource:(S2DataRef*)source zone:(NSZone *)zone;
{
	if (self = [super initWithSource:source zone:zone]) {
		self->_entity = source->_entity;
		self->_entityType = source->_entityType;
		self->_id = source->_id;
		self->_revision = source->_revision;
	}
	
	return self;
}

- (NSString *)description;
{
	NSString* path;
	if (_revision == 0) {
		path = S2StringFormat(@"%@:%d:*", _entityType, _id);
	}
	else {
		path = S2StringFormat(@"%@:%d:%d", _entityType, _id, _revision);
	}
	return path;
}

- (void)serializeTo:(NSMutableDictionary*)dictionary;
{
	NSString* path;
	if (_revision == 0) {
		path = S2StringFormat(@"%@:%d:*", _entityType, _id);
	}
	else {
		path = S2StringFormat(@"%@:%d:%d", _entityType, _id, _revision);
	}
	[dictionary setObject:path forKey:@"path"];
}

- (void)deserializeFrom:(NSDictionary*)dictionary;
{
	NSString* path = [dictionary objectForKey:@"path"];
	NSArray* parts = [path componentsSeparatedByString:@":"];

	_entityType = [parts objectAtIndex:0];
	_id = [[parts objectAtIndex:1] intValue];
	_revision = S2StringEquals([parts objectAtIndex:2], @"*") ? 0 : [[parts objectAtIndex:2] intValue];
}

- (NSString *)historyId;
{
	return S2MakeDataHistoryId(_id, _revision);
}

- (id)target;
{
	return _entity;
}

- (void)fixRevision;
{
	if (_entity) {
		_revision = _entity.revision;
	}
}
	
- (void)fixEntity;
{
	if (_entity) {
		_revision = _entity.revision;
		_entity = [_entity copy];
		[_entity fixReferenceRevisions];
	}
}

- (BOOL)match:(S2DataRef*)target;
{
	if (target.revision == S2DataRevisionNil) {
		return target.id == self.id;
	}
	else {
		return target.id == self.id && target.revision == self.revision;
	}
}

@end



@implementation S2DataFormat

+ (id)new:(NSString*)formatType :(NSString*)formatVersion;
{
	return [[self alloc] initWithFormatType:formatType formatVersion:formatVersion];
}

- (id)initWithFormatType:(NSString*)formatType formatVersion:(NSString*)formatVersion;
{
	if (self = [super init]) {
		self->_formatType = formatType;
		self->_formatVersion = formatVersion;
	}
	
	return self;
}

@end



@implementation S2DateComponents

+ (id)new:(int)year :(int)month :(int)day;
{
	return [[self alloc] init:year :month :day];
}

- (id)init:(int)year :(int)month :(int)day;
{
	if (self = [super init]) {
		self->_year = year;
		self->_month = month;
		self->_day = day;
	}
	
	return self;
}

- (NSDateComponents*)toNSDateComponents;
{
	return S2DateComponentsByDate(_year, _month, _day);
}

@end



@implementation S2TimeComponents

+ (id)new:(int)hour :(int)minute :(int)second;
{
	return [[self alloc] init:hour :minute :second];
}

- (id)init:(int)hour :(int)minute :(int)second;
{
	if (self = [super init]) {
		self->_hour = hour;
		self->_minute = minute;
		self->_second = second;
	}
	
	return self;
}

- (NSDateComponents*)toNSDateComponents;
{
	return S2DateComponentsByTime(_hour, _minute, _second);
}

@end



@implementation S2DateTimeComponents

+ (id)new:(int)year :(int)month :(int)day :(int)hour :(int)minute :(int)second;
{
	return [[self alloc] init:hour :minute :second];
}

- (id)init:(int)year :(int)month :(int)day :(int)hour :(int)minute :(int)second;
{
	if (self = [super init]) {
		self->_year = year;
		self->_month = month;
		self->_day = day;
		self->_hour = hour;
		self->_minute = minute;
		self->_second = second;
	}
	
	return self;
}

- (NSDateComponents*)toNSDateComponents;
{
	return S2DateComponentsByDateTime(_year, _month, _day, _hour, _minute, _second);
}

@end



@implementation S2DataHistoryPool

- (id)init;
{
	if (self = [super init]) {
		self->_dataVersion = 1;
		self->_pool = [NSMutableDictionary new];
	}
	
	return self;
}

- (id)initWithSource:(id)source zone:(NSZone *)zone;
{
	return [super initWithSource:source zone:zone];
}

- (BOOL)isContained:(S2DataEntity*)entity;
{
	NSString* entityType = entity.class.entityType;
	NSMutableDictionary* historyPool = [_pool objectForKey:entityType];

	if (!historyPool) {
		return NO;
	}
	
	NSString* historyId = entity.historyId;
	id historyEntity = [historyPool objectForKey:historyId];
	
	return historyEntity != nil;
}

- (id)dataById:(NSString*)entityType :(NSString*)historyId;
{
	NSMutableDictionary* historyPool = [_pool objectForKey:entityType];

	if (historyPool) {
		return [historyPool objectForKey:historyId];
	}

	return nil;
}

- (id)dataByRef:(S2DataRef*)ref;
{
	return [self dataById:ref.entityType :ref.historyId];
}

- (void)setEntity:(S2DataEntity*)entity;
{
	S2AssertParameter(entity);
	
	NSString* entityType = entity.class.entityType;
	NSMutableDictionary* historyPool = [_pool objectForKey:entityType];
	
	if (!historyPool) {
		historyPool = [NSMutableDictionary new];
		_pool[entityType] = historyPool;
	}
	
	NSString* historyId = entity.historyId;
	if (historyPool[historyId])
		return;
	
	historyPool[historyId] = entity;
}

- (void)addEntity:(S2DataEntity*)entity;
{
	S2AssertParameter(entity);

	NSString* entityType = entity.class.entityType;
	NSMutableDictionary* historyPool = [_pool objectForKey:entityType];
	
	if (!historyPool) {
		historyPool = [NSMutableDictionary new];
		_pool[entityType] = historyPool;
	}
	
	NSString* historyId = entity.historyId;
	S2Assert(historyPool[historyId] == nil, @"Error: [%@:%@]は履歴プールに既に存在します。", entityType, historyId);

	historyPool[historyId] = entity;
}

- (void)removeEntity:(S2DataEntity*)entity;
{
	S2AssertParameter(entity);

	NSString* dataTypeName = entity.class.entityType;
	NSMutableDictionary* historyPool = _pool[dataTypeName];
	
	if (!historyPool) {
		return;
	}

	NSString* historyId = entity.historyId;
	[historyPool removeObjectForKey:historyId];
}

@end



BOOL S2DataRefArrayIdContains(NSArray* array, int id)
{
	for (S2DataRef* ref in array) {
		if (ref.id == id) {
			return YES;
		}
	}
	
	return NO;
}

BOOL S2DataRefArrayEquals(NSArray* array1, NSArray* array2)
{
	if (array1.count != array2.count)
		return NO;

	for (S2DataRef* ref1 in array1) {
		if (!S2DataRefArrayIdContains(array2, ref1.id)) {
			return NO;
		}
	}
	
	return YES;
}

NSMutableArray* S2DataEntityArrayToLatestRefArray(NSArray* array)
{
	if (!array) {
		return nil;
	}

	NSMutableArray* result = [NSMutableArray arrayWithCapacity:array.count];
	
	for (S2DataEntity* entity in array) {
		[result addObject:entity.latestRef];
	}
	
	return result;
}

NSMutableArray* S2DataEntityArrayToHistoryRefArray(NSArray* array)
{
	if (!array) {
		return nil;
	}
	
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:array.count];
	
	for (S2DataEntity* entity in array) {
		[result addObject:entity.historyRef];
	}
	
	return result;
}

NSMutableArray* S2DataRefArrayToEntityArray(NSArray* array)
{
	if (!array) {
		return nil;
	}
	
	NSMutableArray* result = [NSMutableArray arrayWithCapacity:array.count];
	
	for (S2DataRef* ref in array) {
		if (!ref.entity) {
			S2LogError(@"ref.entity is nil. ref is '%@'", ref);
			continue;
		}
		
		[result addObject:ref.target];
	}
	
	return result;
}

NSMutableArray* S2DataEntitySetToIndex(NSSet* set)
{
	if (!set) {
		return nil;
	}
	
	NSMutableArray* result = [NSMutableArray new];
	
	for (S2DataEntity* entity in set) {
		[result addObject:@(entity.id)];
	}
	
	return result;
}

NSMutableSet* S2DataEntitySetToLatestRefSet(NSSet* set)
{
	if (!set) {
		return nil;
	}
	
	NSMutableSet* result = [NSMutableSet set];
	
	for (S2DataEntity* entity in set) {
		[result addObject:entity.latestRef];
	}
	
	return result;
}

NSMutableSet* S2DataEntitySetToHistoryRefSet(NSSet* set)
{
	if (!set) {
		return nil;
	}
	
	NSMutableSet* result = [NSMutableSet set];
	
	for (S2DataEntity* entity in set) {
		[result addObject:entity.historyRef];
	}
	
	return result;
}

NSMutableSet* S2DataRefSetToEntitySet(NSSet* set)
{
	if (!set) {
		return nil;
	}
	
	NSMutableSet* result = [NSMutableSet set];
	
	for (S2DataRef* ref in set) {
		if (!ref.entity) {
			S2LogError(nil, @"S2DataRefSetToEntitySet", @"ref.entity is nil. ref is '%@'", ref);
			continue;
		}
		
		[result addObject:ref.target];
	}
	
	return result;
}
