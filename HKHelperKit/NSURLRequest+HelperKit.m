//
//  NSURLRequest+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 3/12/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "NSURLRequest+HelperKit.h"


@implementation NSURLRequest (HelperKit)

+ (id)requestWithURLString:(NSString*)urlString {
    return [self requestWithURL:[NSURL URLWithString:urlString]];
}

@end
