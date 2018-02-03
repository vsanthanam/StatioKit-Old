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
@synthesize attitudeSample = _attitudeSample;
@synthesize unbiasedRotationRateSample = _unbiasedRotationRateSample;
@synthesize gravitySample = _gravitySample;
@synthesize userAccelerationSample = _userAccelerationSample;
@synthesize unbiasedMagneticFieldSample = _unbiasedMagneticFieldSample;
@synthesize headingSample = _headingSample;

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
    
    return [self startTrackingWithUpdateFrequency:0.01f];
    
}

- (BOOL)startTrackingWithUpdateFrequency:(double)frequency {
    
    if (!self.tracking && self.internalMotionManager.deviceMotionAvailable) {
        
        self.internalMotionManager.deviceMotionUpdateInterval = frequency;
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
 
    SKAttitudeSample attitudeSample;
    attitudeSample.timestamp = deviceMotion.timestamp;
    attitudeSample.roll = deviceMotion.attitude.roll;
    attitudeSample.pitch = deviceMotion.attitude.pitch;
    attitudeSample.yaw = deviceMotion.attitude.yaw;
    
    _attitudeSample = attitudeSample;
    
    SKUnbiasedRotationRateSample unbiasedRotationRateSample;
    unbiasedRotationRateSample.timestamp = deviceMotion.timestamp;
    unbiasedRotationRateSample.x = deviceMotion.rotationRate.x;
    unbiasedRotationRateSample.y = deviceMotion.rotationRate.y;
    unbiasedRotationRateSample.z = deviceMotion.rotationRate.z;
    
    _unbiasedRotationRateSample = unbiasedRotationRateSample;
    
    SKGravitySample gravitySample;
    gravitySample.timestamp = deviceMotion.timestamp;
    gravitySample.x = deviceMotion.gravity.x;
    gravitySample.y = deviceMotion.gravity.y;
    gravitySample.z = deviceMotion.gravity.z;
    
    _gravitySample = gravitySample;
    
    SKUserAccelerationSample userAccelerationSample;
    userAccelerationSample.timestamp = deviceMotion.timestamp;
    userAccelerationSample.x = deviceMotion.userAcceleration.x;
    userAccelerationSample.y = deviceMotion.userAcceleration.y;
    userAccelerationSample.z = deviceMotion.userAcceleration.z;
    
    _userAccelerationSample = userAccelerationSample;
    
    SKUnbiasedMagneticFieldSample unbiasedMagneticFieldSample;
    unbiasedMagneticFieldSample.timestamp = deviceMotion.timestamp;
    unbiasedMagneticFieldSample.x = deviceMotion.magneticField.field.x;
    unbiasedMagneticFieldSample.y = deviceMotion.magneticField.field.y;
    unbiasedMagneticFieldSample.z = deviceMotion.magneticField.field.z;
    
    _unbiasedMagneticFieldSample = unbiasedMagneticFieldSample;
    
    if (@available(iOS 11.0, *)) {
        
        SKHeadingSample headingSample;
        
        headingSample.timestamp = deviceMotion.timestamp;
        headingSample.heading = deviceMotion.heading;
     
        _headingSample = headingSample;
        
    }

    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveAttitudeSample:)]) {
        
        [self.delegate deviceMotionManager:self
                  didRecieveAttitudeSample:self.attitudeSample];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveUnbiasedRotationRateSample:)]) {
        
        [self.delegate deviceMotionManager:self
      didRecieveUnbiasedRotationRateSample:self.unbiasedRotationRateSample];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveGravitySample:)]) {
        
        [self.delegate deviceMotionManager:self
                   didRecieveGravitySample:self.gravitySample];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveUserAccelerationSample:)]) {
        
        [self.delegate deviceMotionManager:self
          didRecieveUserAccelerationSample:self.userAccelerationSample];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveUnbiasedMagneticFieldSample:)]) {
        
        [self.delegate deviceMotionManager:self
     didRecieveUnbiasedMagneticFieldSample:self.unbiasedMagneticFieldSample];
        
    }
    
    if (@available(iOS 11.0, *)) {
        
        if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didRecieveHeadingSample:)]) {
        
            [self.delegate deviceMotionManager:self
                       didRecieveHeadingSample:self.headingSample];
            
        }
        
    }
    
}

- (void)_procesError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(deviceMotionManager:didFailToGetDeviceMotionWithError:)]) {
        
        [self.delegate deviceMotionManager:self
         didFailToGetDeviceMotionWithError:error];
        
    }
    
}

#pragma mark - Public C Functions

NSString * NSStringFromSKAttitudeSample(SKAttitudeSample attidudeSample) {
    
    return [NSString stringWithFormat:@"attitude = (roll: %f, pitch = %f, yaw %f)", attidudeSample.roll, attidudeSample.pitch, attidudeSample.yaw];
    
}

NSString * NSStringFromSKUnbiasedRotationRateSample(SKUnbiasedRotationRateSample unbiasedRotationRateSample) {
    
    return [NSString stringWithFormat:@"unbiased rotation rate = (%f, %f, %f)", unbiasedRotationRateSample.x, unbiasedRotationRateSample.y, unbiasedRotationRateSample.z];
    
}

NSString * NSStringFromSKGravitySample(SKGravitySample gravitySample) {
    
    return [NSString stringWithFormat:@"gravity = (%f, %f, %f)", gravitySample.x, gravitySample.y, gravitySample.z];
    
}

NSString * NSStringFromSKUserAccelerationSample(SKUserAccelerationSample userAccelerationSample) {
    
    return [NSString stringWithFormat:@"user acceleration = (%f, %f, %f)", userAccelerationSample.x, userAccelerationSample.y, userAccelerationSample.z];
    
}

NSString * NSStringFromSKUnbiasedMagneticFieldSample(SKUnbiasedMagneticFieldSample unbiasedMagneticFieldSample) {
    
    return [NSString stringWithFormat:@"unbiased magnetic field = (%f, %f, %f)", unbiasedMagneticFieldSample.x, unbiasedMagneticFieldSample.y, unbiasedMagneticFieldSample.z];
    
}

NSString * NSStringFromSKHeadingSample(SKHeadingSample headingSample) {
    
    return [NSString stringWithFormat:@"heading = %f", headingSample.heading];
    
}

@end
