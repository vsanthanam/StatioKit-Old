//
//  SKAccelerometerManager.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/1/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

struct SKAccelerationSample {
    
    NSTimeInterval timestamp;
    double x;
    double y;
    double z;
    
};

typedef struct SKAccelerationSample SKAccelerationSample;

@class SKAccelerometerManager;

@protocol SKAccelerometerManagerDelegate<NSObject>

@optional

- (void)accelerometerManager:(nonnull SKAccelerometerManager *)manager didRecieveDeviceAcceleration:(SKAccelerationSample)accelerationSample;
- (void)accelerometerManager:(nonnull SKAccelerometerManager *)manager didRecieveUserAcceleration:(SKAccelerationSample)accelerationSample;
- (void)accelerometerManager:(nonnull SKAccelerometerManager *)manager didFailWithError:(nonnull NSError *)error;

@end

@interface SKAccelerometerManager : NSObject

@property (weak, nullable) id<SKAccelerometerManagerDelegate> delegate;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKAccelerationSample deviceAcceleration;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKAccelerationSample userAcceleration;

- (nullable instancetype)initWithDelegate:(nullable id<SKAccelerometerManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (BOOL)startTracking;
- (BOOL)startTrackingWithUpdateFrequency:(double)frequency;
- (BOOL)stopTracking;

SKAccelerationSample SKAccelerationSampleMake(double x, double y, double z, NSTimeInterval timestamp);

@end
