//
//  BrowserViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/26/09.
//  Copyright 2009. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "ImgurViewController.h"

#import "GoogleChromeActivity.h"
#import "AppleSafariActivity.h"

@implementation ImgurViewController

@synthesize request, webView;

- (id)initWithRequest:(NSURLRequest*)_request {
    self = [super initWithNib];
    self.request = _request;
    self.title = @"Imgur Viewer";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *html = [[NSString alloc] initWithFormat:@"<html><body style=\"background:black;\"><img src=\"%@\"/></body></html>", request.URL.absoluteString];
    [webView loadHTMLString:html baseURL:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error {
    [self webViewDidFinishLoad:_webView];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    [viewController setNeedsStatusBarAppearanceUpdate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [webView loadHTMLString:@"" baseURL:nil];
    //[webView setDelegate:nil];
    [webView stopLoading];
}

@end
