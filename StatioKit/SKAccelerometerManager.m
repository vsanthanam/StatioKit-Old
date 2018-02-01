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

@property (nonatomic, strong) NSOperationQueue *accelerationDataQueue;
@property (nonatomic, strong, readonly) CMMotionManager *internalMotionManager;

@end

@implementation SKAccelerometerManager

@synthesize delegate = _delegate;

@synthesize accelerationDataQueue = _accelerationDataQueue;
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
        _internalMotionManager.deviceMotionUpdateInterval = 0.01f;
        
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
    
    return NO;
    
}

- (BOOL)stopTracking {
    
    if (self.tracking) {
        
        [self.internalMotionManager stopAccelerometerUpdates];
        [self.accelerationDataQueue waitUntilAllOperationsAreFinished];
        
        return YES;
        
    }
    
    return NO;
}

#pragma mark - Private Instance Methods

- (void)_processAccelerometerData:(CMAccelerometerData *)accelerometerData {
    
}

- (void)_processError:(NSError *)error {
    
}

@end
