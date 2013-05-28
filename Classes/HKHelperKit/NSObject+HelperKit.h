//
//  NSObject+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 3/25/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (HelperKit)

// Tests for equality among a nil terminated list of objects using the isEqual: method.
// Example:
//
//   [@"foobar" isEqualToAnyOf:@"a", @"b", @"c", @"foo", @"d", nil];
//
- (BOOL)isEqualToAnyOf:objects, ...;

@end
