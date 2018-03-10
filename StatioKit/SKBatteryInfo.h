//
//  SKBatteryInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

extern NSString * _Nonnull const SKBatteryInfoChangedNotification;

typedef NS_ENUM(NSInteger, SKBatteryInfoState) {
    
    SKBatteryInfoStateUnknown = -1,
    SKBatteryInfoStateDischarging = 0,
    SKBatteryInfoStateCharging = 1,
    SKBatteryInfoStateFull = 2
    
};

@interface SKBatteryInfo : NSObject

@property (NS_NONATOMIC_IOSONLY, assign, getter=isMonitoringEnabled) BOOL monitoringEnabled;
@property (NS_NONATOMIC_IOSONLY, readonly) double batteryLevel;
@property (NS_NONATOMIC_IOSONLY, readonly) SKBatteryInfoState batteryState;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isLowPowerModeEnabled) BOOL lowPowerModeEnabled;

+ (nullable instancetype)sharedBatteryInfo;

@end
