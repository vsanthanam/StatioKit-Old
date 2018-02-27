//
//  SKDiskInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 2/2/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

/**
 SKDiskInfo is a singleton instance used to retrieve disk usage information
 */
@interface SKDiskInfo : NSObject

/**
 @name Accessing The Singleton
 */

/**
 Get the shared instance

 @return The shared instance
 */
+ (nullable instancetype)sharedDiskInfo;

@end
