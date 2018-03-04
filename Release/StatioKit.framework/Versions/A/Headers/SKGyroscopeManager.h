//
//  SKGyroscopeManager.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

/**
 SKRotationRateSample is a structure representing a single rotation rate measurement represented as a vector, along with a timetstamp expressed as an NSTimeInterval of seconds since system boot.
 */
typedef struct {
    
    /**
     The timestamp of the measruement, expressed as an NSTimeInterval of seconds since system boot.
     */
    NSTimeInterval timestamp;
    
    /**
     The x value of the rotation rate vector
     */
    double x;
    
    /**
     The y value of the rotation rate vector
     */
    double y;
    
    /**
     The z value of the rotation rate vector
     */
    double z;
    
} SKRotationRateSample;


/**
 SKAttitudeSample is a structure representin a single attitude measurement, along with a timetamp expressed as an NSTimeInterval of seconds since system boot.
 */
typedef struct {
    /**
     The timestamp of the measruement, expressed as an NSTimeInterval of seconds since system boot.
     */
    NSTimeInterval timestamp;
    
    /**
     The roll of the rotation rate
     */
    double roll;
    
    /**
     The pitch of the rotation rate
     */
    double pitch;
    
    /**
     The yaw of the rotation rate
     */
    double yaw;
    
} SKAttitudeSample;

@class SKGyroscopeManager;

/**
 SKGyroscopeManagerDelegate is a protocol defining a list of methods used to interact with measurements made by an instance of SKGyroscopeManager
 */
@protocol SKGyroscopeManagerDelegate<NSObject>

@optional

/**
 Sent to the delegate when the manager recieves a measurement of the device's raw rotation rate

 @param manager The manager that took the measurement
 @param rotationRateSample The measurement that was taken
 */
- (void)gyroscopeManager:(nonnull SKGyroscopeManager *)manager didRecieveRawRotationRate:(SKRotationRateSample)rotationRateSample;

/**
 Sent to the delegate when the manager recieves a measurement of the device's unbiased rotation rate

 @param manager The manager that made the measuremen
 @param rotationRateSample The measurement that was taken
 */
- (void)gyroscopeManager:(nonnull SKGyroscopeManager *)manager didRecieveUnbiasedRotationRate:(SKRotationRateSample)rotationRateSample;

/**
 Sent to the delegate when the manager recieves a measurement of the device's attitude

 @param manager The manager that made the measurement
 @param attitudeSample The measurement that was taken
 */
- (void)gyroscopeManager:(nonnull SKGyroscopeManager *)manager didRecieveAttitude:(SKAttitudeSample)attitudeSample;

/**
 Sent to the delegate when the manager attemps to make a measurement and fails

 @param manager The manager that failed to make a measurement
 @param error The error that caused the failure
 */
- (void)gyroscopeManager:(nonnull SKGyroscopeManager *)manager didFailWithError:(nonnull NSError *)error;

@end

/**
 SKGyroscopeManager is a class used to get measurements made from the device's built-in gyroscope
 */
@interface SKGyroscopeManager : NSObject

/**
 The delegate object used to handle measurements made by the manager
 */
@property (weak, nullable) id<SKGyroscopeManagerDelegate> delegate;

/**
 The tracking status of the manager
 */
@property (NS_NONATOMIC_IOSONLY, readonly, getter=isTracking) BOOL tracking;

/**
 The last measurement of the device's raw rotation rate
 */
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKRotationRateSample rawRotationRate;

/**
 The last measurement of the device's unbiased rotation rate
 */
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKRotationRateSample unbiasedRotationRate;

/**
 The last measurement of the device's attitude
 */
@property (NS_NONATOMIC_IOSONLY, assign, readonly) SKAttitudeSample attitude;

/**
 Create a gyroscope manager with a delegate object

 @param delegate The delegate object used to handle measuerments made by the manager
 @return The gyroscope manager
 */
- (nullable instancetype)initWithDelegate:(nullable id<SKGyroscopeManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/**
 STart tracking measurements with an update frequency of 100Hz

 @return YES if tracking began, otherwise NO.
 */
- (BOOL)startTracking;

/**
 Start tracking measurements

 @param frequency The desired frequency of measurement updates, expressed in seconds
 @return YES if tracking began, otherwise NO.
 */
- (BOOL)startTrackingWithUpdateFrequency:(double)frequency;

/**
 Stop tracking measurements

 @return YES if trackign stopped, otherwise NO.
 */
- (BOOL)stopTracking;

/**
 Create a human readable string from a rotation rate sample

 @param rotationRateSample The rotation rate sample
 @return The human readable string
 */
NSString * _Nonnull NSStringFromSKRotationRateSample(SKRotationRateSample rotationRateSample);

/**
 Create a human readable string from an attitude sample

 @param attitudeSample The attitude sample
 @return The human readable string
 */
NSString * _Nonnull NSStringFromSKAttitudeSample(SKAttitudeSample attitudeSample);

@end
