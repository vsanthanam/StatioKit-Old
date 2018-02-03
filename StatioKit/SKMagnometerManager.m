//
//  SKMagnometerManager.m
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import CoreMotion;

#import "SKMagnometerManager.h"

@interface SKMagnometerManager ()

@property (nonatomic, strong) NSOperationQueue *magnometerQueue;
@property (nonatomic, strong, readonly) CMMotionManager *internalMotionManager;

@end

@implementation SKMagnometerManager

@synthesize delegate = _delegate;
@synthesize magneticFieldSample = _magneticFieldSample;

@synthesize magnometerQueue = _magnometerQueue;
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
    
    return self.internalMotionManager.magnetometerActive;
    
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
    
    if (!self.tracking && self.internalMotionManager.magnetometerAvailable) {
        
        self.internalMotionManager.magnetometerUpdateInterval = frequency;
        self.magnometerQueue = [[NSOperationQueue alloc] init];
        
        CMMagnetometerHandler handler = ^(CMMagnetometerData *magnometerData, NSError *error) {
            
            if (error) {
                
                [self _processError:error];
                
            } else if (magnometerData) {
                
                [self _processMagnometerData:magnometerData];
                
            }
            
        };
        
        [self.internalMotionManager startMagnetometerUpdatesToQueue:self.magnometerQueue
                                                        withHandler:handler];
        
        return YES;
        
    }
    
    return NO;
    
}

- (BOOL)stopTracking {
    
    if (self.tracking) {
        
        [self.internalMotionManager stopMagnetometerUpdates];
        [self.magnometerQueue waitUntilAllOperationsAreFinished];
        
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
    
    _magneticFieldSample = magneticFieldSample;
    
    if ([self.delegate respondsToSelector:@selector(magnometerManager:didRecieveMagneticFieldSample:)]) {
        
        [self.delegate magnometerManager:self
           didRecieveMagneticFieldSample:self.magneticFieldSample];
        
    }
    
}

- (void)_processError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(magnometerManager:didFailToGetMagnometerDataWithError:)]) {
        
        [self.delegate magnometerManager:self
     didFailToGetMagnometerDataWithError:error];
        
    }
    
}

#pragma mark - C Functions

NSString * NSStringFromSKMagneticFieldSample(SKMagneticFieldSample magneticFieldSample) {
    
    return [NSString stringWithFormat:@"magnetic field = (%f, %f, %f)", magneticFieldSample.x, magneticFieldSample.y, magneticFieldSample.z];
    
}

@end
