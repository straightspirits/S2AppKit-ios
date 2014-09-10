//
//  S2Label.h
//  S2AppKit/S2UIKit
//
//  Created by Fumio Furukawa on 2014/09/11.
//  Copyright (C) 2014 Straight Spirits Co. Ltd. All rights reserved.
//

#import "UIKit+S2AppKit.h"



/* 縦揃えの種類 */
typedef enum {
	S2TextVerticalAlignmentTop = 0,
	S2TextVerticalAlignmentMiddle,
	S2TextVerticalAlignmentBottom,
} S2TextVerticalAlignment;



@interface S2Label : UILabel

@property S2TextVerticalAlignment textVerticalAlignment;

@end
