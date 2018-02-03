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
@property (nonatomic, strong, readonly) CMMotionManager *internalMotionManager;

@end

@implementation SKAccelerometerManager

@synthesize delegate = _delegate;
@synthesize accelerationSample = _accelerationSample;

@synthesize accelerometerQueue = _accelerometerQueue;
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
    
    return self.internalMotionManager.accelerometerActive;
    
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
    
    if (!self.isTracking && self.internalMotionManager.accelerometerAvailable) {
        
        self.internalMotionManager.accelerometerUpdateInterval = frequency;
        self.accelerometerQueue = [[NSOperationQueue alloc] init];
        
        CMAccelerometerHandler handler = ^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            if (error) {
                
                [self _processError:error];
                
            } else if (accelerometerData) {
                
                [self _processAccelerometerData:accelerometerData];
                
            }
            
        };
     
        [self.internalMotionManager startAccelerometerUpdatesToQueue:self.accelerometerQueue
                                                         withHandler:handler];
        
        return YES;
        
    }
    
    return NO;
    
}

- (BOOL)stopTracking {
    
    if (self.tracking) {
        
        [self.internalMotionManager stopAccelerometerUpdates];
        [self.accelerometerQueue waitUntilAllOperationsAreFinished];
        
        return YES;
        
    }
    
    return NO;
}

#pragma mark - Private Instance Methods

- (void)_processAccelerometerData:(CMAccelerometerData *)accelerometerData {
    
    SKAccelerationSample accelerationSample;
    accelerationSample.timestamp = accelerometerData.timestamp;
    accelerationSample.x = accelerometerData.acceleration.x;
    accelerationSample.y = accelerometerData.acceleration.y;
    accelerationSample.z = accelerometerData.acceleration.z;
    
    _accelerationSample = accelerationSample;
    
    if ([self.delegate respondsToSelector:@selector(accelerometerManager:didRecieveAccelerationSample:)]) {
        
        [self.delegate accelerometerManager:self
               didRecieveAccelerationSample:self.accelerationSample];
        
    }
    
}

- (void)_processError:(NSError *)error {
 
    if ([self.delegate respondsToSelector:@selector(accelerometerManager:didFailToGetAccelerometerDataWithError:)]) {
        
        [self.delegate accelerometerManager:self
     didFailToGetAccelerometerDataWithError:error];
        
    }
    
}

#pragma mark - C Functions

NSString * NSStringFromSKAccelerationSample(SKAccelerationSample accelerationSample) {
    
    return [NSString stringWithFormat:@"acceleration = (%f, %f, %f)", accelerationSample.x, accelerationSample.y, accelerationSample.z];
    
}

@end
