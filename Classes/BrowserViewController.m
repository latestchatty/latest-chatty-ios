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
    
    if (self.isShackLOL) {
        if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
            UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu-Button-List.png"]
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self.viewDeckController
                                                                          action:@selector(toggleLeftView)];
            self.navigationItem.leftBarButtonItem = menuButton;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOLLoaded" object:self];
        
        UIBarButtonItem *lolMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                          style:UIBarButtonItemStyleDone
                                                                         target:self
                                                                         action:@selector(lolMenu)];
        [lolMenuButton setEnabled:NO];
        [lolMenuButton setTitleTextAttributes:[NSDictionary blueTextAttributesDictionary]
                                     forState:UIControlStateNormal];
        [lolMenuButton setTitleTextAttributes:[NSDictionary blueHighlightTextAttributesDictionary]
                                     forState:UIControlStateDisabled];
        
        self.navigationItem.rightBarButtonItem = lolMenuButton;
    }
    
    // initialize scoll position property
    self.scrollPosition = CGPointMake(0, 0);
    
    [webView loadRequest:request];
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        // Add pan gesture to detect velocity of panning webview to hide/show bars
        // only for iPhone
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.view addGestureRecognizer:panGesture];
        panGesture.delegate = self;
        panGesture.cancelsTouchesInView = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBars) name:@"ShowBrowserBars" object:nil];
        
        [self.webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, self.bottomToolbar.frameHeight, 0)];
        [self.webView.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    // iOS7
    self.navigationController.navigationBar.translucent = NO;
    
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
    } else {
        [self showBars];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // force webview to stop scrolling if it is when viewWillDisappear is fired
    for (id subview in webView.subviews){
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]){
            [subview setContentOffset:CGPointZero animated:NO];
        }
    }
}

// Hide the status bar and navigation bar with the built-in animation method
// Hiding the bottom bar with manual animation because setToolbarHidden:animated: on the navigation controller was acting strange
- (void)hideBars {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [UIView animateWithDuration:0.25 animations:^{
        CGRect bottomToolbarFrame = bottomToolbar.frame;
        bottomToolbarFrame.origin.y = self.view.frameHeight + bottomToolbar.frameHeight;
        bottomToolbar.frame = bottomToolbarFrame;
        
        CGRect topStrokeFrame = topStroke.frame;
        topStrokeFrame.origin.y = -1;
        topStroke.frame = topStrokeFrame;
    }];
    
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.webView.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

// Show the status bar and navigation bar with the built-in animation method
// Showing the bottom bar with manual animation because setToolbarHidden:animated: on the navigation controller was acting strange
- (void)showBars {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect bottomToolbarFrame = bottomToolbar.frame;
        bottomToolbarFrame.origin.y = self.view.frameHeight - bottomToolbar.frameHeight;
        bottomToolbar.frame = bottomToolbarFrame;
        
        CGRect topStrokeFrame = topStroke.frame;
        topStrokeFrame.origin.y = 0;
        topStroke.frame = topStrokeFrame;
    }];
    
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, self.bottomToolbar.frameHeight, 0)];
    [self.webView.scrollView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, self.bottomToolbar.frameHeight, 0)];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self.view];
    
    // only activate on first touch and a semi-flick velocity
    if (sender.state == UIGestureRecognizerStateBegan && ABS(velocity.y) > 300) {
        CGPoint translatedPoint = [sender translationInView:self.view];
        if (translatedPoint.y > 0 && self.navigationController.navigationBarHidden) {
            [self showBars];
        } else if (translatedPoint.y < 0 && !self.navigationController.navigationBarHidden) {
            [self hideBars];
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
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

//Patch-E: displays the custom iPhone menu on the Shack[LOL] site. Menu button is disabled until the web view finishes loading.
- (void)lolMenu {
    //switching to a javascript function called on the page rather than a page transfer
    //[self.webView loadURLString:@"http://lol.lmnopc.com/iphonemenu.php"];
    [self.webView stringByEvaluatingJavaScriptFromString: @"lc_menu();"];
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [viewController setNeedsStatusBarAppearanceUpdate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
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

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    theActionSheet = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0: [self copyURL]; break;
        case 1: [self openInSafari]; break;
        case 2: [self openInChrome]; break;
        default: break;
    }
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
