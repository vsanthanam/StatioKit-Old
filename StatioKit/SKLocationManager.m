//
//  SKLocationManager.m
//  StatioKit
//
//  Created by Varun Santhanam on 4/8/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import CoreLocation;

#import "SKLocationManager.h"

@interface SKLocationManager ()<CLLocationManagerDelegate>

@property (NS_NONATOMIC_IOSONLY, strong, readonly) CLLocationManager *locationManager;

@end

@implementation SKLocationManager

@synthesize delegate = _delegate;
@synthesize locationSample = _locationSample;

@synthesize locationManager = _locationManager;

- (instancetype)init {
    
    self = [self initWithDelegate:nil];
 
    return self;
    
}

- (CLLocationManager *)locationManager {
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        
    }
    
    return _locationManager;
    
}

- (instancetype)initWithDelegate:(id<SKLocationManagerDelegate>)delegate {
    
    self = [super init];
    
    if (self) {
        
        _delegate = delegate;
        
    }
    
    return self;
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [manager startUpdatingLocation];
        
    } else {
        
        [self _startTracking];
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (locations.count >= 1) {
        
        CLLocation *loc = locations.lastObject;
        
        SKLocationSample sample = SKLocationSampleMake(loc.coordinate.latitude,
                                                       loc.coordinate.longitude,
                                                       loc.altitude,
                                                       loc.floor.level,
                                                       loc.horizontalAccuracy,
                                                       loc.verticalAccuracy,
                                                       loc.speed,
                                                       loc.course);
        
        _locationSample = sample;
        
        if ([self.delegate respondsToSelector:@selector(locationManager:didRecieveLocationSample:)]) {
            
            [self.delegate locationManager:self
                  didRecieveLocationSample:sample];
            
        }
        
    }
    
}

#pragma mark - Private Instance Methods

- (void)_startTracking {
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)_stopTracking {
    
    [self.locationManager stopUpdatingLocation];
    
}

#pragma mark - Public Instance Methods

- (void)startTracking {
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        [self.locationManager requestWhenInUseAuthorization];
        
    } else  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    
        if ([self.delegate respondsToSelector:@selector(locationManagerFailedToStartUpdating:)]) {
            
            [self.delegate locationManagerFailedToStartUpdating:self];
            
        }
        
    } else {
     
        [self _startTracking];
        
    }
    
}

- (void)stopTracking {
    
    [self _stopTracking];
    
}

#pragma mark - C functions

SKLocationSample SKLocationSampleMake(double lat, double lon, double altitude, NSInteger floor, double horizontalAccuracy, double verticalAccuracy, double speed, double course) {
    
    SKLocationSample sample;
    
    sample.lat = lat;
    sample.lon = lon;
    sample.altitude = altitude;
    sample.floor = floor;
    sample.horizontalAccuracy = horizontalAccuracy;
    sample.verticalAccuracy = verticalAccuracy;
    sample.speed = speed;
    sample.course = course;
    
    return sample;
    
}

@end
