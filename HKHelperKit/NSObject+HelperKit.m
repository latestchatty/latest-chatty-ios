//
//  NSObject+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 3/25/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "NSObject+HelperKit.h"


@implementation NSObject (HelperKit)

- (BOOL)isEqualToAnyOf:objects, ... {
    // Add a button for each string after the first in the otherButtonTitles nil terminated list
    va_list args;
    va_start(args, objects);
    {
        NSObject *object = nil;
        while (object = va_arg(args, NSObject*)) {
            if ([self isEqual:object]) {
                return YES;
            }
        }
    }
    va_end(args);
    
    return NO;
}

@end
