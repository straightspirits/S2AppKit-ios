//
//  S2Pair.h
//  S2AppKit/S2Founcation
//
//  Created by Fumio Furukawa on 2013/01/05.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



@interface S2Pair : NSObject

+ (id)new:(id)key value:(id)value;
- (id)init:(id)key value:(id)value;

@property id key;
@property id value;

@end
