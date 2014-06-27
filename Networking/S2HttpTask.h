//
//  S2HttpTask.h
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/11/09.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2TaskManager.h"



@interface S2HttpTask : S2Task

@property NSTimeInterval requestTimeout;
@property NSString* userAgent;

/*
	一般的なWebメソッドコール

	メソッド: GET, POST
	URL引数: [GET] NSDictionary -> QueryString
	入力: [POST] NSDictionary -> QueryString
	出力: NSData
*/
- (NSData*)callWebMethod:(NSString*)url method:(NSString*)method arguments:(NSDictionary*)arguments;

/*
	JSON Webメソッドコール

	メソッド: POST
	URL引数: なし
	入力: NSDictionary -> JSON文字列
	出力: JSONオブジェクト (NSDictionary, NSArray, NSString, NSNumber)
*/
- (id)callJsonWebMethod:(NSString*)url arguments:(NSDictionary*)arguments;

/*
	データ投稿

	メソッド: POST
	URL引数: NSDictionary -> QueryString
	入力: NSData
	出力: NSData
*/
- (NSData*)postData:(NSString*)url arguments:(NSDictionary*)arguments contents:(NSData*)contents;

- (NSString*)makeQueryString:(NSDictionary*)arguments;
- (NSData*)callJsonWebMethodReturnResonse:(NSString*)url arguments:(NSDictionary*)arguments response:(NSHTTPURLResponse**)response;
- (id)parseJsonData:(NSData*)utf8Data;

@end
