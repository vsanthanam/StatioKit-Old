//
//  SKDeviceInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

extern NSString * _Nonnull const SKDeviceInfoConnectorStatusNotification;

typedef NS_ENUM(NSInteger, SKConnectorStatus) {
    
    SKConnectorStatusDisconnected = 0,
    SKConnectorStatusConnected = 1,
    SKConnectorStatusUnknown = 2
    
};

@interface SKDeviceInfo : NSObject

@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *model;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *modelName;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *modelIdentifier;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *systemName;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *systemVersion;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *deviceName;
@property (NS_NONATOMIC_IOSONLY, readonly) NSTimeInterval systemUptime;
@property (NS_NONATOMIC_IOSONLY, readonly) SKConnectorStatus connectorStatus;

+ (nullable instancetype)sharedDeviceInfo;

@end
