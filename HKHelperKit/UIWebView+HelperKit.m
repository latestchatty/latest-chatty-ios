//
//  UIWebView+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 3/25/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UIWebView+HelperKit.h"


@implementation UIWebView (HelperKit)

- (void)loadURL:(NSURL*)url {
    [self loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)loadURLString:(NSString*)urlString {
    [self loadURL:[NSURL URLWithString:urlString]];
}

@end
