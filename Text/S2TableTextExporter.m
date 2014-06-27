//
//  S2TableTextExporter.m
//  S2AppKit/S2TextKit
//
//  Created by Fumio Furukawa on 2012/12/02.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2TableTextExporter.h"
#import "S2Functions.h"
#import "S2Logger.h"



NSString* S2TextEscape(NSString* string)
{
	return S2StringFormat(@"\"%@\"", string);
}



@implementation S2TableColumn

- (NSString *)id;
{
	if (self.subId) {
		return S2StringFormat(@"%@:%@", self.name, self.subId);
	}
	else {
		return self.name;
	}
}

@end



@implementation S2TableTextExporter {
	int _exportCount;
}

- (id)init;
{
	if (self = [super init]) {
		_format = S2TextSeparateFormatTab;
		_waitSecondsAfterFinish = 2.0;
		_exportCount = 0;
	}
	return self;
}

- (NSString *)defaultFileName;
{
	return S2StringRemoveSuffix(self.className, @"Exporter");
}

- (NSString *)fileExtension;
{
	switch (self.format) {
		case S2TextSeparateFormatTab:
			return @".tsv";
			
		case S2TextSeparateFormatComma:
			return @".csv";
			
		default:
			return nil;
	}
}

- (NSString *)separator;
{
	switch (self.format) {
		case S2TextSeparateFormatTab:
			return @"\t";
			
		case S2TextSeparateFormatComma:
			return @",";
			
		default:
			return nil;
	}
}

- (NSString *)escape:(NSString*)string;
{
	switch (self.format) {
		case S2TextSeparateFormatTab:
			// '\', '\n', '"' をエスケープする
			if (S2StringMatch(string, @"[\\\\\n\"]")) {
				string = S2StringReplace(string, @"\\\\", @"\\\\\\\\");
				string = S2StringReplace(string, @"\n", @"\r");		// エスケープ中の改行文字は\rのようだ。
				string = S2StringReplace(string, @"\"", @"\"\"");
				return S2TextEscape(string);
			}
			break;

		case S2TextSeparateFormatComma:
			return S2TextEscape(string);
			
		default:
			break;
	}

	return string;
}

- (void)run;
{
	S2AssertMustOverride();
}

- (void)runAsync;
{
	[self performSelectorInBackground:@selector(run) withObject:nil];
}

- (void)notifyStarted:(NSString*)message;
{
	[self performSelectorOnMainThread:@selector(started:) withObject:message waitUntilDone:NO];
}

- (void)notifyProgressUpdated:(NSString*)message;
{
	[self performSelectorOnMainThread:@selector(progressUpdated:) withObject:message waitUntilDone:NO];
}

- (void)notifyFinished:(NSString*)message;
{
	[self performSelectorOnMainThread:@selector(finished:) withObject:message waitUntilDone:NO];
}

- (void)started:(NSString*)message;
{
	[self.delegate exporter:self started:message];
}

- (void)progressUpdated:(NSString*)message;
{
	[self.delegate exporter:self progressUpdated:message];
}

- (void)finished:(NSString*)message;
{
	[self.delegate exporter:self finished:message seconds:self.waitSecondsAfterFinish];
}

#pragma mark -

- (NSArray*)columnsByNames:(NSArray*)columnNames tableData:(NSArray*)tableData;
{
	// カラム配列を作成する
	NSMutableArray* columns1 = [NSMutableArray new];
	
	for (NSString* columnName in columnNames) {
		NSMutableOrderedSet* subColumnIds = [NSMutableOrderedSet new];

		// サブデータを持つカラムは、サブ配列に置き換える
		for (NSDictionary* recordData in tableData) {
			id columnData = recordData[columnName];
			if (S2ObjectIsKindOf(columnData, NSDictionary)) {
				NSDictionary* subColumnData = columnData;
				
				for (id key in subColumnData.allKeys.sortedArray) {
					[subColumnIds addObject:key];
				}
			}
		}

		if (subColumnIds.count > 0) {
			NSMutableArray* subColumns = [NSMutableArray new];
			for (id subColumnId in subColumnIds) {
				S2TableColumn* column = [S2TableColumn new];
				column.name = columnName;
				column.subId = subColumnId;
				[subColumns addObject:column];
			};
			[columns1 addObject:subColumns];
		}
		else {
			S2TableColumn* column = [S2TableColumn new];
			column.name = columnName;
			column.subId = nil;
			[columns1 addObject:column];
		}
	}

	// カラムをフラットに展開する
	NSMutableArray* columns2 = [NSMutableArray new];

	for (id column in columns1) {
		if (S2ObjectIsKindOf(column, NSArray)) {
			NSArray* subColumns = column;
			for (id subColumn in subColumns) {
				[columns2 addObject:subColumn];
			}
		}
		else {
			[columns2 addObject:column];
		}
	}
	
	return columns2;
}

- (void)exportTextFile:(NSString*)filePath properties:(NSArray*)properties columns:(NSArray*)columns tableData:(NSArray*)tableData;
{
	if (_exportCount == 0) {
		// BOMヘッダ付き空ファイルを作成する
		[[NSFileManager defaultManager] createFileAtPath:filePath contents:NSData.utf16LEBom attributes:nil];
	}
	
	NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:filePath];
	
	if (!file) {
		S2LogError(nil, S2ClassTag, @"file open error: %@", filePath);
		return;
	}

	// ポインタをファイル末尾に移動する
	[file seekToEndOfFile];
	
	// ヘッダーの出力
	[self writePropertyLines:file properties:properties];
	[self writeColumnIdsLine:file columns:columns];
	[self writeColumnTitlesLine:file columns:columns];
	[self writeColumnSubTitlesLine:file columns:columns];
	
	// データの出力
	for (NSDictionary* recordData in tableData) {
		[self writeRecordLine:file columns:columns recordData:recordData];
	}
	
	// フッターの出力
	[self writeTextLine:file rowType:@"End" values:nil];
	[self writeTextLine:file rowType:@"" values:nil];
	
	[file closeFile];
	
	++_exportCount;
}

- (void)writePropertyLines:(NSFileHandle*)fileHandle properties:(NSArray*)properties;
{
	for (NSArray* propertyData in properties) {
		[self writeTextLine:fileHandle rowType:[self escape:@"Property"] values:propertyData];
	}
}

- (void)writeColumnIdsLine:(NSFileHandle*)fileHandle columns:(NSArray*)columns;
{
	NSMutableArray* columnIds = [NSMutableArray arrayWithCapacity:columns.count];

	for (S2TableColumn* column in columns) {
		[columnIds addObject:column.id];
	}
	
	[self writeTextLine:fileHandle rowType:[self escape:@"ColumnIds"] values:columnIds];
}

- (void)writeColumnTitlesLine:(NSFileHandle*)fileHandle columns:(NSArray*)columns;
{
	NSMutableArray* columnTitles = [NSMutableArray arrayWithCapacity:columns.count];

	for (S2TableColumn* column in columns) {
		[columnTitles addObject:[self localizedString:column.name]];
	}

	[self writeTextLine:fileHandle rowType:[self escape:@"ColumnTitles"] values:columnTitles];
}

- (NSString*)localizedString:(NSString*)key;
{
	S2AssertNonNil(self.stringTable);
	return [self.stringTable localizedString:S2StringConcat(self.localizedKeyPrefix, key) defaultValue:key];
}

- (void)writeColumnSubTitlesLine:(NSFileHandle*)fileHandle columns:(NSArray*)columns;
{
	NSMutableArray* columnSubTitles = [NSMutableArray arrayWithCapacity:columns.count];

	for (S2TableColumn* column in columns) {
		[columnSubTitles addObject:column.subId ? [self subTitleForColumn:column] : @""];
	}

	[self writeTextLine:fileHandle rowType:[self escape:@"ColumnSubTitles"] values:columnSubTitles];
}

- (void)writeRecordLine:(NSFileHandle*)fileHandle columns:(NSArray*)columns recordData:(NSDictionary*)recordData;
{
	NSMutableArray* values = [NSMutableArray arrayWithCapacity:columns.count];

	for (S2TableColumn* column in columns) {
		NSString* columnData = [self recordData:recordData valueForColumn:column];

		[values addObject:columnData];
	}
	
	[self writeTextLine:fileHandle rowType:[self escape:@"Record"] values:values];
}

- (NSString*)recordData:(NSDictionary*)recordData valueForColumn:(S2TableColumn*)column;
{
	NSObject* columnData = recordData[column.name];

	// カラムデータがNSDictionaryなら
	if (S2ObjectIsKindOf(columnData, NSDictionary)) {
		NSDictionary* subColumnData = (NSDictionary*)columnData;
		
		columnData = subColumnData[column.subId];
	}

	if (!columnData || S2ObjectIsNSNull(columnData)) {
		return @"";
	}
	
	// オブジェクトを文字列化する
	return S2ObjectToString(columnData);
}

- (void)writeTextLine:(NSFileHandle*)fileHandle rowType:(NSString*)rowType values:(NSArray*)values;
{
	NSMutableString* line = [NSMutableString new];
	
	[line appendString:rowType];

	for (NSObject* value in values) {
		[line appendString:self.separator];
		[line appendString:value && !S2ObjectIsNSNull(value) ? [self escape:S2ObjectToString(value)] : @""];
	}

	[line appendString:@"\r\n"];
	
	[fileHandle writeData:[line dataUsingEncoding:NSUTF16LittleEndianStringEncoding]];
}

// override point
- (NSString*)subTitleForColumn:(S2TableColumn*)column;
{
	return S2ObjectToString(column.subId);
}

@end
