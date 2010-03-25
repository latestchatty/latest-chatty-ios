//
//  NSBundle+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 3/24/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSBundle (HelperKit)

- (NSString*)pathForResource:(NSString*)name;

- (NSURL*)urlForResource:(NSString *)name ofType:(NSString*)type;
- (NSURL*)urlForResource:(NSString*)name;


@end
