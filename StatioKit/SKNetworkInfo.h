//
//  SKNetworkInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

/**
 SKNetworkInfo is a singleton instance used to retrieve information about the currently connected network(s)
 */
@interface SKNetworkInfo : NSObject

/**
 @name Accessing The Singleton
 */

/**
 Get the shared instance

 @return The shared instance
 */
+ (nullable instancetype)sharedNetworkInfo;

/**
 @name Getting General Network Info
 */

/**
 Current Connection Status
 */
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isConnected) BOOL connected;

/**
 Current Internal IP Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *currentIPAddress;

/**
 Current External IP Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *externalIPAddress;

/**
 @name Getting WWAN Info
 */

/**
 Current WWAN Connection Status
 */
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isConnectedToWWAN) BOOL connectedToWWAN;

/**
 WWAN IPv4 Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WWANIPAddress;

/**
 WWAN IPv6 Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WWANIPv6Address;

/**
 WWANN Netmask Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WWANNetmaskAddress;

/**
 WWAN Broadcast Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WWANBroadcastAddress;

/**
 @name Getting WLAN Info
 */

/**
 Current WLAN Connection Status
 */
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isConnectedToWLAN) BOOL connectedToWLAN;

/**
 WLAN IPv4 Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WLANIPAddress;

/**
 WLAN IPv6 Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WLANIPv6Address;

/**
 WLAN Netmask Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WLANNetmaskAddress;

/**
 WLAN Broadcast Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WLANBroadcastAddress;

/**
 WLAN Router Address
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WLANRouterAddress;

@end
