//
//  SKLocationManager.h
//  StatioKit
//
//  Created by Varun Santhanam on 4/8/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

struct SKLocationSample {
    
    double lat;
    double lon;
    double altitude;
    NSInteger floor;
    double horizontalAccuracy;
    double verticalAccuracy;
    double speed;
    double course;

};

typedef struct SKLocationSample SKLocationSample;

@class SKLocationManager;

@protocol SKLocationManagerDelegate<NSObject>

@optional

- (void)locationManagerFailedToStartUpdating:(nonnull SKLocationManager *)manager;
- (void)locationManager:(nonnull SKLocationManager *)manager didRecieveLocationSample:(SKLocationSample)locationSample;

@end

@interface SKLocationManager : NSObject

@property (weak, nullable) id<SKLocationManagerDelegate> delegate;
@property (nonatomic, assign, readonly) SKLocationSample locationSample;

- (nullable instancetype)initWithDelegate:(nullable id<SKLocationManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (void)startTracking;
- (void)stopTracking;

SKLocationSample SKLocationSampleMake(double lat, double lon, double altitude, NSInteger floor, double horizontalAccuracy, double verticalAccuracy, double speed, double course);

@end
