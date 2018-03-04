//
//  SKMagnometerManager.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

/**
 SKMagneticFieldSample is a structure representing a single magnetic field measurement represented as a vector, along with a timestamp as an NSTimeInterval of seconds since system boot.
 */
typedef struct {
    
    /**
     The timestamp of measurement, expressed as an NSTimeInterval of seconds since system boot.
     */
    NSTimeInterval timestamp;
    
    /**
     The x value of the magnetic field
     */
    double x;
    
    /**
     The y value of the magnetic field
     */

    double y;
    
    /**
     The z value of the magnetic field
     */
    double z;
    
} SKMagneticFieldSample;

/**
 SKGravitySample is a structure representing a single gravitational force measurement represented as a vector, along with a timestamp expressed as an NSTimeInterval of seconds since system boot.
 */
typedef struct {
    
    /**
     The timestamp of the measurement, expressed as an NSTimeInterval of seconds since system boot.
     */
    NSTimeInterval timestamp;
    
    /**
     The x value of the gravitational force vector
     */
    double x;
    
    /**
     The y value of the gravitational force vector
     */
    double y;
    
    /**
     The z value of the gravitational force vector
     */
    double z;
    
} SKGravitySample;

/**
 SKHeadingSample is a structure representing a single measurement of the device's heading, along  with a timestamp expressed as an NSTimeInterval of seconds since system boot.
 */
typedef struct {
    
    /**
     The timestamp of the measurement, expressed as an NSTimeInterval of seconds since system boot.
     */
    NSTimeInterval timestamp;
    
    /**
     The heading expressed as a double.
     */
    double heading;
    
} SKHeadingSample;

@class SKMagnometerManager;

/**
 SKMagnometerManagerDelegate is a protocol defining a list of methods used to interact with measurements made by an instance of SKMagnometerManager
 */
@protocol SKMagnometerManagerDelegate<NSObject>

@optional

/**
 Sent to the delegate when the manager recieves a measurement of the device's raw magnetic field

 @param manager The manager that took the measurement
 @param magneticFieldSample The measurement that was taken
 */
- (void)magnometerManager:(nonnull SKMagnometerManager *)manager didRecieveRawMagneticField:(SKMagneticFieldSample)magneticFieldSample;

/**
 Sent to the delegate when the manager recieves a measurement of the device's unbiased magnetic field
 
 @param manager The manager that took the measurement
 @param magneticFieldSample The measurement that was taken
 */
- (void)magnometerMamager:(nonnull SKMagnometerManager *)manager didRecieveUnbiasedMagneticField:(SKMagneticFieldSample)magneticFieldSample;

/**
 Sent to the delegate when the manager recieves a measurement of the device's raw magnetic field
 
 @param manager The manager that took the measurement
 @param gravitySample The measurement that was taken
 */
- (void)magnometerManager:(nonnull SKMagnometerManager *)manager didRecieveGravity:(SKGravitySample)gravitySample;

/**
 Sent to the delegate when the manager recieves a measurement of the device's raw magnetic field
 
 @param manager The manager that took the measurement
 @param headingSample The measurement that was taken
 */
- (void)magnometerManager:(nonnull SKMagnometerManager *)manager didRecieveHeading:(SKHeadingSample)headingSample;

/**
 Sent to the delegate when the manager attempts to make a measurement and fails

 @param manager The manager that failed to make the measurement
 @param error The error that caused the failure
 */
- (void)magnometerManager:(nonnull SKMagnometerManager *)manager didFailWithError:(nonnull NSError *)error;

@end

/**
 SKMagnometerManager is a class used to get measurements from the device's built-in magnometer
 */
@interface SKMagnometerManager : NSObject

/**
 The delegate used to handle measurements made by the manager
 */
@property (weak, nullable) id<SKMagnometerManagerDelegate> delegate;

/**
 The tracking status of the manager
 */
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;

/**
 The last measurement of the device's raw magnetic field
 */
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKMagneticFieldSample rawMagneticField;

/**
 The last measurement of the device's unbiased magnetic field
 */
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKMagneticFieldSample unbiasedMagneticField;

/**
 The last measurement of the device's gravitational field
 */
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKGravitySample gravity;

/**
 The last measurement of the device's heading
 */
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKHeadingSample heading;

/**
 Create a magnometer manager with a delegate object

 @param delegate The delegate object used to handle measurements made by the manager
 @return The magnometer manager
 */
- (nullable instancetype)initWithDelegate:(nullable id<SKMagnometerManagerDelegate>)delegate;

/**
 Start tracking measurements with an update frequency of 100Hz

 @return YES if tracking began, otherwise NO.
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
 Create a human readable string from a magnetic field sample

 @param magneticFieldSample The magnetic field sample
 @return The human readable string
 */
NSString * _Nonnull NSStringFromSKMagneticFieldSample(SKMagneticFieldSample magneticFieldSample);

/**
 Create a human readable string from a gravity sample

 @param gravitySample The gravity sample
 @return The human readable string
 */
NSString * _Nonnull NSStringFromSKGravitySample(SKGravitySample gravitySample);

/**
 Create a human readable string from a headinb sample

 @param headingSample The heading sample
 @return The human readable string
 */
NSString * _Nonnull NSStringFromSKHeadingSample(SKHeadingSample headingSample);

@end
