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

#import "sk_log.h"

@implementation SKDeviceInfo

static os_log_t device_info_log;

#pragma mark - Overridden Class Methods

+ (void)initialize {
    
    device_info_log = sk_log_create("SKDeviceInfo");
    
}

#pragma mark - Public Class Methods

+ (instancetype)sharedDeviceInfo {
    
    static SKDeviceInfo *sharedDeviceInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedDeviceInfo = [[self alloc] init];
        
    });
    
    return sharedDeviceInfo;
    
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
            
            os_log_info(device_info_log, "Encountered Unknown Identifier %{public}@", modelName);
         
            modelName = @"Unknown";
            
        }
        
    }
    
    return modelName;
    
}

- (NSString *)modelIdentifier {
    
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

#pragma mark - C Functions

NSDictionary * model_names(void) {
    
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle statioKitResources] pathForResource:@"ModelNames" ofType:@"plist"]];
    
}

@end
