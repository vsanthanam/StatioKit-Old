//
//  SKBatteryInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

/**
 Notification sent when the shared instance of SKBatteryInfo updates its battery information.
 */
extern NSString * _Nonnull const SKBatteryInfoChangedNotification;

/**
 An enumertion used to describe the current state of the battery

 - SKBatteryInfoStateUnknown: Unknown
 - SKBatteryInfoStateDischarging: Battery is discharging
 - SKBatteryInfoStateCharging: Battery is charging
 - SKBatteryInfoStateFull: Battery is fully charged
 */
typedef NS_ENUM(NSInteger, SKBatteryInfoState) {
    
    /**
     Unknown
     */
    SKBatteryInfoStateUnknown = -1,
    
    /**
     Battery is discharging
     */
    SKBatteryInfoStateDischarging = 0,
    
    /**
     Battery is charging
     */
    SKBatteryInfoStateCharging = 1,
    
    /**
     Battery is fully charged
     */
    SKBatteryInfoStateFull = 2
    
};

/**
 SKBatteryInfo is a singleton instance used to access informatino about the system battery
 */
@interface SKBatteryInfo : NSObject

/**
 @name Accessing The Singleton
 */

/**
 Get the shared instance

 @return The shared instance
 */
+ (nullable instancetype)sharedBatteryInfo;

/**
 @name Controlling Singleton Behavior
 */
 
 /**
 Battery Monitoring. If enabled, the singleton will send notification upon battery level changes
 */
@property (NS_NONATOMIC_IOSONLY, assign, getter=isMonitoringEnabled) BOOL monitoringEnabled;

/**
 @name Battery Info
 */

/**
 The current level of the battery, expressed as a double from 0.0 - 1.0
 */
@property (NS_NONATOMIC_IOSONLY, readonly) double batteryLevel;

/**
 The current state of the battery
 */
@property (NS_NONATOMIC_IOSONLY, readonly) SKBatteryInfoState batteryState;

@end
