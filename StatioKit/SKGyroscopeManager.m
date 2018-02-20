//
//  SKGyroscopeManager.m
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import CoreMotion;

#import "SKGyroscopeManager.h"

@interface SKGyroscopeManager ()

@property (nonatomic, strong) NSOperationQueue *gyroscopeQueue;
@property (nonatomic, strong) NSOperationQueue *deviceMotionQueue;
@property (nonatomic, strong, readonly) CMMotionManager *internalMotionManager;

@end

@implementation SKGyroscopeManager

@synthesize delegate = _delegate;
@synthesize rawRotationRate = _rawRotationRate;
@synthesize unbiasedRotationRate = _unbiasedRotationRate;
@synthesize attitude = _attitude;

@synthesize gyroscopeQueue = _gyroscopeQueue;
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
    
    return self.internalMotionManager.gyroActive && self.internalMotionManager.deviceMotionActive;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithDelegate:(id<SKGyroscopeManagerDelegate>)delegate {
    
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
    
    if (!self.isTracking && self.internalMotionManager.gyroAvailable && self.internalMotionManager.deviceMotionAvailable) {
        
        self.internalMotionManager.gyroUpdateInterval = frequency;
        self.gyroscopeQueue = [[NSOperationQueue alloc] init];
        self.internalMotionManager.deviceMotionUpdateInterval = frequency;
        self.deviceMotionQueue = [[NSOperationQueue alloc] init];
        
        CMGyroHandler gyroscopeHandler = ^(CMGyroData *gyroscopeData, NSError *error) {
            
            if (error) {
                
                [self _processError:error];
                
            } else if (gyroscopeData) {
                
                [self _processGyroscopeData:gyroscopeData];
                
            }
        
        };
        
        [self.internalMotionManager startGyroUpdatesToQueue:self.gyroscopeQueue
                                                withHandler:gyroscopeHandler];
        
        CMDeviceMotionHandler deviceMotionHandler = ^(CMDeviceMotion *deviceMotion, NSError *error) {
            
            if (error) {
                
                [self _processError:error];
                
            } else if (deviceMotion) {
                
                [self _processDeviceMotion:deviceMotion];
                
            }
            
        };
        
        [self.internalMotionManager startDeviceMotionUpdatesToQueue:self.deviceMotionQueue
                                                        withHandler:deviceMotionHandler];
        
        return YES;
        
    }
    
    return NO;
    
}

- (BOOL)stopTracking {
    
    if (self.tracking) {
        
        [self.internalMotionManager stopGyroUpdates];
        [self.gyroscopeQueue waitUntilAllOperationsAreFinished];
        
        [self.internalMotionManager stopDeviceMotionUpdates];
        [self.deviceMotionQueue waitUntilAllOperationsAreFinished];
        
        return YES;
        
    }
    
    return NO;
    
}

#pragma mark - Private Instance Methods

- (void)_processGyroscopeData:(CMGyroData *)gyroscopeData {
    
    SKRotationRateSample rotationRateSample;
    
    rotationRateSample.timestamp = gyroscopeData.timestamp;
    rotationRateSample.x = gyroscopeData.rotationRate.x;
    rotationRateSample.y = gyroscopeData.rotationRate.y;
    rotationRateSample.z = gyroscopeData.rotationRate.z;
    
    _rawRotationRate = rotationRateSample;
    
    if ([self.delegate respondsToSelector:@selector(gyroscopeManager:didRecieveRawRotationRate:)]) {
        
        [self.delegate gyroscopeManager:self
              didRecieveRawRotationRate:self.rawRotationRate];
        
    }
    
}

- (void)_processDeviceMotion:(CMDeviceMotion *)deviceMotion {
    
    SKRotationRateSample rotationRateSample;
    rotationRateSample.timestamp = deviceMotion.timestamp;
    rotationRateSample.x = deviceMotion.rotationRate.x;
    rotationRateSample.y = deviceMotion.rotationRate.y;
    rotationRateSample.z = deviceMotion.rotationRate.z;
    
    _unbiasedRotationRate = rotationRateSample;
    
    if ([self.delegate respondsToSelector:@selector(gyroscopeManager:didRecieveUnbiasedRotationRate:)]) {
        
        [self.delegate gyroscopeManager:self
         didRecieveUnbiasedRotationRate:self.unbiasedRotationRate];
        
    }
    
    SKAttitudeSample attitudeSample;
    attitudeSample.timestamp = deviceMotion.timestamp;
    attitudeSample.roll = deviceMotion.attitude.roll;
    attitudeSample.pitch = deviceMotion.attitude.pitch;
    attitudeSample.yaw = deviceMotion.attitude.yaw;
    
    _attitude = attitudeSample;
    
    if ([self.delegate respondsToSelector:@selector(gyroscopeManager:didRecieveAttitude:)]) {
        
        [self.delegate gyroscopeManager:self
                     didRecieveAttitude:self.attitude];
        
    }
    
}

- (void)_processError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(gyroscopeManager:didFailWithError:)]) {
        
        [self.delegate gyroscopeManager:self
                       didFailWithError:error];
        
    }
    
}

#pragma mark - C Functions

NSString * NSStringFromSKRotationRateSample(SKRotationRateSample rotationRateSample) {
    
    return [NSString stringWithFormat:@"rotation rate = (%f, %f, %f)", rotationRateSample.x, rotationRateSample.y, rotationRateSample.z];
    
}

NSString * NSStringFromSKAttitudeSample(SKAttitudeSample attidudeSample) {
    
    return [NSString stringWithFormat:@"attitude = (roll: %f, pitch = %f, yaw %f)", attidudeSample.roll, attidudeSample.pitch, attidudeSample.yaw];
    
}

@end
