//
//  SKDeviceInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

@interface SKDeviceInfo : NSObject

@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *model;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *modelName;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *modelIdentifier;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *systemName;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *systemVersion;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *deviceName;
@property (NS_NONATOMIC_IOSONLY, readonly) NSTimeInterval systemUptime;

+ (nullable instancetype)sharedDeviceInfo;

@end
