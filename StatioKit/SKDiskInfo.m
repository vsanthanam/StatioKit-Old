//
//  SKDiskInfo.m
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "SKDiskInfo.h"

#import "sk_log.h"

@implementation SKDiskInfo

static os_log_t disk_info_log;

#pragma mark - Overridden Class Methods

+ (void)initialize {
 
    disk_info_log = sk_log_create("SKDiskInfo");
    
}

#pragma mark - Public Class Methods

+ (instancetype)sharedDiskInfo {
    
    static SKDiskInfo *sharedDiskInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedDiskInfo = [[self alloc] init];
        
    });
    
    return sharedDiskInfo;
    
}

#pragma mark - Property Access Methods

- (unsigned long long)totalDiskSpace {
    
    unsigned long long space = 0;
    
    NSError *error;
    
    NSArray<NSURL *> *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSDictionary *dict =  [urls.lastObject resourceValuesForKeys:@[NSURLVolumeTotalCapacityKey] error:&error];
    
    if (dict) {
        
        NSNumber *size = dict[NSURLVolumeTotalCapacityKey];
        space = size.unsignedLongLongValue;
        
    } else if (error) {
        
        os_log_error(disk_info_log, "Couldn't Fetch Total Disk Space: %{public}@", error.localizedDescription);
        
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
        
    } else if (error) {
        
        os_log_error(disk_info_log, "Couldn't Fetch Free Disk Space: %{public}@", error.localizedDescription);
        
    }
    
    return space;
    
}

@end
