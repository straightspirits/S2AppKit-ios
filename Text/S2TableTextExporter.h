//
//  S2TableTextExporter.h
//  S2AppKit/S2TextKit
//
//  Created by Fumio Furukawa on 2012/12/02.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"
#import "S2StringTable.h"


//extern NSString* S2TextEscape(NSString* string);


@class S2TableTextExporter;



typedef enum _SSTextSeparateFormat {
	S2TextSeparateFormatUnknown,
	S2TextSeparateFormatTab,
	S2TextSeparateFormatComma
} S2TextSeparateFormat;



@protocol S2TableTextExporterDelegate <NSObject>

//@optional
- (void)exporter:(S2TableTextExporter*)exporter started:(NSString*)message;
- (void)exporter:(S2TableTextExporter*)exporter progressUpdated:(NSString*)message;
- (void)exporter:(S2TableTextExporter*)exporter finished:(NSString*)message seconds:(NSTimeInterval)seconds;

@end



@interface S2TableColumn : NSObject

@property NSString* name;
@property id subId;
@property (readonly) NSString* id;

@end



@interface S2TableTextExporter : NSObject

@property (readonly) NSString* defaultFileName;
@property S2TextSeparateFormat format;
@property (readonly) NSString* fileExtension;	// ".txt" or ".csv"
@property S2StringTable* stringTable;
@property NSString* localizedKeyPrefix;
@property NSTimeInterval waitSecondsAfterFinish;
@property id<S2TableTextExporterDelegate> delegate;

- (void)run;
- (void)runAsync;

- (void)notifyStarted:(NSString*)message;
- (void)notifyProgressUpdated:(NSString*)message;
- (void)notifyFinished:(NSString*)message;

- (NSArray*)columnsByNames:(NSArray*)columnNames tableData:(NSArray*)tableData;
- (void)exportTextFile:(NSString*)filePath properties:(NSArray*)properties columns:(NSArray*)columns tableData:(NSArray*)tableData;

// override point
- (NSString*)subTitleForColumn:(S2TableColumn*)column;

@end
