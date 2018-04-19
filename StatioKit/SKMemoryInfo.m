//
//  SKMemoryInfo.m
//  StatioKit
//
//  Created by Varun Santhanam on 1/18/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

@import Darwin.Mach;

#import "SKMemoryInfo.h"

#import "sk_log.h"

@implementation SKMemoryInfo

static os_log_t memory_info_log;

#pragma mark - Overridden Class Methods

+ (void)initialize {
    
    memory_info_log = sk_log_create("SKMemoryInfo");
    
}

#pragma mark - Public Class Methods

+ (instancetype)sharedMemoryInfo {
    
    static SKMemoryInfo *sharedMemoryInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedMemoryInfo = [[self alloc] init];
        
    });
    
    return sharedMemoryInfo;
    
}

#pragma mark - Property Access Methods

- (NSUInteger)physicalMemory {
    
    return (NSUInteger)[[NSProcessInfo processInfo] physicalMemory];

}

- (NSUInteger)freeMemory {
    
    vm_size_t pagesize;
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        
        os_log_info(memory_info_log, "Couldn't get free system memory");
        
        return 0.0f;
        
    }
    
    NSUInteger mem_free = (NSUInteger)vm_stat.free_count * (NSUInteger)pagesize;
    
    return mem_free;

}

- (NSUInteger)activeMemory {
    
    vm_size_t pagesize;
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        
        os_log_info(memory_info_log, "Couldn't get active system memory");
        
        return 0.0f;
        
    }
    
    NSUInteger mem_active = (NSUInteger)vm_stat.active_count * (NSUInteger)pagesize;
    
    return mem_active;
    
}

- (NSUInteger)inactiveMemory {
    
    vm_size_t pagesize;
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        
        os_log_info(memory_info_log, "Couldn't get inactive system memory");
        
        return 0.0f;
        
    }
    
    NSUInteger mem_inactive = (NSUInteger)vm_stat.inactive_count * (NSUInteger)pagesize;
    
    return mem_inactive;
    
}

- (NSUInteger)wiredMemory {
    
    vm_size_t pagesize;
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        
        os_log_info(memory_info_log, "Couldn't get wired system memory");
        
        return 0.0f;
        
    }
    
    NSUInteger mem_wired = (NSUInteger)vm_stat.wire_count * (NSUInteger)pagesize;
    
    return mem_wired;
    
}

- (NSUInteger)pageIns {
    
    vm_size_t pagesize;
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        
        os_log_info(memory_info_log, "Couldn't get system page ins");
        
        return 0.0f;
        
    }
    
    NSUInteger page_ins = (NSUInteger)vm_stat.pageins;
    
    return page_ins;
    
}

- (NSUInteger)pageOuts {
    
    vm_size_t pagesize;
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        
        os_log_info(memory_info_log, "Couldn't get system page outs");
        
        return 0.0f;
        
    }
    
    NSUInteger page_outs = (NSUInteger)vm_stat.pageouts;
    
    return page_outs;
    
}

@end
