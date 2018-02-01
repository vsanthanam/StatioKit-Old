//
//  NSBundle+StatioKit.m
//  StatioKit
//
//  Created by Varun Santhanam on 1/14/18.
//  Copyright © 2018 Varun Santhanam. All rights reserved.
//

#import "NSBundle+StatioKit.h"

@implementation NSBundle (StatioKit)

+ (instancetype)statioKitResources {
    
    NSString *pathForBundle = [[NSBundle mainBundle] pathForResource:@"StatioKit" ofType:@"bundle"];
    
    return [NSBundle bundleWithPath:pathForBundle];
    
}

@end
