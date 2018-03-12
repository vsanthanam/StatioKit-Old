//
//  SKAccelerometerManager.m
//  StatioKit
//
//  Created by Varun Santhanam on 2/1/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import CoreMotion;

#import "SKAccelerometerManager.h"

@interface SKAccelerometerManager ()

@property (nonatomic, strong) NSOperationQueue *accelerometerQueue;
@property (nonatomic, strong) NSOperationQueue *deviceMotionQueue;
@property (nonatomic, strong, readonly) CMMotionManager *internalMotionManager;

@end

@implementation SKAccelerometerManager

@synthesize delegate = _delegate;
@synthesize deviceAcceleration = _deviceAcceleration;
@synthesize userAcceleration = _userAcceleration;

@synthesize accelerometerQueue = _accelerometerQueue;
@synthesize deviceMotionQueue = _deviceMotionQueue;
@synthesize internalMotionManager = _internalMotionManager;

#pragma mark = Overridden Instance Methods

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
    
    return self.internalMotionManager.accelerometerActive && self.internalMotionManager.deviceMotionActive;
    
}

#pragma mark - Public Instance Methods

- (instancetype)initWithDelegate:(id<SKAccelerometerManagerDelegate>)delegate {
    
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
    
    if (!self.isTracking && self.internalMotionManager.accelerometerAvailable && self.internalMotionManager.deviceMotionAvailable) {
        
        self.internalMotionManager.accelerometerUpdateInterval = frequency;
        self.internalMotionManager.deviceMotionUpdateInterval = frequency;
        self.accelerometerQueue = [[NSOperationQueue alloc] init];
        self.deviceMotionQueue = [[NSOperationQueue alloc] init];
        
        CMAccelerometerHandler accelerometerHandler = ^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            if (error) {
                
                [self _processError:error];
                
            } else if (accelerometerData) {
                
                [self _processAccelerometerData:accelerometerData];
                
            }
            
        };
     
        [self.internalMotionManager startAccelerometerUpdatesToQueue:self.accelerometerQueue
                                                         withHandler:accelerometerHandler];
        
        CMDeviceMotionHandler deviceMotionHandler = ^(CMDeviceMotion *deviceMotion, NSError *error) {
            
            if (error) {
                
                [self _processError:error];
                
            } else if (deviceMotion) {
                
                [self _processError:error];
                
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
        
        [self.internalMotionManager stopAccelerometerUpdates];
        [self.accelerometerQueue waitUntilAllOperationsAreFinished];
        
        [self.internalMotionManager stopDeviceMotionUpdates];
        [self.deviceMotionQueue waitUntilAllOperationsAreFinished];
        
        return YES;
        
    }
    
    return NO;
}

#pragma mark - Private Instance Methods

- (void)_processAccelerometerData:(CMAccelerometerData *)accelerometerData {
    
    SKAccelerationSample sample = SKAccelerationSampleMake(accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z, accelerometerData.timestamp);

    _deviceAcceleration = sample;

    if ([self.delegate respondsToSelector:@selector(accelerometerManager:didRecieveDeviceAcceleration:)]) {

        [self.delegate accelerometerManager:self
               didRecieveDeviceAcceleration:self.deviceAcceleration];

    }
    
}

- (void)_processDeviceMotion:(CMDeviceMotion *)deviceMotion {
    
    SKAccelerationSample sample = SKAccelerationSampleMake(deviceMotion.userAcceleration.x, deviceMotion.userAcceleration.y, deviceMotion.userAcceleration.z, deviceMotion.timestamp);
    
    _userAcceleration = sample;
    
    if ([self.delegate respondsToSelector:@selector(accelerometerManager:didRecieveUserAcceleration:)]) {
        
        [self.delegate accelerometerManager:self
                 didRecieveUserAcceleration:self.userAcceleration];
        
    }
    
}

- (void)_processError:(NSError *)error {
 
    if ([self.delegate respondsToSelector:@selector(accelerometerManager:didFailWithError:)]) {
        
        [self.delegate accelerometerManager:self
                           didFailWithError:error];

    }
    
}

#pragma mark - C Functions

SKAccelerationSample SKAccelerationSampleMake(double x, double y, double z, NSTimeInterval timestamp) {
    
    SKAccelerationSample sample;
    sample.x = x;
    sample.y = y;
    sample.z = z;
    sample.timestamp = timestamp;
    
    return sample;
    
}

@end
