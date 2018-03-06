//
//  SKBatteryInfo.m
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import UIKit;

NSString * const SKBatteryInfoChangedNotification = @"SKBatteryInfoChangedNotification";

#import "SKBatteryInfo.h"

@implementation SKBatteryInfo

@synthesize monitoringEnabled = _monitoringEnabled;

#pragma mark - Public Class Methods

+ (instancetype)sharedBatteryInfo {
    
    static SKBatteryInfo *sharedBatteryInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedBatteryInfo = [[self alloc] init];
        
    });
    
    return sharedBatteryInfo;
    
}

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_postNotification:)
                                                     name:UIDeviceBatteryLevelDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_postNotification:)
                                                     name:UIDeviceBatteryStateDidChangeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_postNotification:)
                                                     name:NSProcessInfoPowerStateDidChangeNotification
                                                   object:nil];
        
    }
    
    return self;
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceBatteryLevelDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceBatteryStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSProcessInfoPowerStateDidChangeNotification
                                                  object:nil];
    
}

#pragma mark - Property Access Methods

- (void)setMonitoringEnabled:(BOOL)monitoringEnabled {
    
    _monitoringEnabled = monitoringEnabled;
    
    if (self.monitoringEnabled) {
        
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        
    }
    
}

- (double)batteryLevel {
    
    BOOL shouldDisable = NO;
    
    if (![UIDevice currentDevice].batteryMonitoringEnabled) {
        
        shouldDisable = YES;
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        
    }
    
    double rv = (double)[UIDevice currentDevice].batteryLevel;
    
    if (shouldDisable && !self.monitoringEnabled) {
        
        [UIDevice currentDevice].batteryMonitoringEnabled = NO;
        
    }
    
    return rv;
    
}

- (SKBatteryInfoState)batteryState {
    
    BOOL shouldDisable = NO;
    
    if (![UIDevice currentDevice].batteryMonitoringEnabled) {
        
        shouldDisable = YES;
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        
    }
    
    SKBatteryInfoState rv = sk_battery_info_state_for_battery_state([UIDevice currentDevice].batteryState);
    
    if (shouldDisable && !self.monitoringEnabled) {
        
        [UIDevice currentDevice].batteryMonitoringEnabled = NO;
        
    }
    
    return rv;
    
}

- (BOOL)isLowPowerModeEnabled {
    
    return [NSProcessInfo processInfo].lowPowerModeEnabled;
    
}

#pragma mark - Private Instance Methods

- (void)_postNotification:(id)sender {
    
    if (self.monitoringEnabled) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SKBatteryInfoChangedNotification object:nil];
        
    }
    
}

#pragma mark - C Functions

SKBatteryInfoState sk_battery_info_state_for_battery_state(UIDeviceBatteryState batteryState) {
    
    SKBatteryInfoState state;
    
    switch (batteryState) {
            
        case UIDeviceBatteryStateUnknown:
            
            state = SKBatteryInfoStateUnknown;
            
            break;
            
            
        case UIDeviceBatteryStateUnplugged:
            
            state = SKBatteryInfoStateDischarging;
            
            break;
            
        case UIDeviceBatteryStateCharging:
            
            state = SKBatteryInfoStateCharging;
            
            break;
            
        case UIDeviceBatteryStateFull:
            
            state = SKBatteryInfoStateFull;
            
            break;
            
        default:
            
            state = SKBatteryInfoStateUnknown;
            
            break;
            
    }
    
    return state;
    
}

@end
