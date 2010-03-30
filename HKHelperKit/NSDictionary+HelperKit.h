//
//  NSDictionary+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 3/24/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (HelperKit)

- (BOOL)boolForKey:(NSString*)key;
- (NSInteger)integerForKey:(NSString*)key;
- (CGFloat)floatForKey:(NSString*)key;

@end
