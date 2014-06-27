//
//  S2UIModel.m
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/22.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2UIModel.h"



@implementation S2UIModel {
	NSDictionary* _appPrivateSettings;
}

+ (id)new:(NSDictionary *)appPrivateSettings;
{
	return [[self alloc] init:appPrivateSettings];
}

- (id)init:(NSDictionary *)appPrivateSettings;
{
	if (self = [super init]) {
		_appPrivateSettings = appPrivateSettings;
	}
	return self;
}

- (void)mergeAppPrivateSettings:(NSURL*)jsonUrl;
{
	// TODO
}

- (NSDictionary *)appPrivateSettings;
{
	return _appPrivateSettings;
}

@end
