//
//  SKAccelerometerManager.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/1/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

/**
 @field timestamp test
 @field x test
 @field y test
 @field z test
 */
struct SKAccelerationSample {
    
    /**
     The timestamp of the measurement, expressed as an NSTimeInterval of seconds since system boot.
     */
    NSTimeInterval timestamp;
    
    /**
     The x value of the acceleration vector
     */
    double x;
    
    /**
     The y value of the acceleration vector
     */
    double y;
    
    /**
     The z value of the acceleration vector
     */
    double z;
    
};


/**
 SKAccelerationSample is a structure representing a single acceleration measurement represented as a vector, along with a timestamp expresssed as an NSTimeInteravl of seconds since system boot.
 */
typedef struct SKAccelerationSample SKAccelerationSample;

@class SKAccelerometerManager;

/**
 SKAccelerometerManagerDelegate is a protocol defining a list of methods used to interact with measurements made by an instance of SKAccelerometerManager
 */
@protocol SKAccelerometerManagerDelegate<NSObject>

@optional

/**
 Sent to the delegate when the manager recieves a measurement of the device's acceleration

 @param manager The manager that took the measurement
 @param accelerationSample The measurement that was taken
 */
- (void)accelerometerManager:(nonnull SKAccelerometerManager *)manager didRecieveDeviceAcceleration:(SKAccelerationSample)accelerationSample;

/**
 Sent to the delegate when the manager recieves a measurement of the user's acceleration

 @param manager The manager that took the measurement
 @param accelerationSample The measurement that was taken
 */
- (void)accelerometerManager:(nonnull SKAccelerometerManager *)manager didRecieveUserAcceleration:(SKAccelerationSample)accelerationSample;

/**
 Sent to the delegate when the manager attempts to make a measurement and fails

 @param manager The manager that failed to make the measurement
 @param error The error that caused the failure
 */
- (void)accelerometerManager:(nonnull SKAccelerometerManager *)manager didFailWithError:(nonnull NSError *)error;

@end

/**
 SKAccelerometerManager is a class used to get measurements from the device's built-in accelerometer
 */
@interface SKAccelerometerManager : NSObject

/**
 The delegate object used to handle measurements made by the manager
 */
@property (weak, nullable) id<SKAccelerometerManagerDelegate> delegate;

/**
 The current tracking status of the manager
 */
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;

/**
 The last measurement of device acceleration
 */
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKAccelerationSample deviceAcceleration;

/**
 The last measurement of user acceleration
 */
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKAccelerationSample userAcceleration;

/**
 Create a accelerometer manager with a delegate object

 @param delegate The delegate object used to handle measurements made by the manager
 @return The accelerometer manager
 */
- (nullable instancetype)initWithDelegate:(nullable id<SKAccelerometerManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/**
 Start tracking measurements with an update frequency of 100Hz

 @return YES is tracking began, otherwise NO.
 */
- (BOOL)startTracking;

/**
 Start tracking measurements

 @param frequency The desired frequency of measurement updates, expressed in seconds.
 @return YES if tracking began, otherwise NO.
 */
- (BOOL)startTrackingWithUpdateFrequency:(double)frequency;

/**
 Stop tracking measurements

 @return YES if tracking stopped, otherwise NO.
 */
- (BOOL)stopTracking;

/**
 Create a human readable string from an acceleration sample

 @param accelerationSample The acceleration sample
 @return The human readable string
 */
NSString * _Nonnull NSStringFromSKAccelerationSample(SKAccelerationSample accelerationSample);

@end
