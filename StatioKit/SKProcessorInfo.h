//
//  SKProcessorInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/23/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

/**
 SKProcessorInfo is a singleton instance used to retrieve information about the CPU and it's current usage.
 */
@interface SKProcessorInfo : NSObject

/**
 @name Accessing The Singleton
 */

/**
 Get the shared instance

 @return The shared instsance
 */
+ (nullable instancetype)sharedProcessorInfo;

/**
 @name CPU Info
 */

/**
 Total number of processors
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger processors;

/**
 @name CPU Usage
 */

/**
 Total number of active processors
 */
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger activeProcessors;

/**
 Get the usage from 0.0-1.0 of a core

 @param index Index of the core
 @return The usage, expresed as a double from 0.0 - 1.0
 */
- (double)processorUsageForProcessorAtIndex:(NSUInteger)index;

@end
