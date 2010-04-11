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
    self = [super initWithNib];
    self.request = _request;
    self.title = @"Browser";
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return YES;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc {
    self.request = nil;
    [webView loadHTMLString:@"<div></div>" baseURL:nil];
    if (webView.loading) {
        [webView stopLoading];
    }
    webView.delegate = nil;
    
    self.webView = nil;
    self.backButton = nil;
    self.forwardButton = nil;
    self.spinner = nil;
    
    [super dealloc];
}

- (IBAction)closeBrowser
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
