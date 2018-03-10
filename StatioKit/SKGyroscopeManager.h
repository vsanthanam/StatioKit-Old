//
//  SKGyroscopeManager.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

struct SKRotationRateSample {

    NSTimeInterval timestamp;
    double x;
    double y;
    double z;
    
};

typedef struct SKRotationRateSample SKRotationRateSample;

struct SKAttitudeSample {

    NSTimeInterval timestamp;
    double roll;
    double pitch;
    double yaw;
    
};

typedef struct SKAttitudeSample SKAttitudeSample;

@class SKGyroscopeManager;

@protocol SKGyroscopeManagerDelegate<NSObject>

@optional

- (void)gyroscopeManager:(nonnull SKGyroscopeManager *)manager didRecieveRawRotationRate:(SKRotationRateSample)rotationRateSample;
- (void)gyroscopeManager:(nonnull SKGyroscopeManager *)manager didRecieveUnbiasedRotationRate:(SKRotationRateSample)rotationRateSample;
- (void)gyroscopeManager:(nonnull SKGyroscopeManager *)manager didRecieveAttitude:(SKAttitudeSample)attitudeSample;
- (void)gyroscopeManager:(nonnull SKGyroscopeManager *)manager didFailWithError:(nonnull NSError *)error;

@end

@interface SKGyroscopeManager : NSObject

@property (weak, nullable) id<SKGyroscopeManagerDelegate> delegate;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKRotationRateSample rawRotationRate;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKRotationRateSample unbiasedRotationRate;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKAttitudeSample attitude;

- (nullable instancetype)initWithDelegate:(nullable id<SKGyroscopeManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (BOOL)startTracking;
- (BOOL)startTrackingWithUpdateFrequency:(double)frequency;
- (BOOL)stopTracking;

NSString * _Nonnull NSStringFromSKRotationRateSample(SKRotationRateSample rotationRateSample);
NSString * _Nonnull NSStringFromSKAttitudeSample(SKAttitudeSample attitudeSample);

@end
