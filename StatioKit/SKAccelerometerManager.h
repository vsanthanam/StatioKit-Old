//
//  SKAccelerometerManager.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/1/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

typedef struct {
    
    NSTimeInterval timestamp;
    double x;
    double y;
    double z;
    
} SKAccelerationSample;

@class SKAccelerometerManager;

@protocol SKAccelerometerManagerDelegate<NSObject>

@optional

- (void)accelerometerManager:(nonnull SKAccelerometerManager *)manager didRecieveAccelerationSample:(SKAccelerationSample)accelerationSample;
- (void)accelerometerManager:(nonnull SKAccelerometerManager *)manager didFailToGetAccelerometerDataWithError:(nonnull NSError *)error;

@end

@interface SKAccelerometerManager : NSObject

@property (weak, nullable) id<SKAccelerometerManagerDelegate> delegate;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKAccelerationSample accelerationSample;

- (nullable instancetype)initWithDelegate:(nullable id<SKAccelerometerManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (BOOL)startTracking;
- (BOOL)startTrackingWithUpdateFrequency:(double)frequency;
- (BOOL)stopTracking;

NSString * _Nonnull NSStringFromSKAccelerationSample(SKAccelerationSample accelerationSample);

@end
