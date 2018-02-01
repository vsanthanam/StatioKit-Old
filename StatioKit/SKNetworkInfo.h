//
//  SKNetworkInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

@interface SKNetworkInfo : NSObject

@property (NS_NONATOMIC_IOSONLY, readonly, getter=isConnected) BOOL connected;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *currentIPAddress;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *externalIPAddress;

@property (NS_NONATOMIC_IOSONLY, readonly, getter=isConnectedToWWAN) BOOL connectedToWWAN;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WWANIPAddress;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WWANIPv6Address;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WWANNetmaskAddress;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WWANBroadcastAddress;

@property (NS_NONATOMIC_IOSONLY, readonly, getter=isConnectedToWLAN) BOOL connectedToWLAN;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WLANIPAddress;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WLANIPv6Address;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WLANNetmaskAddress;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WLANBroadcastAddress;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *WLANRouterAddress;

+ (nullable instancetype)sharedNetworkInfo;

@end
