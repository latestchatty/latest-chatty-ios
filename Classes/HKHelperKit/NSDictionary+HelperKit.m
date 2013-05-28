//
//  NSDictionary+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 3/24/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "NSDictionary+HelperKit.h"


@implementation NSDictionary (HelperKit)

- (BOOL)boolForKey:(NSString*)key {
    return [[self objectForKey:key] boolValue];
}

- (NSInteger)integerForKey:(NSString*)key {
    return [[self objectForKey:key] intValue];
}

- (CGFloat)floatForKey:(NSString*)key {
    return [[self objectForKey:key] floatValue];
}

@end
