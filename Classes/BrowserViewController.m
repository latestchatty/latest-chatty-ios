//
//  BrowserViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/26/09.
//  Copyright 2009. All rights reserved.
//

#import "BrowserViewController.h"

#import "GoogleChromeActivity.h"
#import "AppleSafariActivity.h"

@implementation BrowserViewController

@synthesize request, webView, backButton, forwardButton, actionButton, bottomToolbar, isShackLOL;

- (id)initWithRequest:(NSURLRequest*)_request {
    self = [super initWithNib];
    self.request = _request;
    self.title = @"Loading...";
    return self;
}

- (id)initWithRequest:(NSURLRequest*)_request
                title:(NSString*)title
        isForShackLOL:(BOOL)isForShackLOL {
    self = [super initWithNib];
    self.request = _request;
    if (title) {
        self.title = title;
        initWithTitle = YES;
    } else {
        self.title = @"Loading...";
    }
    self.isShackLOL = isForShackLOL;
 
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initialize scoll position property
    self.scrollPosition = CGPointMake(0, 0);
    
    [webView loadRequest:request];
    
    // top separation bar
     topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.scrollPosition.y > 0) {
        [webView.scrollView setContentOffset:self.scrollPosition animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        if ([popoverController isPopoverVisible]) {
            [popoverController dismissPopoverAnimated:NO];
        }
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // force webview to stop scrolling if it is when viewWillDisappear is fired
    for (id subview in webView.subviews){
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]){
            [subview setContentOffset:CGPointZero animated:NO];
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    backButton.enabled = webView.canGoBack;
    forwardButton.enabled = webView.canGoForward;

    if (self.navigationItem.rightBarButtonItem != nil && isShackLOL) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    
    [self.actionButton setEnabled:YES];
    
    NSString *docTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (!initWithTitle) {
        if (docTitle.length > 0) {
            self.title = docTitle;
        } else {
            self.title = @"Browser";
        }
    }
}

- (void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error {
    [self webViewDidFinishLoad:_webView];
}

- (IBAction)refreshWebView:(id)sender {
    [self.webView reload];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UIViewController *viewController = [appDelegate viewControllerForURL:[aRequest URL]];
        
        // No special controller, handle the URL.
        if (viewController == nil) {
            return YES;
        }
        
        // save scroll position of web view before pushing view controller
        self.scrollPosition = webView.scrollView.contentOffset;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    [viewController setNeedsStatusBarAppearanceUpdate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

#pragma mark UIActivityViewController & Action Sheet Delegate

- (IBAction)action:(id)sender {
    //load custom activities
    AppleSafariActivity *safariActivity = [[AppleSafariActivity alloc] init];
    GoogleChromeActivity *chromeActivity = [[GoogleChromeActivity alloc] init];
    
    NSArray *activityItems = @[[webView.request URL]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:activityItems
                                                        applicationActivities:@[safariActivity, chromeActivity]];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
    
    //present as popover on iPad, as a regular view on iPhone
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        //hide popover if its already showing and the button is pressed again
        if ([popoverController isPopoverVisible]) {
            [popoverController dismissPopoverAnimated:YES];
        } else {
            popoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    } else {
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController*)pc {
    if (popoverController == pc) {
        popoverController = nil;
    }
}

- (void)copyURL {
    [[UIPasteboard generalPasteboard] setString:[[webView.request URL] absoluteString]];
}

- (void)openInSafari {
    [[UIApplication sharedApplication] openURL:[webView.request URL]];
}

- (void)openInChrome {
    LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSURL *chromeURL = [appDelegate urlAsChromeScheme:[webView.request URL]];
    [[UIApplication sharedApplication] openURL:chromeURL];
    chromeURL = nil;
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [webView loadHTMLString:@"" baseURL:nil];
    [webView setDelegate:nil];
    [webView stopLoading];
}

@end
