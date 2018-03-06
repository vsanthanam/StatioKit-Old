//
//  SKProcessorInfo.m
//  StatioKit
//
//  Created by Varun Santhanam on 1/23/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Darwin.sys.sysctl;
@import Darwin.sys.param;
@import Darwin.POSIX.sys.utsname;
@import Darwin.Mach;

#import "NSBundle+StatioKit.h"

#import "SKProcessorInfo.h"

@implementation SKProcessorInfo {
    
    NSArray<NSNumber *> *_usageArray;
    
}

+ (instancetype)sharedProcessorInfo {
    
    static SKProcessorInfo *sharedProcessorInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedProcessorInfo = [[self alloc] init];
        
    });
    
    return sharedProcessorInfo;
    
}

- (NSString *)processorModel {
    
    int mib[2];
    
    mib[0] = CTL_HW;
    mib[1] = HW_MODEL;
    
    size_t size = 0;
    
    sysctl(mib, 2, NULL, &size, NULL, 0);
    
    char * result = malloc(size * sizeof(char));
    
    sysctl(mib, 2, result, &size, NULL, 0);
    
    NSString *rv = [[NSString alloc] initWithUTF8String:result];
    
    free(result);
    
    return rv;
    
}

- (NSString *)processorName {
 
    NSDictionary *info = cpu_names()[self.processorModel];
    
    return info[@"Name"] ? info[@"Name"] : @"Unknown";
    
}

- (NSString *)architecture {
    
    NSMutableString *cpu = [[NSMutableString alloc] init];
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    // values for cputype and cpusubtype defined in mach/machine.h
    if (type == CPU_TYPE_X86_64) {
        [cpu appendString:@"x86_64"];
    } else if (type == CPU_TYPE_X86) {
        [cpu appendString:@"x86"];
    } else if (type == CPU_TYPE_ARM) {
        [cpu appendString:@"arm"];
        switch(subtype)
        {
            case CPU_SUBTYPE_ARM_V6:
                [cpu appendString:@"v6"];
                break;
            case CPU_SUBTYPE_ARM_V7:
                [cpu appendString:@"v7"];
                break;
            case CPU_SUBTYPE_ARM_V7S:
                [cpu appendString:@"v7s"];
                break;
        }
    } else if (type == CPU_TYPE_ARM64) {
        [cpu appendFormat:@"arm64"];
    }

    return cpu.length > 0 ? [cpu copy] : @"Unknown";
    
}

- (double)frequency {
    
    NSDictionary *info = cpu_names()[self.processorModel];
    NSNumber *f = info[@"Clockspeed"];
    
    return f ? f.doubleValue : 0.0f;
    
}

- (NSUInteger)physicalCores {
    
    size_t size;
    unsigned int cpu;
    size = sizeof(cpu);
    sysctlbyname("hw.physicalcpu", &cpu, &size, NULL, 0);
    
    return (NSUInteger)cpu;
    
}

- (NSUInteger)logicalCores {
    
    size_t size;
    unsigned int cpu;
    size = sizeof(cpu);
    sysctlbyname("hw.ncpu", &cpu, &size, NULL, 0);
    
    return (NSUInteger)cpu;
    
}

- (double)processorUsage {
    
    [self _updateProcessorUsage];
    
    double total = 0.0f;
    
    for (NSNumber *usage in _usageArray) {
        
        total += usage.doubleValue;
        
    }
    
    return total / (_usageArray.count);
    
}


- (double)processorUsageForCore:(NSUInteger)core {
    
    [self _updateProcessorUsage];
    
    if (core < _usageArray.count) {
        
        return _usageArray[core].doubleValue;
        
    }
    
    return 0.0f;
    
}

- (void)_updateProcessorUsage {
    
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    // Get the number of processors from sysctl
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if (_status)
        _numCPUs = 1;
    
    // Allocate the lock
    _cpuUsageLock = [[NSLock alloc] init];
    
    // Get the processor info
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if (err == KERN_SUCCESS) {
        
        [_cpuUsageLock lock];
        
        // Go through info for each processor
        NSMutableArray *processorInfo = [NSMutableArray new];
        for (unsigned i = 0U; i < _numCPUs; ++i) {
            
            Float32 _inUse, _total;
            
            if (_prevCPUInfo) {
                
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
                
            } else {
                
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
                
            }
            // Add to the processor usage info
            [processorInfo addObject:@(_inUse / _total)];
        }
        
        [_cpuUsageLock unlock];
        
        if (_prevCPUInfo) {
            
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
            
        }
        
        _usageArray = processorInfo;
        
    } else {
        
        _usageArray = nil;
        
    }
    
}

NSDictionary * cpu_names(void) {
    
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle statioKitResources] pathForResource:@"CPUNames" ofType:@"plist"]];
    
}

@end
