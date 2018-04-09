//
//  SKLocationManager.m
//  StatioKit
//
//  Created by Varun Santhanam on 4/8/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "SKLocationManager.h"

@implementation SKLocationManager

@synthesize delegate = _delegate;

- (instancetype)init {
    
    self = [self initWithDelegate:nil];
 
    return self;
    
}

- (instancetype)initWithDelegate:(id<SKLocationManagerDelegate>)delegate {
    
    self = [super init];
    
    if (self) {
        
        _delegate = delegate;
        
    }
    
    return self;
    
}

- (void)startTracking {
    
}

- (void)stopTracking {
    
}

@end
