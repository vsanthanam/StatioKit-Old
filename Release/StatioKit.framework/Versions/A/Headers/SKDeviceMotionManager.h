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

typedef struct {
    
    NSTimeInterval timestamp;
    double roll;
    double pitch;
    double yaw;
    
} SKAttitudeSample;

typedef struct {
    
    NSTimeInterval timestamp;
    double x;
    double y;
    double z;
    
} SKUnbiasedRotationRateSample;

typedef struct {
    
    NSTimeInterval timestamp;
    double x;
    double y;
    double z;
    
} SKGravitySample;

typedef struct {
    
    NSTimeInterval timestamp;
    double x;
    double y;
    double z;
    
} SKUserAccelerationSample;

typedef struct {
    
    NSTimeInterval timestamp;
    double x;
    double y;
    double z;
    SKDeviceMotionManagerMagneticFieldAccuracy accuracy;
    
} SKUnbiasedMagneticFieldSample;

typedef struct {
    
    NSTimeInterval timestamp;
    double heading;
    
} SKHeadingSample;

@class SKDeviceMotionManager;

@protocol SKDeviceMotionManagerDelegate<NSObject>

@optional

- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveAttitudeSample:(SKAttitudeSample)attitudeSample;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveUnbiasedRotationRateSample:(SKUnbiasedRotationRateSample)unbiasedRotationRateSample;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveGravitySample:(SKGravitySample)gravitySample;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveUserAccelerationSample:(SKUserAccelerationSample)userAccelerationSample;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveUnbiasedMagneticFieldSample:(SKUnbiasedMagneticFieldSample)unbiasedMagneticFieldSample;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didRecieveHeadingSample:(SKHeadingSample)headingSample;
- (void)deviceMotionManager:(nonnull SKDeviceMotionManager *)manager didFailToGetDeviceMotionWithError:(nonnull NSError *)error;

@end

@interface SKDeviceMotionManager : NSObject

@property (weak, nullable) id<SKDeviceMotionManagerDelegate> delegate;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKAttitudeSample attitudeSample;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKUnbiasedRotationRateSample unbiasedRotationRateSample;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKGravitySample gravitySample;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKUserAccelerationSample userAccelerationSample;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKUnbiasedMagneticFieldSample unbiasedMagneticFieldSample;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKHeadingSample headingSample;

- (nullable instancetype)initWithDelegate:(nullable id<SKDeviceMotionManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (BOOL)startTracking;
- (BOOL)startTrackingWithUpdateFrequency:(double)frequency;
- (BOOL)stopTracking;

NSString * _Nonnull NSStringFromSKAttitudeSample(SKAttitudeSample attitudeSample);
NSString * _Nonnull NSStringFromSKUnbiasedRotationRateSample(SKUnbiasedRotationRateSample unbiasedRotationRateSample);
NSString * _Nonnull NSStringFromSKGravitySample(SKGravitySample gravitySample);
NSString * _Nonnull NSStringFromSKUserAccelerationSample(SKUserAccelerationSample userAccelerationSample);
NSString * _Nonnull NSStringFromSKUnbiasedMagneticFieldSample(SKUnbiasedMagneticFieldSample unbiasedMagneticFieldSample);
NSString * _Nonnull NSStringFromSKHeadingSample(SKHeadingSample headingSample);

@end
