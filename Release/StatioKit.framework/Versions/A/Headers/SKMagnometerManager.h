//
//  SKMagnometerManager.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

typedef struct {
    
    NSTimeInterval timestamp;
    double x;
    double y;
    double z;
    
} SKMagneticFieldSample;

@class SKMagnometerManager;

@protocol SKMagnometerManagerDelegate<NSObject>

@optional

- (void)magnometerManager:(nonnull SKMagnometerManager *)manager didRecieveMagneticFieldSample:(SKMagneticFieldSample)magneticFieldSample;
- (void)magnometerManager:(nonnull SKMagnometerManager *)manager didFailToGetMagnometerDataWithError:(nonnull NSError *)error;

@end

@interface SKMagnometerManager : NSObject

@property (weak, nullable) id<SKMagnometerManagerDelegate> delegate;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKMagneticFieldSample magneticFieldSample;

- (nullable instancetype)initWithDelegate:(nullable id<SKMagnometerManagerDelegate>)delegate;

- (BOOL)startTracking;
- (BOOL)startTrackingWithUpdateFrequency:(double)frequency;
- (BOOL)stopTracking;

NSString * _Nonnull NSStringFromSKMagneticFieldSample(SKMagneticFieldSample magneticFieldSample);

@end
