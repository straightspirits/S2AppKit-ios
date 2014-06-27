//
//  S2UIModel.h
//  S2AppKit/S2UICase
//
//  Created by 古川 文生 on 12/07/22.
//  Copyright (c) 2012年 Straight Splirits Co. Ltd. All rights reserved.
//

#import "S2Foundation.h"



@interface S2UIModel : S2Model

+ (id)new:(NSDictionary *)appPrivateSettings;

@property (readonly) NSDictionary* appPrivateSettings;

@end
