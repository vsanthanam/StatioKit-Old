//
//  sk_log.h
//  StatioKit
//
//  Created by Varun Santhanam on 3/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#ifndef sk_log_h
#define sk_log_h

#include <stdio.h>

#endif /* sk_log_h */

#import <os/log.h>

os_log_t sk_log(void);

os_log_t sk_log_create(const char * category);
