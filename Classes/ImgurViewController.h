//
//  BrowserViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/26/09.
//  Copyright 2009. All rights reserved.
//
#import <WebKit/WebKit.h>

@interface ImgurViewController : UIViewController <UIGestureRecognizerDelegate> {
    NSURLRequest *request;

    WKWebView *webView;
}

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) IBOutlet WKWebView *webView;

- (id)initWithRequest:(NSURLRequest *)request;
@end
