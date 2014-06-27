//
//  S2Sockets.h
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/12/10.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Objc.h"



typedef enum _S2NetworkAddressType {
	S2NetworkAddressUnknown,
	S2NetworkAddressIPv4,
	S2NetworkAddressIPv6,
	S2NetworkAddressNamedHost,
} S2NetworkAddressType;



@interface S2NetworkAddress : NSObject

+ (S2NetworkAddressType)addressType:(NSString*)address;

+ (id)newWithHostNameOrIpAddress:(NSString*)hostNameOrIpAddress portNo:(int)portNo;
+ (id)newWithIpAddress:(NSString*)ipAddress portNo:(int)portNo;

@property NSString* ipAddress;
@property NSString* hostName;
@property int portNo;

@end



@interface S2Socket : NSObject {
	@package
	int _handle;
}

- (void)setOption :(int)layer :(int)key boolValue:(BOOL)value;
- (void)close;

@end


@interface S2UdpSocket : S2Socket

+ (BOOL)send:(NSData*)data to:(S2NetworkAddress*)address error:(NSError**)error;
+ (BOOL)sendBroadcast:(NSData*)data to:(int)portNo error:(NSError**)error;

- (void)bind;

@end
