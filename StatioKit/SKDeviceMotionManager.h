//
//  SKDeviceMotionManager.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/30/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, SKDeviceMotionManagerMagneticFieldAccuracy) {
    
    SKDeviceMotionManagerMagneticFieldAccuracyUnknown = -1,
    SKDeviceMotionManagerMagneticFieldAccuracyUncalibrated = 0,
    SKDeviceMotionManagerMagneticFieldAccuracyLow = 1,
    SKDeviceMotionManagerMagneticFieldAccuracyMedium = 2,
    SKDeviceMotionManagerMagneticFieldAccuracyHigh = 3
    
};

@class SKDeviceMotionManager;

@protocol SKDeviceMotionManagerDelegate<NSObject>

@optional

- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveAttitudeWithRoll:(double)roll pitch:(double)pitch yaw:(double)yaw atTimestamp:(NSTimeInterval)timestamp;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveRotationRateWithX:(double)x y:(double)y z:(double)z atTimestamp:(NSTimeInterval)timestamp;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveGravityWithX:(double)x y:(double)y z:(double)z atTimestamp:(NSTimeInterval)timestamp;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveUserAccelerationWithX:(double)x y:(double)y z:(double)z atTimestamp:(NSTimeInterval)timestamp;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveUnbiasedMagneticField:(double)x y:(double)y z:(double)z accuracy:(SKDeviceMotionManagerMagneticFieldAccuracy)accuracy atTimestamp:(NSTimeInterval)timestamp;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveHeading:(double)heading atTimestamp:(NSTimeInterval)timestamp;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didFailToGetDeviceMotionWithError:(nonnull NSError *)error;

@end

@interface SKDeviceMotionManager : NSObject

@property (weak, nullable) id<SKDeviceMotionManagerDelegate> delegate;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;

- (nullable instancetype)initWithDelegate:(nullable id<SKDeviceMotionManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (BOOL)startTracking;
- (BOOL)stopTracking;

@end
