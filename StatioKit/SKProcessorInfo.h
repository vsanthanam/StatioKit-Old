//
//  SKProcessorInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/23/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

@interface SKProcessorInfo : NSObject


@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *processorModel;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *processorName;
@property (NS_NONATOMIC_IOSONLY, readonly, nullable) NSString *architecture;

@property (NS_NONATOMIC_IOSONLY, readonly) double frequency;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger physicalCores;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger logicalCores;
@property (NS_NONATOMIC_IOSONLY, readonly) double processorUsage;

+ (nullable instancetype)sharedProcessorInfo;

- (double)processorUsageForCore:(NSUInteger)core;

- (void)updateProcessorUsage;

@end
