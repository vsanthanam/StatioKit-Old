//
//  SKCarrierInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

extern NSString * _Nonnull const SKCarrierInfoUpdateNotification;

@interface SKCarrierInfo : NSObject

@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *carrierName;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *carrierCountry;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *carrierISOCountryCode;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *carrierMobileCountryCode;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *carrierMobileNetworkCode;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL allowsVOIP;

+ (nullable instancetype)sharedCarrierInfo;

@end
