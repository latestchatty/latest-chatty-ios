//
//    BrowserViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/26/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"
#import "LatestChatty2AppDelegate.h"

@implementation BrowserViewController

@synthesize request;
@synthesize webView, backButton, forwardButton, spinner, mainToolbar;

- (id)initWithRequest:(NSURLRequest*)_request {
    self = [super initWithNib];
    self.request = _request;
    self.title = @"Browser";
    return self;
}

//Patch-E: new constructor to support Shack[LOL]-tergration. Overrides the title and if the web view is to point to the Shack[LOL] site, a menu button is created that fires the lolMenu selector.
- (id)initWithRequest:(NSURLRequest*)_request title:(NSString*)title isShackLOL:(BOOL)isShackLOL {
    self = [super initWithNib];
    self.request = _request;
    self.title = title;
    
    if (isShackLOL) {
        UIBarButtonItem *lolMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(lolMenu)];
        [self.navigationItem setRightBarButtonItem:lolMenuButton];
        
        [lolMenuButton release];        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        self.spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    }
    
    if (mainToolbar) {
        UIBarButtonItem *spinnerItem = [[[UIBarButtonItem alloc] initWithCustomView:spinner] autorelease];
        NSMutableArray *items = [NSMutableArray arrayWithArray:mainToolbar.items];
        [items insertObject:spinnerItem atIndex:[items count]-1];
        mainToolbar.items = items;        
    }
    
    [webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[LatestChatty2AppDelegate delegate] isPadDevice] && self.navigationController) {
        mainToolbar.tintColor = self.navigationController.navigationBar.tintColor;
        self.navigationItem.titleView = self.mainToolbar;
        webView.frame = self.view.bounds;
    }
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

//Patch-E: launches the custom iPhone menu on the Shack[LOL] site.
- (void)lolMenu {
    [self.webView loadURLString:@"http://lol.lmnopc.com/iphonemenu.php"];
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
    self.mainToolbar = nil;
    [super dealloc];
}

- (IBAction)closeBrowser {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
