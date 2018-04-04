//
//  SKMagnometerManager.m
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import CoreMotion;

#import "SKMagnometerManager.h"

#import "sk_log.h"

@interface SKMagnometerManager ()

@property (nonatomic, strong) NSOperationQueue *magnometerQueue;
@property (nonatomic, strong) NSOperationQueue *deviceMotionQueue;
@property (nonatomic, strong, readonly) CMMotionManager *internalMotionManager;

@end

@implementation SKMagnometerManager

@synthesize delegate = _delegate;
@synthesize rawMagneticField = _rawMagneticField;
@synthesize unbiasedMagneticField = _unbiasedMagneticField;
@synthesize gravity = _gravity;
@synthesize heading = _heading;

@synthesize magnometerQueue = _magnometerQueue;
@synthesize deviceMotionQueue = _deviceMotionQueue;
@synthesize internalMotionManager = _internalMotionManager;

static os_log_t magnometer_manager_log;

#pragma mark - Public Class Methods

+ (void)initialize {
    
    magnometer_manager_log = sk_log_create("SKMagnometerManager");
    
}

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
    
    return self.internalMotionManager.magnetometerActive && self.internalMotionManager.deviceMotionActive;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithDelegate:(id<SKMagnometerManagerDelegate>)delegate {
    
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
    
    if (!self.tracking && self.internalMotionManager.magnetometerAvailable && self.internalMotionManager.deviceMotionAvailable) {
        
        self.internalMotionManager.magnetometerUpdateInterval = frequency;
        self.magnometerQueue = [[NSOperationQueue alloc] init];
        self.internalMotionManager.deviceMotionUpdateInterval = frequency;
        self.deviceMotionQueue = [[NSOperationQueue alloc] init];
        
        CMMagnetometerHandler magnometerHandler = ^(CMMagnetometerData *magnometerData, NSError *error) {
            
            if (error) {
                
                [self _processError:error];
                
            } else if (magnometerData) {
                
                [self _processMagnometerData:magnometerData];
                
            }
            
        };
        
        [self.internalMotionManager startMagnetometerUpdatesToQueue:self.magnometerQueue
                                                        withHandler:magnometerHandler];
        
        CMDeviceMotionHandler deviceMotionHandler = ^(CMDeviceMotion *deviceMotion, NSError *error) {
                        
            if (error) {
                
                [self _processError:error];
                
            } else {
                
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
        
        [self.internalMotionManager stopMagnetometerUpdates];
        [self.magnometerQueue waitUntilAllOperationsAreFinished];
        
        [self.internalMotionManager stopDeviceMotionUpdates];
        [self.deviceMotionQueue waitUntilAllOperationsAreFinished];
        
        return YES;
        
    }
    
    return NO;
    
}

#pragma mark - Private Instance Methods

- (void)_processMagnometerData:(CMMagnetometerData *)magnometerData {
    
    SKMagneticFieldSample magneticFieldSample;
    magneticFieldSample.timestamp = magnometerData.timestamp;
    magneticFieldSample.x = magnometerData.magneticField.x;
    magneticFieldSample.y = magnometerData.magneticField.y;
    magneticFieldSample.z = magnometerData.magneticField.z;
    
    _rawMagneticField = magneticFieldSample;
    
    if ([self.delegate respondsToSelector:@selector(magnometerManager:didRecieveRawMagneticField:)]) {
        
        [self.delegate magnometerManager:self
              didRecieveRawMagneticField:self.rawMagneticField];
        
    }
    
}

- (void)_processDeviceMotion:(CMDeviceMotion *)deviceMotion {
    
    SKMagneticFieldSample magneticFieldSample = SKMagneticFieldSampleMake(deviceMotion.magneticField.field.x, deviceMotion.magneticField.field.y, deviceMotion.magneticField.field.z, deviceMotion.timestamp);
    
    _unbiasedMagneticField = magneticFieldSample;
    
    if ([self.delegate respondsToSelector:@selector(magnometerMamager:didRecieveUnbiasedMagneticField:)]) {
        
        [self.delegate magnometerMamager:self
         didRecieveUnbiasedMagneticField:self.unbiasedMagneticField];
        
    }
    
    SKGravitySample gravitySample = SKGravitySampleMake(deviceMotion.gravity.x, deviceMotion.gravity.y, deviceMotion.gravity.z, deviceMotion.timestamp);
    
    _gravity = gravitySample;
    
    if ([self.delegate respondsToSelector:@selector(magnometerManager:didRecieveGravity:)]) {
        
        [self.delegate magnometerManager:self
                       didRecieveGravity:self.gravity];
        
    }
    
    SKHeadingSample headingSample = SKHeadingSampleMake(deviceMotion.heading, deviceMotion.timestamp);

    _heading = headingSample;
    
    if ([self.delegate respondsToSelector:@selector(magnometerManager:didRecieveHeading:)]) {
        
        [self.delegate magnometerManager:self
                       didRecieveHeading:self.heading];
        
    }
    
}

- (void)_processError:(NSError *)error {
    
    os_log_error(magnometer_manager_log, "Magnometer Error: %{public}@", error.localizedDescription);
    
    if ([self.delegate respondsToSelector:@selector(magnometerManager:didFailWithError:)]) {
        
        [self.delegate magnometerManager:self
                        didFailWithError:error];
        
    }
    
}

#pragma mark - C Functions

SKMagneticFieldSample SKMagneticFieldSampleMake(double x, double y, double z, NSTimeInterval timestamp) {
    
    SKMagneticFieldSample sample;
    
    sample.x = x;
    sample.y = y;
    sample.z = z;
    sample.timestamp = timestamp;
    
    return sample;
    
}

SKGravitySample SKGravitySampleMake(double x, double y, double z, NSTimeInterval timestamp) {
    
    SKGravitySample sample;
    
    sample.x = x;
    sample.y = y;
    sample.z = z;
    sample.timestamp = timestamp;
    
    return sample;
    
}

SKHeadingSample SKHeadingSampleMake(double heading, NSTimeInterval timestamp) {
    
    SKHeadingSample sample;
    
    sample.heading = heading;
    sample.timestamp = timestamp;
    
    return sample;
    
}

@end
