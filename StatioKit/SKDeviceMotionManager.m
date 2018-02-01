//
//  SKDeviceMotionManager.m
//  StatioKit
//
//  Created by Varun Santhanam on 1/30/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import CoreMotion;

#import "SKDeviceMotionManager.h"

@interface SKDeviceMotionManager ()

@property (nonatomic, strong) NSOperationQueue *deviceMotionQueue;
@property (nonatomic, strong, readonly) CMMotionManager *internalMotionManager;

@end

@implementation SKDeviceMotionManager

@synthesize delegate = _delegate;

@synthesize deviceMotionQueue = _deviceMotionQueue;
@synthesize internalMotionManager = _internalMotionManager;

#pragma mark - Overridden Instance Methods

- (instancetype)init {
    
    self = [self initWithDelegate:nil];
    
    return self;
    
}

#pragma mark - Property Access Methods

- (CMMotionManager *)internalMotionManager {
    
    if (!_internalMotionManager) {
        
        _internalMotionManager = [[CMMotionManager alloc] init];
        _internalMotionManager.deviceMotionUpdateInterval = 0.01f;
        
    }
    
    return _internalMotionManager;
    
}

- (BOOL)isTracking {
    
    return self.internalMotionManager.deviceMotionActive;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithDelegate:(id<SKDeviceMotionManagerDelegate>)delegate {
    
    self = [super init];
    
    if (self) {
        
        self.delegate = delegate;
        
    }
    
    return self;
    
}

- (BOOL)startTracking {
    
    if (!self.tracking && self.internalMotionManager.deviceMotionAvailable) {
        
        self.deviceMotionQueue = [[NSOperationQueue alloc] init];
        
        CMDeviceMotionHandler handler = ^(CMDeviceMotion *deviceMotion, NSError *error) {
            
            if (error) {
                
                [self _procesError:error];
                
            } else if (deviceMotion) {
                
                [self _processMotionData:deviceMotion];
                
            }
            
        };
        
        [self.internalMotionManager startDeviceMotionUpdatesToQueue:self.deviceMotionQueue
                                                        withHandler:handler];
        
        return YES;
        
    }
    
    return NO;
    
}

- (BOOL)stopTracking {
    
    if (self.tracking) {
        
        [self.internalMotionManager stopDeviceMotionUpdates];
        [self.deviceMotionQueue waitUntilAllOperationsAreFinished];
        
        return YES;
        
    }
    
    return NO;
    
}

#pragma mark - Private Instance Methods

- (void)_processMotionData:(CMDeviceMotion *)deviceMotion {
 
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveAttitudeWithRoll:pitch:yaw:atTimestamp:)]) {
        
        [self.delegate deviceMotionManager:self
                didRecieveAttitudeWithRoll:deviceMotion.attitude.pitch
                                     pitch:deviceMotion.attitude.pitch
                                       yaw:deviceMotion.attitude.yaw atTimestamp:deviceMotion.timestamp];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveRotationRateWithX:y:z:atTimestamp:)]) {
        
        [self.delegate deviceMotionManager:self
               didRecieveRotationRateWithX:deviceMotion.rotationRate.x
                                         y:deviceMotion.rotationRate.y
                                         z:deviceMotion.rotationRate.z
                               atTimestamp:deviceMotion.timestamp];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveGravityWithX:y:z:atTimestamp:)]) {
        
        [self.delegate deviceMotionManager:self
                    didRecieveGravityWithX:deviceMotion.gravity.x
                                         y:deviceMotion.gravity.y
                                         z:deviceMotion.gravity.z
                               atTimestamp:deviceMotion.timestamp];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveUserAccelerationWithX:y:z:atTimestamp:)]) {
        
        [self.delegate deviceMotionManager:self
           didRecieveUserAccelerationWithX:deviceMotion.userAcceleration.x
                                         y:deviceMotion.userAcceleration.y
                                         z:deviceMotion.userAcceleration.z
                               atTimestamp:deviceMotion.timestamp];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveUnbiasedMagneticField:y:z:accuracy:atTimestamp:)]) {
        
        [self.delegate deviceMotionManager:self
           didRecieveUnbiasedMagneticField:deviceMotion.magneticField.field.x
                                         y:deviceMotion.magneticField.field.y
                                         z:deviceMotion.magneticField.field.z
                                  accuracy:sk_dm_mag_accuracy_from_mag_accuracy(deviceMotion.magneticField.accuracy)
                               atTimestamp:deviceMotion.timestamp];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveHeading:atTimestamp:)]) {
        
        if (@available(iOS 11.0, *)) {
            
            [self.delegate deviceMotionManager:self
                             didRecieveHeading:deviceMotion.heading
                                   atTimestamp:deviceMotion.timestamp];
            
        }
        
    }
    
}

- (void)_procesError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didFailToGetDeviceMotionWithError:)]) {
        
        [self.delegate deviceMotionManager:self
         didFailToGetDeviceMotionWithError:error];
        
    }
    
}

#pragma mark - C Functions

SKDeviceMotionManagerMagneticFieldAccuracy sk_dm_mag_accuracy_from_mag_accuracy(CMMagneticFieldCalibrationAccuracy accuracy) {
    
    SKDeviceMotionManagerMagneticFieldAccuracy rv;
    
    switch (accuracy) {
            
        case CMMagneticFieldCalibrationAccuracyUncalibrated:
            
            rv = SKDeviceMotionManagerMagneticFieldAccuracyUncalibrated;
            
            break;
        
        case CMMagneticFieldCalibrationAccuracyLow:
            
            rv = SKDeviceMotionManagerMagneticFieldAccuracyLow;
            
            break;
            
        case CMMagneticFieldCalibrationAccuracyMedium:
            
            rv = SKDeviceMotionManagerMagneticFieldAccuracyMedium;
            
            break;
            
        case CMMagneticFieldCalibrationAccuracyHigh:
            
            rv = SKDeviceMotionManagerMagneticFieldAccuracyHigh;
            
            break;
            
        default:
            
            rv = SKDeviceMotionManagerMagneticFieldAccuracyUnknown;
            
            break;
            
    }
    
    return rv;
    
}

@end
