//
//  SKCarrierInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

/**
 Notification sent when the shared instance of SKCarrierInfo changes its carrier information.
 */
extern NSString * _Nonnull const SKCarrierInfoUpdateNotification;

/**
 SKCarrierInfo is a singleton instance used to retrieve some basic static information about device's wlan carrier
 */
@interface SKCarrierInfo : NSObject

/**
 @name Accessing The Singleton
 */

/**
 Get the shared instance
 
 @return The shared instance
 */
+ (nullable instancetype)sharedCarrierInfo;

/**
 @name Getting Carrier Info
 */

/**
 The name the the carrier
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *carrierName;

/**
 The country that the carrier is belongs to
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *carrierCountry;

/**
 The ISO code of the carrier's country.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *carrierISOCountryCode;

/**
 The MCC code of the carrier
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *carrierMobileCountryCode;

/**
 The MNC code of the carrier
 */
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *carrierMobileNetworkCode;

/**
 YES is the carrier allows VOIP, otherwise NO.
 */
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL allowsVOIP;

@end
