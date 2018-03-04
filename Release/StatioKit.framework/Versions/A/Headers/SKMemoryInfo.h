//
//  SKMemoryInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/18/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

/**
 SKMemoryInfo is a singleton instance used to retrieve current system memory usage.
 */
@interface SKMemoryInfo : NSObject

/**
 @name Accessing The Singleton
 */

/**
 Get the shared instance

 @return The shared instance
 */
+ (nullable instancetype)sharedMemoryInfo;

/**
 @name General Memory Info
 */

/**
 Get the total amount of physical memory in bytes
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger physicalMemory;

/**
 @name Currrent Memory Usage
 */

/**
 Get the amount of free system memory in bytes
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger freeMemory;

/**
 Get the amount of active system memory in bytes
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger activeMemory;

/**
 Get the amount of inactive system memory in bytes
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger inactiveMemory;

/**
 Get the amount of wired memory in bytes
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger wiredMemory;

/**
 @name Current Paging Usage
 */

/**
 Get the amount of total page ins
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger pageIns;

/**
 Get the amount of total page outs
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger pageOuts;

/**
 Format NUIInteger of bytes into a human-readable string

 @param bytes Bytes
 @return Formatted String
 */
NSString * _Nonnull NSStringFromBytes(NSUInteger bytes);

@end
