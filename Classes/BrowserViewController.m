//
//    BrowserViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/26/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"

@implementation BrowserViewController

@synthesize request;
@synthesize webView, backButton, forwardButton, spinner;

- (id)initWithRequest:(NSURLRequest*)_request {
    if (self = [super initWithNibName:@"BrowserViewController" bundle:nil]) {
        self.request = _request;
        self.title = @"Browser";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [spinner stopAnimating];
    backButton.enabled = webView.canGoBack;
    forwardButton.enabled = webView.canGoForward;
}

- (void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error {
    [self webViewDidFinishLoad:webView];
}

- (IBAction)safari {
    [[UIApplication sharedApplication] openURL:[webView.request URL]];
}

- (void)viewDidUnload {
	self.webView = nil;
    self.backButton = nil;
    self.forwardButton = nil;
    self.spinner = nil;
}


- (void)dealloc {
    self.request = nil;
    [super dealloc];
}


@end
