//
//  UIDevice+Extensions.m
//  S2AppKit/S2UIKit
//
//  Created by ふみお on 2013/01/26.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import "UIDevice+Extensions.h"
#import "S2Functions.h"
#import "S2Keychain.h"


@implementation UIDevice (Orientation)

- (CGFloat)orientationAngle;
{
	CGFloat angle;
	
	switch (self.orientation) {
		case UIDeviceOrientationPortrait:
			angle = 0.0;
			break;
			
		case UIDeviceOrientationPortraitUpsideDown:
			angle = M_PI;
			break;
			
			
		case UIDeviceOrientationLandscapeLeft:
			angle = M_PI * 0.5;
			break;
			
		case UIDeviceOrientationLandscapeRight:
			angle = M_PI * 1.5;
			break;
			
		default:
			angle = 0.0;
	}
	
	return angle;
}

@end


#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>



#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)



@implementation UIDevice (Hardware)
/*
 hwMachine
 
 iFPGA ->        ??
 
 iPhone1,1 ->    iPhone 1G, M68
 iPhone1,2 ->    iPhone 3G, N82
 iPhone2,1 ->    iPhone 3GS, N88
 iPhone3,1 ->    iPhone 4/AT&T, N89
 iPhone3,2 ->    iPhone 4/Other Carrier?, ??
 iPhone3,3 ->    iPhone 4/Verizon, TBD
 iPhone4,1 ->    (iPhone 4S/GSM), TBD
 iPhone4,2 ->    (iPhone 4S/CDMA), TBD
 iPhone4,3 ->    (iPhone 4S/???)
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD
 iPhone5,1 ->    iPhone Next Gen, TBD
 
 iPod1,1   ->    iPod touch 1G, N45
 iPod2,1   ->    iPod touch 2G, N72
 iPod2,2   ->    Unknown, ??
 iPod3,1   ->    iPod touch 3G, N18
 iPod4,1   ->    iPod touch 4G, N80
 
 // Thanks NSForge
 iPad1,1   ->    iPad 1G, WiFi and 3G, K48
 iPad2,1   ->    iPad 2G, WiFi, K93
 iPad2,2   ->    iPad 2G, GSM 3G, K94
 iPad2,3   ->    iPad 2G, CDMA 3G, K95
 iPad3,1   ->    (iPad 3G, WiFi)
 iPad3,2   ->    (iPad 3G, GSM)
 iPad3,3   ->    (iPad 3G, CDMA)
 iPad4,1   ->    (iPad 4G, WiFi)
 iPad4,2   ->    (iPad 4G, GSM)
 iPad4,3   ->    (iPad 4G, CDMA)
 
 AppleTV2,1 ->   AppleTV 2, K66
 AppleTV3,1 ->   AppleTV 3, ??
 
 i386, x86_64 -> iPhone Simulator
 */

#pragma mark - sysctlbyname utils

- (NSString *)getSysInfoByName:(char *)typeSpecifier;
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	
    free(answer);
    return results;
}

- (NSString *)hwMachine;
{
    return [self getSysInfoByName:"hw.machine"];
}

- (NSString *)hwModel;
{
    return [self getSysInfoByName:"hw.model"];
}

#pragma mark - sysctl utils

- (NSUInteger)getSysInfo:(uint)typeSpecifier;
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSUInteger)cpuFrequency;
{
    return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger)busFrequency;
{
    return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger)cpuCount;
{
    return [self getSysInfo:HW_NCPU];
}

- (NSUInteger)totalMemory;
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger)userMemory;
{
    return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger)maxSocketBufferSize;
{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark Public Methods

- (NSString *)macAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString *)uniqueDeviceIdentifier
{
    NSString *macAddress = [[UIDevice currentDevice] macAddress];
    NSString *uniqueIdentifier = S2CryptHashMD5(macAddress);
    
    return uniqueIdentifier;
}

- (NSString *)uniqueIdentifierForVendor;
{
	if ([self respondsToSelector:@selector(identifierForVendor)]) {
		return self.identifierForVendor.UUIDString;
	}
	else {
		return self.uniqueDeviceIdentifier;
	}
}

#define IDFV_SERVICE	@"UIDevice"
#define IDFV_KEY 		@"identifierForVendor"

- (NSString *)uniqueIdentifierForVendor:(NSString*)keychainAccessGroup;
{
	NSString* firstIDFV = [S2Keychain accessGroup:keychainAccessGroup getItem:IDFV_SERVICE :IDFV_KEY];
	if (firstIDFV) {
		return firstIDFV;
	}
	else if ([self respondsToSelector:@selector(identifierForVendor)]) {
		firstIDFV = self.identifierForVendor.UUIDString;
		[S2Keychain accessGroup:keychainAccessGroup updateItem:IDFV_SERVICE :IDFV_KEY :firstIDFV];
		return firstIDFV;
	}
	else {
		return self.uniqueDeviceIdentifier;
	}
	
}

@end
