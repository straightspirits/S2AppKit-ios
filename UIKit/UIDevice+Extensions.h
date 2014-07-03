//
//  UIDevice+Extensions.h
//  S2AppKit/S2UIKit
//
//  Created by ふみお on 2013/01/26.
//  Copyright (c) 2013年 Straight Spirits. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDevice (Orientation)

- (CGFloat)orientationAngle;

@end



@interface UIDevice (Hardware)

- (NSString *)getSysInfoByName:(char *)typeSpecifier;
- (NSString *)hwMachine;
- (NSString *)hwModel;

- (NSUInteger)getSysInfo:(uint)typeSpecifier;
- (NSUInteger)cpuFrequency;
- (NSUInteger)busFrequency;
- (NSUInteger)cpuCount;
- (NSUInteger)totalMemory;
- (NSUInteger)userMemory;
- (NSUInteger)maxSocketBufferSize;

- (NSString *)macAddress;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */
- (NSString *)uniqueDeviceIdentifier;

- (NSString *)uniqueIdentifierForVendor;
- (NSString *)uniqueIdentifierForVendor:(NSString*)keychainAccessGroup;

@end
