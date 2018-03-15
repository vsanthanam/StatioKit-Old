//
//  sk_log.c
//  StatioKit
//
//  Created by Varun Santhanam on 3/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#include "sk_log.h"

#define sk_log_subsystem "com.varunsanthanam.StatioKit"

os_log_t sk_log(void) {
    
    return sk_log_create("StatioKit");
    
}

os_log_t sk_log_create(const char * category) {
    
    return os_log_create(sk_log_subsystem, category);
    
}
