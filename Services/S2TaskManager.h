//
//  S2TaskManager.h
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/03.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"
#import "S2Data.h"

@class S2Task, S2TaskManager;



typedef enum _S2TaskFinishType {
	S2TaskFinishComplete,
	S2TaskFinishRetrySoon,
	S2TaskFinishRetryAfter,
	S2TaskFinishAbort,
	S2TaskFinishContinue,
} S2TaskFinishType;

extern NSString* S2TaskFinishTypeString(S2TaskFinishType finishType);



@interface S2Task : S2DataObject

- (id)init;

// タスク名
@property (readonly) NSString* name;

// バックグランドで動作させるか
@property (readonly) BOOL runOnBackground;

// 試行期限
@property (readonly) NSTimeInterval tryLimitTimeout;

- (void)run;
- (void)cancel;

@end

@interface S2Task (Internal)

- (void)prepare;				// run on Main-Thread
- (S2TaskFinishType)main;		// run on Main/Background Thread
- (void)interrupted:(NSError*)error;
- (void)availableChanged:(BOOL)available;
- (void)finish:(S2TaskFinishType)type;

@end



@interface S2TaskManager : NSObject {
	@protected
	S2Task* _currentTask;
}

+ (NSString*)taskFolderPath;

+ (S2TaskManager*)instance;

- (NSString*)taskQueueFilePath;

- (void)prepare;

- (void)run;

- (void)runOnce:(S2Task*)task;

- (void)addTask:(S2Task*)task;

- (BOOL)available;

@property (readonly) S2Task* currentTask;

@end



