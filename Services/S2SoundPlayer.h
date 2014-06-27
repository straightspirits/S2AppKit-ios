//
//  SSSoundPlayer.h
//	SSFoundation
//
//  Created by Fumio Furukawa on 2012/11/09.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum _S2SoundErrorType {
	S2SoundErrorShort,
	S2SoundErrorLong,
} S2SoundErrorType;



@protocol S2SoundPlayer <NSObject>

- (void)jingle:(NSString*)soundName;
- (void)jingleTouch;
- (void)jingleError:(SSSoundErrorType)type;
- (void)speak:(NSString*)text;

@end
