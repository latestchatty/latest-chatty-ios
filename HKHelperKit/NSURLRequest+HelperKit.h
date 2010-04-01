//
//  NSURLRequest+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 3/12/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURLRequest (HelperKit)

+ (id)requestWithURLString:(NSString*)urlString;

@property (nonatomic, readonly) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, readonly) NSString *httpBody;
@property (nonatomic, readonly) NSString *httpMethod;
@property (nonatomic, readonly) BOOL shouldHandleCookies;
@property (nonatomic, readonly) NSURL *mainDocumentURL;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSTimeInterval timeoutInterval;

@end
