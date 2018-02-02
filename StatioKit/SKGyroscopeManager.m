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
@property (nonatomic, strong, readonly) CMMotionManager *internalMotionManager;

@end

@implementation SKGyroscopeManager

@synthesize delegate = _delegate;
@synthesize rotationRateSample = _rotationRateSample;

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
    
    return self.internalMotionManager.gyroActive;
    
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
    
    return [self startTrackigWithUpdateFrequency:0.01f];
    
}

- (BOOL)startTrackigWithUpdateFrequency:(double)frequency {
    
    if (!self.isTracking && self.internalMotionManager.gyroAvailable) {
        
        self.internalMotionManager.gyroUpdateInterval = frequency;
        
        CMGyroHandler handler = ^(CMGyroData *gyroscopeData, NSError *error) {
            
            if (error) {
                
                [self _processError:error];
                
            } else if (gyroscopeData) {
                
                [self _processGyroscopeData:gyroscopeData];
                
            }
        
        };
        
        [self.internalMotionManager startGyroUpdatesToQueue:self.gyroscopeQueue
                                                withHandler:handler];
        
        return YES;
        
    }
    
    return NO;
    
}

- (BOOL)stopTracking {
    
    if (self.tracking) {
        
        [self.internalMotionManager stopGyroUpdates];
        [self.gyroscopeQueue waitUntilAllOperationsAreFinished];
        
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
    
    _rotationRateSample = rotationRateSample;
    
    if ([self.delegate respondsToSelector:@selector(gyroscopeManager:didRecieveRotationRateSample:)]) {
        
        [self.delegate gyroscopeManager:self
           didRecieveRotationRateSample:self.rotationRateSample];
        
    }
    
}

- (void)_processError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(gyroscopeManager:didFailToGetGyroscopeDataWithError:)]) {
        
        [self.delegate gyroscopeManager:self
     didFailToGetGyroscopeDataWithError:error];
        
    }
    
}

@end
