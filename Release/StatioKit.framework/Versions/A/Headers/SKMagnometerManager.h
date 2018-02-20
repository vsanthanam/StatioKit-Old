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

typedef struct {
    
    NSTimeInterval timestamp;
    double x;
    double y;
    double z;
    
} SKGravitySample;

typedef struct {
    
    NSTimeInterval timestamp;
    double heading;
    
} SKHeadingSample;

@class SKMagnometerManager;

@protocol SKMagnometerManagerDelegate<NSObject>

@optional

- (void)magnometerManager:(nonnull SKMagnometerManager *)manager didRecieveRawMagneticField:(SKMagneticFieldSample)magneticFieldSample;
- (void)magnometerMamager:(nonnull SKMagnometerManager *)manager didRecieveUnbiasedMagneticField:(SKMagneticFieldSample)magneticFieldSample;
- (void)magnometerManager:(nonnull SKMagnometerManager *)manager didRecieveGravity:(SKGravitySample)gravitySample;
- (void)magnometerManager:(nonnull SKMagnometerManager *)manager didRecieveHeading:(SKHeadingSample)headingSample;
- (void)magnometerManager:(nonnull SKMagnometerManager *)manager didFailWithError:(nonnull NSError *)error;

@end

@interface SKMagnometerManager : NSObject

@property (weak, nullable) id<SKMagnometerManagerDelegate> delegate;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKMagneticFieldSample rawMagneticField;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKMagneticFieldSample unbiasedMagneticField;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKGravitySample gravity;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKHeadingSample heading;

- (nullable instancetype)initWithDelegate:(nullable id<SKMagnometerManagerDelegate>)delegate;

- (BOOL)startTracking;
- (BOOL)startTrackingWithUpdateFrequency:(double)frequency;
- (BOOL)stopTracking;

NSString * _Nonnull NSStringFromSKMagneticFieldSample(SKMagneticFieldSample magneticFieldSample);
NSString * _Nonnull NSStringFromSKGravitySample(SKGravitySample gravitySample);
NSString * _Nonnull NSStringFromSKHeadingSample(SKHeadingSample headingSample);

@end
