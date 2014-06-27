//
//  S2TaskManager.m
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/03.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Functions.h"
#import "S2TaskManager.h"
#import "S2Logger.h"
#import "S2Platforms.h"
#import "S2JSONSerialization.h"



NSString* S2TaskFinishTypeString(S2TaskFinishType finishType)
{
	switch (finishType) {
		case S2TaskFinishComplete:
			return @"Complete";

		case S2TaskFinishRetrySoon:
			return @"RetrySoon";
			
		case S2TaskFinishRetryAfter:
			return @"RetryAfter";
			
		case S2TaskFinishAbort:
			return @"Abort";
			
		case S2TaskFinishContinue:
			return @"Continue";

		default:
			return @"???";
	}
}



@interface S2TaskManager ()

//- (void)removeTask:(S2Task*)task;

- (void)runNextTask;
- (void)finishTask:(S2Task*)task finishType:(S2TaskFinishType)type;

- (void)loadTaskQueue;
- (void)saveTaskQueue;
- (void)deleteTaskQueueFile;

@end



@implementation S2Task {
	@package
	S2TaskManager* _manager;
	NSTimer* _tryLimitTimer;
}

- (id)init;
{
	if (self = [super init]) {
	}
	return self;
}

- (id)initWithSource:(S2Task*)source zone:(NSZone *)zone;
{
	if (self = [self init]) {
		_manager = source->_manager;
	}
	return self;
}

- (NSString *)name;
{
	return NSStringFromClass(self.class);
}

- (BOOL)runOnBackground;
{
	return NO;
}

- (NSTimeInterval)tryLimitTimeout;
{
	return 0.0;
}

- (void)prepare;
{
}

- (void)run;
{
	@try {
		S2TaskFinishType finishType = [self main];
		[self finish:finishType];
	}
	@catch (NSException* ex) {
		[self finish:S2TaskFinishAbort];
	}
}

- (S2TaskFinishType)main;
{
	S2AssertMustOverride();
	return S2TaskFinishAbort;
}

// 試行期限に達した
- (void)tryLimitExpired;
{
	NSError* error = [NSError errorWithDomain:@"S2TaskManager" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"タイムアウトしました。"}];

	S2_LOG_BEGIN(tag:S2ClassTag)
		S2LogNSError(error);
	S2_LOG_END

	[self interrupted:error];
}

- (void)interrupted:(NSError*)error;
{
	// optional override point
	S2LogPass(@"error:%@", error);
}

- (void)availableChanged:(BOOL)available;
{
	// optional override point
	__S2DebugLog(@"S2TaskManager", @"availableChanged:%@", available ? @"YES" : @"NO");
}

- (void)finish:(S2TaskFinishType)finishType;
{
	// 継続中
	if (finishType == S2TaskFinishContinue) {
		return;
	}
	
	// 試行期限検知タイマーを止める
	[_tryLimitTimer invalidate];
//	_tryLimitTimer = nil;		// MEMO [NSTimer release]が呼ばれてはいけない！！

	[_manager finishTask:self finishType:finishType];
}

- (void)cancel;
{
	NSError* error = [NSError errorWithDomain:@"S2TaskManager" code:-2 userInfo:@{NSLocalizedDescriptionKey:@"キャンセルされました。"}];
	
	S2_LOG_BEGIN(tag:S2ClassTag)
		S2LogNSError(error);
	S2_LOG_END
	
	[self interrupted:error];
}

@end



@implementation S2TaskManager {
	NSLock* _lock;
	NSMutableArray* _taskQueue;
}

static S2TaskManager* _instance;

+ (NSString*)taskFolderPath;
{
	NSString* path = S2PathConcat(S2IOS.libraryDirectoryPath, @"Tasks");

	NSError* error;
	[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];

	return path;
}

+ (S2TaskManager *)instance;
{
	if (!_instance) {
		_instance = [S2TaskManager new];
		[_instance prepare];
	}
	return _instance;
}

- (id)init;
{
	if (self = [super init]) {
		_lock = [NSLock new];
		_taskQueue = [NSMutableArray new];
	}
	return self;
}

- (void)prepare;
{
	@try {
		[self loadTaskQueue];
	}
	@catch (NSException* ex) {
		S2_LOG_BEGIN(tag:S2ClassTag)
			S2LogError(@"%@", ex);
		S2_LOG_END
	}
}

- (void)run;
{
	if (self.available)
		[self runNextTask];
}

- (void)runOnce:(S2Task*)task;
{
	[self runTask:task];
}

- (void)addTask:(S2Task*)task;
{
	S2AssertParameter(task);

	task->_manager = self;

	BOOL runSoon;
	
	[_lock lock];
	{
		runSoon = _taskQueue.count == 0/* && self.available*/;
		
		// リストに追加する
		[_taskQueue addObject:task];

		// タスクキューをファイルに保存する
		[self saveTaskQueue];
	}
	[_lock unlock];

	if (runSoon) {
		[self runNextTask];
	}
}

- (void)removeTask:(S2Task*)task;
{
	S2AssertParameter(task);

	[_lock lock];
	{
		// リストから削除する
		[_taskQueue removeObject:task];
		__S2DebugLog(S2ClassTag, @"taskQueue: %@", _taskQueue);

		// タスクキューをファイルに保存する
		[self saveTaskQueue];
	}
	[_lock unlock];
}

- (void)readdTask:(S2Task*)task;
{
	S2Task* newTask = [task copy];
	
	[_lock lock];
	{
		// 今のタスクをリストから削除する
		[_taskQueue removeObject:task];
		
		// 新しいタスクをリストに追加する
		[_taskQueue insertObject:newTask atIndex:0];
		__S2DebugLog(S2ClassTag, @"taskQueue: %@", _taskQueue);
	}
	[_lock unlock];
}

- (void)runNextTask;
{
	S2Task* nextTask;

	[_lock lock];
	{
		// 先頭のタスクを取得する
		if (_taskQueue.count > 0)
			nextTask = [_taskQueue objectAtIndex:0];
	}
	[_lock unlock];

	// タスクを実行する
	if (nextTask) {
		_currentTask = nextTask;
		[self runTask:nextTask];
	}
}

- (void)runTask:(S2Task*)task;
{
	[task prepare];

	// 試行期限検知用タイマーを設定する
	NSTimeInterval tryLimitTimeout = task.tryLimitTimeout;
	if (tryLimitTimeout > 0.0) {
		task->_tryLimitTimer = [NSTimer scheduledTimerWithTimeInterval:tryLimitTimeout target:task selector:@selector(tryLimitExpired) userInfo:nil repeats:NO];
		
		S2LogPass(@"tryLimitTimeout:%0.1f", tryLimitTimeout);
	}

	if (task.runOnBackground)
		[task performSelectorInBackground:@selector(run) withObject:nil];
	else
		[task run];
}

- (void)finishTask:(S2Task*)task finishType:(S2TaskFinishType)type;
{
	S2AssertParameter(task == _currentTask);

	_currentTask = nil;

	switch (type) {
		case S2TaskFinishComplete:
			S2LogPass(@"finishType:Complete");
			[self removeTask:task];
			[self runNextTask];
			break;
			
		case S2TaskFinishRetrySoon:
			S2LogPass(@"finishType:RetrySoon");
			[self readdTask:task];
			[self runNextTask];
			break;

		case S2TaskFinishRetryAfter:
			S2LogPass(@"finishType:RetryAfter");
			[self readdTask:task];
			break;
			
		case S2TaskFinishAbort:
			S2LogPass(@"finishType:Abort");
			[self removeTask:task];
			[self runNextTask];
			break;
			
		default:
			__S2DebugLog(@"S2TaskManager", @"[ERROR] invalid (S2TaskFinishType)type: %d", type);
			break;
	}
}

- (NSString*)taskQueueFilePath;
{
	NSString* fileName = S2StringFormat(@"%@.task.data", NSStringFromClass(self.class));
	return S2PathConcat(S2TaskManager.taskFolderPath, fileName);
}

- (void)loadTaskQueue;
{
	NSString* taskQueueFilePath = self.taskQueueFilePath;

	// ロードしない
	if (!taskQueueFilePath)
		return;
	
	// JSONデータファイルを読み込む
	NSError* error;
	NSData* jsonData = [NSData dataWithContentsOfFile:taskQueueFilePath options:0 error:&error];

	if (error) {
//		__S2DebugLog(@"S2TaskManager", @"%@", error.localizedDescription);
//		@throw [NSException exceptionWithName:@"S2TaskLoadFailed"
//									   reason:S2StringFormat(@"json data file '%@' is not found.", taskQueueFilePath)
//									 userInfo:nil];
		[self saveTaskQueue];
		return;
	}
	
	// オブジェクトをロードする
	NSArray* taskQueue = [S2JSONSerialization objectWithJsonUTF8Data:jsonData];

	for (S2Task* task in taskQueue) {
		if (!S2ObjectIsKindOf(task, S2Task)) {
			@throw [NSException exceptionWithName:@"S2TaskLoadFailed"
										   reason:S2StringFormat(@"json data is not '%@[]' from file '%@'", NSStringFromClass(task.class), taskQueueFilePath)
										 userInfo:nil];
		}
		
		task->_manager = self;
	}

	_taskQueue = [NSMutableArray arrayWithArray:taskQueue];
}

- (void)saveTaskQueue;
{
	NSString* taskQueueFilePath = self.taskQueueFilePath;

	// 保存しない
	if (!taskQueueFilePath)
		return;

	// オブジェクトをセーブする
	NSError* error;
	[[S2JSONSerialization jsonUTF8DataWithObject:_taskQueue] writeToFile:taskQueueFilePath options:0 error:&error];

	if (error) {
		__S2DebugLog(@"S2TaskManager", @"%@", error.localizedDescription);
		@throw [NSException exceptionWithName:@"S2TaskSaveFailed"
									   reason:S2StringFormat(@"json data file '%@' cannot created.", taskQueueFilePath)
									 userInfo:nil];
	}
}

- (void)deleteTaskQueueFile;
{
	NSString* taskQueueFilePath = self.taskQueueFilePath;
	
	NSError* error;
	[[NSFileManager defaultManager] removeItemAtPath:taskQueueFilePath error:&error];

	if (error) {
		__S2DebugLog(@"S2TaskManager", @"%@", error.localizedDescription);
		@throw [NSException exceptionWithName:@"S2TaskDeleteFailed"
									   reason:S2StringFormat(@"json data file '%@' cannot deleted.", taskQueueFilePath)
									 userInfo:nil];
	}
}

- (BOOL)available;
{
	return NO;
}

@end
