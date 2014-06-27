//
//  S2Sockets.m
//  S2AppKit/S2Foundation
//
//  Created by Fumio Furukawa on 2012/12/10.
//  Copyright (c) 2012年 Straight Spirits. All rights reserved.
//

#import "S2Sockets.h"
#import "S2Functions.h"
#import <CFNetwork/CFNetwork.h>
#import <netinet/in.h>
#import <arpa/inet.h>



@implementation S2NetworkAddress {
	NSString* _address;	// ip-v4 or ip-v6 or host
}

+ (S2NetworkAddressType)addressType:(NSString*)address;
{
	if (S2StringMatch(address, @"^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$")) {
		return S2NetworkAddressIPv4;
	}
	else if (S2StringMatch(address, @"^[a-f0-9]{1,4}:[a-f0-9]{1,4}:[a-f0-9]{1,4}:[a-f0-9]{1,4}:[a-f0-9]{1,4}:[a-f0-9]{1,4}:[a-f0-9]{1,4}:[a-f0-9]{1,4}$")) {
		return S2NetworkAddressIPv6;
	}
	else if (S2StringMatch(address, @"^[0-9a-zA-Z].+$")) {
		return S2NetworkAddressNamedHost;
	}
	else {
		return S2NetworkAddressUnknown;
	}
}

+ (id)newWithHostNameOrIpAddress:(NSString*)hostNameOrIpAddress portNo:(int)portNo;
{
	return [[self alloc] initWithIpAddress:hostNameOrIpAddress portNo:portNo];
}

+ (id)newWithIpAddress:(NSString*)ipAddress portNo:(int)portNo;
{
	return [[self alloc] initWithIpAddress:ipAddress portNo:portNo];
}

- (id)initWithIpAddress:(NSString*)ipAddress portNo:(int)portNo;
{
	if (self = [self init]) {
		_address = ipAddress;
		_portNo = portNo;
	}
	return self;
}

- (NSString *)ipAddress;
{
	return _address;
}

- (void)setIpAddress:(NSString *)ipAddress;
{
	_address = ipAddress;
}

- (NSString *)hostName;
{
	return _address;
}

- (void)setHostName:(NSString *)hostName;
{
	_address = hostName;
}

- (void)getSockAddrIn:(struct sockaddr_in*)addr;
{
	const char* address = [_address cStringUsingEncoding:NSASCIIStringEncoding];
	
	memset(addr, 0, sizeof(*addr));
	addr->sin_family = AF_INET;
	addr->sin_port = htons(_portNo);
	addr->sin_addr.s_addr = inet_addr(address);
}

@end



@implementation S2Socket

- (void)setOption :(int)layer :(int)key boolValue:(BOOL)value;
{
	setsockopt(_handle, layer, key, &value, sizeof(value));
}

- (void)close;
{
	close(_handle);
}

@end



@implementation S2UdpSocket

+ (BOOL)send:(NSData*)data to:(S2NetworkAddress*)address error:(NSError**)error;
{
	BOOL result = YES;
	
	struct sockaddr_in addr;
	[address getSockAddrIn:&addr];
	
	int sock = socket(PF_INET, SOCK_DGRAM, 0);
	
	if (sendto(sock, data.bytes, data.length, 0, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
		result = NO;
		int errorCode = errno;
		NSDictionary* userInfo = @{
			NSLocalizedDescriptionKey:[NSString stringWithUTF8String:strerror(errorCode)]
		};
		*error = [NSError errorWithDomain:@"Socket" code:errorCode userInfo:userInfo];
	}
	
	close(sock);
	
	return result;
}

+ (BOOL)sendBroadcast:(NSData*)data to:(int)portNo error:(NSError**)error;
{
	BOOL result = YES;
	
	struct sockaddr_in addr;
	memset(&addr, 0, sizeof(addr));
	addr.sin_family = AF_INET;
	addr.sin_port = htons(portNo);
	addr.sin_addr.s_addr = htonl(INADDR_BROADCAST);

	int sock = socket(AF_INET, SOCK_DGRAM, 0);

	int yes = 1;
	setsockopt(sock, SOL_SOCKET, SO_BROADCAST, &yes, sizeof(yes));

	if (sendto(sock, data.bytes, data.length, 0, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
		result = NO;
		int errorCode = errno;
		NSDictionary* userInfo = @{
			NSLocalizedDescriptionKey:[NSString stringWithUTF8String:strerror(errorCode)]
		};
		*error = [NSError errorWithDomain:@"Socket" code:errorCode userInfo:userInfo];
	}
	
	close(sock);
	
	return result;
}

- (void)bind;
{
	
}

@end
