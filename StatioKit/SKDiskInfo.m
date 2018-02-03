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

@end
