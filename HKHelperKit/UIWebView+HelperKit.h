//
//  UIWebView+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 3/25/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIWebView (HelperKit)

- (void)loadURL:(NSURL*)url;
- (void)loadURLString:(NSString*)urlString;

@end
