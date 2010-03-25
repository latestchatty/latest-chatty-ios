//
//  NSBundle+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 3/24/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "NSBundle+HelperKit.h"


@implementation NSBundle (HelperKit)

- (NSString*)pathForResource:(NSString*)name {
    return [self pathForResource:name ofType:nil];
}

- (NSURL*)urlForResource:(NSString *)name ofType:(NSString*)type {
    return [NSURL fileURLWithPath:[self pathForResource:name ofType:type]];
}

- (NSURL*)urlForResource:(NSString*)name {
    return [NSURL fileURLWithPath:[self pathForResource:name]];
}

@end
