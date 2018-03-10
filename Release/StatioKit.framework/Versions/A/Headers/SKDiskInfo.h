//
//  SKDiskInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

@interface SKDiskInfo : NSObject

@property (NS_NONATOMIC_IOSONLY, readonly) unsigned long long totalDiskSpace;
@property (NS_NONATOMIC_IOSONLY, readonly) unsigned long long freeDiskSpace;

+ (nullable instancetype)sharedDiskInfo;

@end
