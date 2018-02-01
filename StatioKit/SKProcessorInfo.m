//
//  SKProcessorInfo.m
//  StatioKit
//
//  Created by Varun Santhanam on 1/23/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Darwin.Mach;
@import Darwin.sys.sysctl;

#import "SKProcessorInfo.h"

@implementation SKProcessorInfo

+ (instancetype)sharedProcessorInfo {
    
    static SKProcessorInfo *sharedProcessorInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedProcessorInfo = [[self alloc] init];
        
    });
    
    return sharedProcessorInfo;
    
}

- (NSUInteger)processors {
    
    return [NSProcessInfo processInfo].processorCount;
    
}

- (NSUInteger)activeProcessors {
    
    return [NSProcessInfo processInfo].activeProcessorCount;
    
}

- (double)processorUsageForProcessorAtIndex:(NSUInteger)index {
    
    processor_info_array_t cpuInfo, prevCPUInfo = nil;
    mach_msg_type_number_t numCPUInfo, numPrevCPUInfo = 0;
    unsigned numCPUs;
    
    NSLock *cpuUsageLock;
    
    int mib[2U] = { CTL_HW, HW_NCPU };
    
    size_t sizeOfNumCPUs = sizeof(numCPUs);
    
    int status = sysctl(mib, 2U, &numCPUs, &sizeOfNumCPUs, NULL, 0U);
    
    if (status)
        numCPUs = 1;
    
    cpuUsageLock = [[NSLock alloc] init];
    
    natural_t numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCPUInfo);
    
    if (err == KERN_SUCCESS) {
        
        [cpuUsageLock lock];

        NSArray<NSNumber *> *processorInfo = [[NSArray<NSNumber *> alloc] init];
        
        for (unsigned i = 0U; i < numCPUs; ++i) {
            
            Float32 inUse, total;
            
            if (prevCPUInfo) {
                
                inUse = ((cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE] - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                        );
                
                total = inUse + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
                
            } else {
                
                inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                total = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
                
            }

            processorInfo = [processorInfo arrayByAddingObject:@(inUse / total)];
        }
        
        [cpuUsageLock unlock];
        
        if (prevCPUInfo) {
            
            size_t prevCpuInfoSize = sizeof(integer_t) * numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)prevCPUInfo, prevCpuInfoSize);
            
        }

        return processorInfo[index].doubleValue;
        
    } else {

        return 0.0f;
        
    }
    
}

@end
