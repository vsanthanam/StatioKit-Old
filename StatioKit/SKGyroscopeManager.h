//
//  SKGyroscopeManager.h
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
    
} SKRotationRateSample;

@class SKGyroscopeManager;

@protocol SKGyroscopeManagerDelegate<NSObject>

- (void)gyroscopeManager:(nonnull SKGyroscopeManager *)manager didRecieveRotationRateSample:(SKRotationRateSample)rotationRateSample;
- (void)gyroscopeManager:(nonnull SKGyroscopeManager *)manager didFailToGetGyroscopeDataWithError:(nonnull NSError *)error;

@optional

@end

@interface SKGyroscopeManager : NSObject

@property (weak, nullable) id<SKGyroscopeManagerDelegate> delegate;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKRotationRateSample rotationRateSample;

- (nullable instancetype)initWithDelegate:(nullable id<SKGyroscopeManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (BOOL)startTracking;
- (BOOL)startTrackigWithUpdateFrequency:(double)frequency;
- (BOOL)stopTracking;

NSString * _Nonnull NSStringFromSKRotationRateSample(SKRotationRateSample rotationRateSample);

@end
