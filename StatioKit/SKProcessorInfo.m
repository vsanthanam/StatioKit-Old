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

@implementation SKProcessorInfo

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
    
    return cpu;
    
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

NSDictionary * cpu_names(void) {
    
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle statioKitResources] pathForResource:@"CPUNames" ofType:@"plist"]];
    
}

@end
