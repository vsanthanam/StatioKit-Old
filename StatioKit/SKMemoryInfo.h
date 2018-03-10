//
//  SKMemoryInfo.h
//  StatioKit
//
//  Created by Varun Santhanam on 1/18/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Foundation;

@interface SKMemoryInfo : NSObject

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger physicalMemory;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger freeMemory;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger activeMemory;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger inactiveMemory;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger wiredMemory;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger pageIns;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger pageOuts;

+ (nullable instancetype)sharedMemoryInfo;

NSString * _Nonnull NSStringFromBytes(NSUInteger bytes);

@end
