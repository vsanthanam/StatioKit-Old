//
//  SKCarrierInfo.m
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import CoreTelephony;

#import "SKCarrierInfo.h"

NSString * const SKCarrierInfoUpdateNotification = @"SKCarrierInfoUpdateNotification";

@interface SKCarrierInfo ()

@property (nonatomic, strong) CTTelephonyNetworkInfo *internalTelephonyInfo;

@end

@implementation SKCarrierInfo

@synthesize internalTelephonyInfo = _internalTelephonyInfo;

#pragma mark - Public Class Methods

+ (instancetype)sharedCarrierInfo {
    
    static SKCarrierInfo *sharedCarrierInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedCarrierInfo = [[self alloc] init];
        
    });
    
    return sharedCarrierInfo;
    
}

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.internalTelephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
        self.internalTelephonyInfo.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier) {
          
            [[NSNotificationCenter defaultCenter] postNotificationName:SKCarrierInfoUpdateNotification
                                                                object:nil];
            
        };
        
    }
 
    return self;
    
}

#pragma mark - Property Access Methods

- (NSString *)carrierName {
    
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *carrierName = telephonyInfo.subscriberCellularProvider.carrierName;
    
    if (carrierName == nil || carrierName.length <= 0)
        return nil;
    
    return carrierName;
    
}

- (NSString *)carrierCountry {
    
    NSString *country = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    
    if (country == nil || country.length <= 0)
        return nil;
    
    return country;
    
}

- (NSString *)carrierISOCountryCode {
    
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *isoCode = telephonyInfo.subscriberCellularProvider.isoCountryCode;
    
    if (isoCode == nil || isoCode.length <= 0)
        return nil;
    
    return isoCode;
    
}

- (NSString *)carrierMobileCountryCode {
    
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *mcc = telephonyInfo.subscriberCellularProvider.mobileCountryCode;
    
    if (mcc == nil || mcc.length <= 0)
        return nil;
    
    return mcc;
    
}

- (NSString *)carrierMobileNetworkCode {
    
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *mnc = telephonyInfo.subscriberCellularProvider.mobileNetworkCode;
    
    if (mnc == nil || mnc.length <= 0)
        return nil;
    
    return mnc;
    
}

- (BOOL)allowsVOIP {
    
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    return telephonyInfo.subscriberCellularProvider.allowsVOIP;
    
}

@end
