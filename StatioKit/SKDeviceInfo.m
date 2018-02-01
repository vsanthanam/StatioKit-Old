//
//  SKDeviceInfo.m
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import UIKit;
@import Darwin.POSIX.sys.utsname;

#import "NSBundle+StatioKit.h"

#import "SKDeviceInfo.h"

NSString * const SKDeviceInfoConnectorStatusNotification = @"SKDeviceInfoConnectorStatusNotification";

@implementation SKDeviceInfo

#pragma mark - Public Class Methods

+ (instancetype)sharedDeviceInfo {
    
    static SKDeviceInfo *sharedDeviceInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedDeviceInfo = [[self alloc] init];
        
    });
    
    return sharedDeviceInfo;
    
}

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_handleBatteryStatusChange:)
                                                     name:UIDeviceBatteryStateDidChangeNotification
                                                   object:nil];
        
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        
    }
    
    return self;
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceBatteryStateDidChangeNotification
                                                  object:nil];
    
}

#pragma mark - Property Access Methods

- (NSString *)model {
 
    return [UIDevice currentDevice].model;
    
}

- (NSString *)modelName {
    
    NSString *modelName = model_names()[self.modelIdentifier];
    
    if (!modelName) {
        
        if ([self.modelIdentifier hasPrefix:@"iPhone"]) {
            
            modelName = @"Unknown iPhone";
            
        } else if ([self.modelIdentifier hasPrefix:@"iPad"]) {
        
            modelName = @"Unknown iPad";
            
        } else if ([self.modelIdentifier hasPrefix:@"iPod"]) {
            
            modelName = @"iPod";
            
        } else {
         
            modelName = @"Unknown";
            
        }
        
    }
    
    return modelName;
    
}

- (NSString *)modelIdentifier {
    
    // Set up a new Device Type String
    NSString *deviceType;
    struct utsname dt;
    
    uname(&dt);
    deviceType = [NSString stringWithFormat:@"%s", dt.machine];
    
    return deviceType;
    
}

- (NSString *)systemName {

    return [UIDevice currentDevice].systemName;
    
}

- (NSString *)systemVersion {
    
    return [UIDevice currentDevice].systemVersion;
    
}

- (NSString *)deviceName {
    
    return [UIDevice currentDevice].name;
    
}

- (NSTimeInterval)systemUptime {
    
    return [NSProcessInfo processInfo].systemUptime;
    
}

- (SKConnectorStatus)connectorStatus {
    
    UIDevice *device = [UIDevice currentDevice];
    
    if (device.batteryState == UIDeviceBatteryStateUnplugged) {
        
        return SKConnectorStatusDisconnected;
        
    } else if (device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull) {
        
        return SKConnectorStatusConnected;
        
    }
    
    return SKConnectorStatusUnknown;
}

#pragma mark - Private Instance Methods

- (void)_handleBatteryStatusChange:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SKDeviceInfoConnectorStatusNotification
                                                        object:nil];
    
}

#pragma mark - C Functions

NSDictionary * model_names(void) {
    
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle statioKitResources] pathForResource:@"ModelNames" ofType:@"plist"]];
    
}

@end
