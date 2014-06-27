//
//  S2HttpTask.m
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/09.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Functions.h"
#import "S2HttpTask.h"
#import "S2AppDelegate.h"



@implementation S2HttpTask

- (id)init;
{
	if (self = [super init]) {
		_requestTimeout = 30.0;
		_userAgent = @"S2HttpClient/1.0";
	}
	return self;
}

- (NSData*)callWebMethod:(NSString*)url method:(NSString*)method arguments:(NSDictionary*)arguments;
{
	NSError* error;

	NSData* requestData;
	NSString* queryString = [self makeQueryString:arguments];

	// GETパラメータのリクエストデータの作成
	if (S2StringEqualsInsensitive(method, @"GET")) {
		url = S2StringFormat(@"%@?%@", url, queryString);
		requestData = nil;

		S2EventLog(nil, @"S2HttpTask", @"Request GET: %@", url);
	}
	else if (S2StringEqualsInsensitive(method, @"POST")) {
		requestData = [queryString utf8Data];
	
		S2EventLog(nil, @"S2HttpTask", @"Request POST: %@", url);
		S2EventLog(nil, @"S2HttpTask", @"Request POST: %@", url);
	}
	else {
		@throw [S2AppException exceptionWithName:@"S2HttpTask" reason:S2StringFormat(@"'%@' invalid HTTP method.", method) userInfo:nil];
	}

	__S2DebugLog(@"S2HttpTask", @"request: %@", queryString);
	
	// HTTPリクエストを作成する
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: method];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:_userAgent forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody: requestData];
	[request setTimeoutInterval:_requestTimeout];

	// HTTPメソッドを呼び出す
	NSHTTPURLResponse* response;
	NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (error) {
		S2_LOG_BEGIN(tag:S2ClassTag)
			S2LogNSError(error);
		S2_LOG_END
		
		@throw [S2AppException exceptionWithName:error.domain reason:error.localizedDescription userInfo:error.userInfo];
	}

	S2EventLog(nil, @"S2HttpTask", @"Response %d: contentLength=%d header=%@", response.statusCode, response.expectedContentLength, response.allHeaderFields);

	return responseData;
}

- (NSData*)callJsonWebMethodReturnResonse:(NSString*)url arguments:(NSDictionary*)arguments response:(NSHTTPURLResponse**)response;
{
	NSError* error;
	
	// JSON形式のリクエストデータの作成
	NSData* requestData = arguments ? [NSJSONSerialization dataWithJSONObject:arguments options:0 error:&error] : nil;
	if (error) {
		S2_LOG_BEGIN(tag:S2ClassTag)
			S2LogNSError(error);
		S2_LOG_END
		
		@throw [S2AppException exceptionWithName:error.domain reason:error.localizedDescription userInfo:error.userInfo];
	}
	
	S2EventLog(nil, S2ClassTag, @"Request POST: %@", url);
	S2EventLog(nil, S2ClassTag, @"Request POST: %@", [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding]);
	
	// HTTPリクエストを作成する
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request setValue:_userAgent forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody: requestData];
	[request setTimeoutInterval:_requestTimeout];
	
	// HTTPメソッドを呼び出す
	NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:&error];
	if (error) {
		S2_LOG_BEGIN(tag:S2ClassTag)
			S2LogNSError(error);
		S2_LOG_END
		
		if (S2StringEquals(error.domain, NSURLErrorDomain)) {
			if (error.code == NSURLErrorNotConnectedToInternet) {
				//errorMessage = @"インターネットがオフラインのようです。";
			}
		}
		
		@throw [S2AppException exceptionWithName:error.domain reason:error.localizedDescription userInfo:error.userInfo];
	}

	return responseData;
}

- (id)callJsonWebMethod:(NSString*)url arguments:(NSDictionary*)arguments;
{
	NSHTTPURLResponse* response;
	
	NSData* responseData = [self callJsonWebMethodReturnResonse:url arguments:arguments response:&response];
	S2EventLog(nil, S2ClassTag, @"Response %d: contentLength=%d header=%@", response.statusCode, response.expectedContentLength, response.allHeaderFields);

	if (responseData.length == 0) {
		S2EventLog(nil, S2ClassTag, @"Response JSON: %@", @"(nothing)");

		@throw [S2AppException exceptionWithName:S2ClassTag reason:@"サーバーエラーが発生しました。" userInfo:nil];
	}

	S2EventLog(nil, S2ClassTag, @"Response JSON: %@", S2Utf8DataToString(responseData));

	return [self parseJsonData:responseData];
}

/*
 * データ投稿
 *
 * メソッド: POST
 * URL引数: NSDictionary -> QueryString
 * 入力: NSData
 * 出力: NSData
 */
- (NSData*)postData:(NSString*)url arguments:(NSDictionary*)arguments contents:(NSData*)contents;
{
	NSError* error;

	// 引数付きURLの作成
	NSString* queryString = [self makeQueryString:arguments];
	url = S2StringFormat(@"%@?%@", url, queryString);

	S2_LOG_BEGIN(tag:S2ClassTag)
		S2EventLog(@"Request POST: %@", url);
		S2EventLog(@"Request POST: binary - %d bytes", contents.length);
	S2_LOG_END
	
	// HTTPリクエストを作成する
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"text/plain; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request setValue:_userAgent forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody: contents];
	[request setTimeoutInterval:_requestTimeout];
	
	// HTTPメソッドを呼び出す
	NSHTTPURLResponse* response;
	NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (error) {
		S2_LOG_BEGIN(tag:S2ClassTag)
			S2LogNSError(error);
		S2_LOG_END
		
		@throw [S2AppException exceptionWithName:error.domain reason:error.localizedDescription userInfo:error.userInfo];
	}

	S2_LOG_BEGIN(tag:S2ClassTag)
		S2EventLog(@"Response %d: contentLength=%d header=%@", response.statusCode, response.expectedContentLength, response.allHeaderFields);
	S2_LOG_END

	return responseData;
}

- (NSString*)makeQueryString:(NSDictionary*)arguments;
{
	NSMutableString* string = [NSMutableString new];
	
	NSEnumerator* enumerator = [arguments.allKeys objectEnumerator];
	
	NSObject* key = [enumerator nextObject];
	NSString* value = [[arguments objectForKey:key] description];
	value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[string appendFormat:@"%@=%@", key.description, value];
	
	while (key = [enumerator nextObject]) {
		value = [[arguments objectForKey:key] description];
		value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[string appendFormat:@"&%@=%@", key.description, value];
	}
	
	return string;
}

- (id)parseJsonData:(NSData*)utf8Data;
{
	NSError* error;
	
	// JSON形式のレスポンスデータからJSONオブジェクト(NSDictionary / NSArray / ...)を作成する
	id jsonObject = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingAllowFragments error:&error];
	
	// JSONパースエラー (PHPのエラー出力も含む)
	if (error) {
		S2_LOG_BEGIN(tag:S2ClassTag)
			S2LogNSError(error);
		S2_LOG_END
		
		NSString* serverResult = S2Utf8DataToString(utf8Data);
		S2LogError(@"response is invalid JSON: %@", serverResult);

		NSException* ex = [S2AppException exceptionWithName:S2ClassTag reason:@"サーバーエラーが発生しました。" userInfo:@{@"serverResult":serverResult}];

		// エラーログを送信する
		[S2AppDelegateInstance() uploadError:S2ErrorLogType_ServerError exception:ex];
		
		@throw ex;
	}
	
	return jsonObject;
}

@end
