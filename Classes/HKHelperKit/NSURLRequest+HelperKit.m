//
//  NSURLRequest+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 3/12/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "NSURLRequest+HelperKit.h"
#import "NSString+HelperKit.h"


@implementation NSURLRequest (HelperKit)

@dynamic cachePolicy, mainDocumentURL, timeoutInterval;

+ (id)requestWithURLString:(NSString*)urlString {
    return [self requestWithURL:[NSURL URLWithString:urlString]];
}

- (NSString*)httpBody {
    return [NSString stringWithData:[self HTTPBody]];
}

- (NSString*)httpMethod {
    return [self HTTPMethod];
}

- (BOOL)shouldHandleCookies {
    return [self HTTPShouldHandleCookies];
}

- (NSURL*)url {
    return [self URL];
}


@end
