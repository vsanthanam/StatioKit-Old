//
//  SKProcessorInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/23/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

@interface SKProcessorInfo : NSObject

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger processors;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger activeProcessors;

+ (nullable instancetype)sharedProcessorInfo;

- (double)processorUsageForProcessorAtIndex:(NSUInteger)index;

@end
