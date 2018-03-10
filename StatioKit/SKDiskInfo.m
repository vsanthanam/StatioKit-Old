//
//  SKDiskInfo.m
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "SKDiskInfo.h"

@implementation SKDiskInfo

+ (instancetype)sharedDiskInfo {
    
    static SKDiskInfo *sharedDiskInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedDiskInfo = [[self alloc] init];
        
    });
    
    return sharedDiskInfo;
    
}

- (unsigned long long)totalDiskSpace {
    
    unsigned long long space = 0;
    
    NSError *error;
    
    NSArray<NSURL *> *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSDictionary *dict =  [urls.lastObject resourceValuesForKeys:@[NSURLVolumeTotalCapacityKey] error:&error];
    
    if (dict) {
        
        NSNumber *size = dict[NSURLVolumeTotalCapacityKey];
        space = size.unsignedLongLongValue;
        
    }
    
    return space;
    
}

- (unsigned long long)freeDiskSpace {

    unsigned long long space = 0;
    
    NSError *error;
    
    NSArray<NSURL *> *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSDictionary *dict =  [urls.lastObject resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:&error];
    
    if (dict) {
        
        NSNumber *size = dict[NSURLVolumeAvailableCapacityForImportantUsageKey];
        space = size.unsignedLongLongValue;
        
    }
    
    return space;
    
}

@end
