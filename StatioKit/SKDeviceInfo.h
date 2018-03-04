//
//  SKDeviceInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

/**
 SKDeviceInfo is a singleton instance used to retrieve some basic static information about the current hardware
 */
@interface SKDeviceInfo : NSObject

/*
 @name Accessing The Singleton
 */

/**
 Get the shared instance

 @return The shared instance
 */
+ (nullable instancetype)sharedDeviceInfo;

/**
 @name Getting Device Info
 */

/**
 Get the current model of device (i.e. iPhone, iPad, etc.)
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *model;

/**
 Get the name of the current model (i.e. iPhone X, iPad mini, etc.)
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *modelName;

/**
 Get the identifier of the current model (i.e. iPad2,1, iPhone5,2, etc.)
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *modelIdentifier;

/**
 Get the name of the OS (i.e. iOS, watchOS, tvOS, etc.)
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *systemName;

/**
 Get the version of the OS (i.e. 11.2.5, 10.0.1, etc.)
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *systemVersion;

/**
 Get the user assigned device name (i.e. 'Steve's iPhone')
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *deviceName;

/**
 Get a time interval representing system upting
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSTimeInterval systemUptime;

@end
