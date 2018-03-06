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

@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *processorModel;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *processorName;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *architecture;
@property (NS_NONATOMIC_IOSONLY, readonly) double frequency;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger physicalCores;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger logicalCores;
@property (NS_NONATOMIC_IOSONLY, readonly) double processorUsage;

- (double)processorUsageForCore:(NSUInteger)core;

@end
