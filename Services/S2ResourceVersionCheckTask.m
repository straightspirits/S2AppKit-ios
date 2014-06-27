//
//  S2ResourceVersionCheckTask.m
//  S2AppKit/S2ServiceKit
//
//  Created by Fumio Furukawa on 2013/02/07.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "S2ResourceVersionCheckTask.h"
#import "S2UIKit.h"



static __weak S2AlertView* _lastAlertView;



@implementation S2ResourceVersionCheckTask {
}

- (BOOL)runOnBackground;
{
	return YES;
}

- (void)prepare;
{
	[_lastAlertView dismissWithClickedButtonIndex:_lastAlertView.cancelButtonIndex animated:NO];
}

- (S2TaskFinishType)main;
{
	// PLIST取得
	NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:self.plistUrl];
	if (!plist) {
		[self callCheckFailed:@"リソースのメタデータの取得に失敗しました。"];
		return S2TaskFinishAbort;
	}

	NSArray* items = plist[@"items"];
	if (!items) {
		[self callCheckFailed:@"リソースのメタデータの取得に失敗しました。"];
		return S2TaskFinishAbort;
	}
	NSDictionary* item = items[0];

	NSDictionary* metadata = item[@"metadata"];
	if (!metadata) {
		[self callCheckFailed:@"リソースのメタデータの取得に失敗しました。"];
		return S2TaskFinishAbort;
	}

	// リリース中のバージョン番号を取得する
	NSString* releaseBundleIdentifier = metadata[@"bundle-identifier"];
	NSString* releaseVersion = metadata[@"bundle-version"];

	S2LogPass(nil, @"resource '%@': identifier='%@' latest version='%@'", self.resourceName, releaseBundleIdentifier, releaseVersion);
	
	// バージョンが違うなら
	if (releaseVersion && !S2StringEquals(self.currentVersion, releaseVersion)) {
		// MEMO バージョン文字列の最後のパートが8桁の日付になってる
		NSString* currentVersionDate = [[self.currentVersion componentsSeparatedByString:@"."] lastObject];
		NSString* releaseVersionDate = [[releaseVersion componentsSeparatedByString:@"."] lastObject];
		
		// 日付が新しければ、最新バージョンがあるとみなす
		if (currentVersionDate.integerValue < releaseVersionDate.integerValue) {
			[self performSelectorOnMainThread:@selector(detectedNewVersion:) withObject:releaseVersion waitUntilDone:NO];
		}
		else {
			[self performSelectorOnMainThread:@selector(detectedSameVersion) withObject:nil waitUntilDone:NO];
		}
	}
	else {
		[self performSelectorOnMainThread:@selector(detectedSameVersion) withObject:nil waitUntilDone:NO];
	}
	
	return S2TaskFinishComplete;
}

- (void)callCheckFailed:(NSString *)message;
{
	[self performSelectorOnMainThread:@selector(checkFailed:) withObject:message waitUntilDone:NO];
}

- (void)detectedSameVersion;
{
	if (!self.silentCheck) {
		_lastAlertView = [S2AlertView show_title:@"アップデートの確認" message:@"最新バージョンです。"];
	}
}

- (void)detectedNewVersion:(NSString *)releaseVersion;
{
	S2AssertMustOverride();
}

- (void)checkFailed:(NSString *)message;
{
	if (!self.silentCheck) {
		_lastAlertView = [S2AlertView show_title:@"アップデートの確認" message:message];
	}

	S2LogError(nil, S2ClassTag, @"%@", message);
}

@end



@implementation S2ApplicationVersionCheckTask

- (void)detectedSameVersion;
{
	if (!self.silentCheck) {
		_lastAlertView = [S2AlertView show_title:@"アップデートの確認"
					   message:S2StringFormat(@"お使いの %@ は最新バージョン %@ です。", self.resourceName, self.currentVersion)];
	}
}

- (void)detectedNewVersion:(NSString*)releaseVersion;
{
	NSString* cancelButtonTitle = self.forceUpdate ? nil : @"後で";
	NSString* updateButtonTitle = @"アップデート";
	
	S2AlertView* alertView = [[S2AlertView alloc]
		init_title:@"アップデートがあります"
		message:S2StringFormat(@"%@ が新しくなりました。\nバージョン %@ にアップデートしてください。", self.resourceName, releaseVersion)
		closure:^(S2AlertView *view, NSInteger buttonIndex) {
			if (buttonIndex == view.cancelButtonIndex) {
				return;
			}

			[self doUpdate];
			
			// アプリケーションを終了する
			if (self.forceUpdate) {
				exit(1);
			}
		}
		cancelButtonTitle:cancelButtonTitle otherButtonTitles:updateButtonTitle, nil
	];
	[alertView show];
	
	_lastAlertView = alertView;
}

- (BOOL)doUpdate;
{
	NSString* kickUrl = S2StringFormat(@"itms-services://?action=download-manifest&url=%@", self.plistUrl.absoluteString);
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kickUrl]];
}

@end