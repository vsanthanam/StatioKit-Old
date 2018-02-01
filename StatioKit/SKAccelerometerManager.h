//
//  SKAccelerometerManager.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/1/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

@class SKAccelerometerManager;

@protocol SKAccelerometerManagerDelegate<NSObject>

@optional

- (void)deviceAccelerometerManager:(nonnull SKAccelerometerManager *)manager didRecieveAccelerationWithX:(double)x y:(double)y z:(double)z atTimestamp:(NSTimeInterval)timestamp;
- (void)deviceAccelerometerManager:(nonnull SKAccelerometerManager *)manager didFailToGetAccelerometerDataWithError:(nonnull NSError *)error;

@end

@interface SKAccelerometerManager : NSObject

@property (weak, nullable) id<SKAccelerometerManagerDelegate> delegate;
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;

- (nullable instancetype)initWithDelegate:(nullable id<SKAccelerometerManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (BOOL)startTracking;
- (BOOL)stopTracking;

@end
