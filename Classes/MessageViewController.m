//
//  MessageViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/15/09.
//  Copyright 2009. All rights reserved.
//

#import "MessageViewController.h"
#import "SendMessageViewController.h"

@implementation MessageViewController

@synthesize message;

- (id)initWithMesage:(Message *)aMessage {
    self = [super initWithNib];
    self.message = aMessage;
    self.title = self.message.subject;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu-Button-Reply.png"]
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(reply)];
    self.navigationItem.rightBarButtonItem = replyButton;
    
    // Create HTML for the message
    StringTemplate *htmlTemplate = [StringTemplate templateWithName:@"Message.html"];
    
    NSString *stylesheet = [NSString stringFromResource:@"Stylesheet.css"];
    [htmlTemplate setString:stylesheet forKey:@"stylesheet"];
    [htmlTemplate setString:[Message formatDate:message.date] forKey:@"date"];
    [htmlTemplate setString:message.from forKey:@"author"];
    [htmlTemplate setString:message.body forKey:@"body"];
    
    [webView loadHTMLString:htmlTemplate.result baseURL:[NSURL URLWithString:@"http://www.shacknews.com/messages"]];
    
    // iOS7
    self.navigationController.navigationBar.translucent = NO;
    
    // top separation bar
    UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
    
    // scroll indicator coloring
    [webView.scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    // if this message is unread, decrement the message count if it's over 0
    if (self.message.unread) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSUInteger messageCount = [defaults integerForKey:@"messageCount"];
        if (messageCount > 0) {
            messageCount--;
            
            // save the updated message count to the db
            [defaults setInteger:messageCount forKey:@"messageCount"];
            // reflect the unread count on the app badge
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:messageCount];
            
//            NSLog(@"Message Count saved: %i", messageCount);            
        }
    }
}

- (void)showWebView:(NSTimer*)theTimer {
	[theTimer invalidate];
	webView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(showWebView:) userInfo:nil repeats:NO];
    
    //Patch-E: shack api returns straight text for messages, this at least turns any URL into a tappable link to open either
    //in the browser view controller or in whatever browser the user may have set in Settings
    NSString *jsReplaceLinkCode =
    @"document.getElementById('body').innerHTML = "
    @"document.getElementById('body').innerHTML.replace("
    @"/(\\b(https?):\\/\\/[-A-Z0-9+&@#\\/%?=~_|!:,.;]*[-A-Z0-9+&@#\\/%=~_|])/ig, "
    @"\"<a href='$1'>$1</a>\""
    @");";
    
    [aWebView stringByEvaluatingJavaScriptFromString:jsReplaceLinkCode];
}

- (void)reply {
    SendMessageViewController *sendMessageViewController = [[SendMessageViewController alloc] initWithMessage:message];
	[self.navigationController pushViewController:sendMessageViewController animated:YES];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UIViewController *viewController = [appDelegate viewControllerForURL:[request URL]];
        
        // No special controller, handle the URL.
        // Check URL for Youtube, open externally is necessary.
        // If not Youtube, check if URL should open in Safari/Chrome
        // Otherwise open URL in browser view controller web view.
        if (viewController == nil) {
            BOOL isYouTubeURL = [appDelegate isYoutubeURL:[request URL]];
            BOOL embedYoutube = [[NSUserDefaults standardUserDefaults] boolForKey:@"embedYoutube"];
            BOOL useSafari = [[NSUserDefaults standardUserDefaults] boolForKey:@"useSafari"];
            BOOL useChrome = [[NSUserDefaults standardUserDefaults] boolForKey:@"useChrome"];
            
            if (isYouTubeURL) {
                if (!embedYoutube) {
                    //don't embed, open Youtube URL on some external app that opens Youtube URLs
                    [[UIApplication sharedApplication] openURL:[request URL]];
                    return NO;
                }
            } else {
                //open current URL in Safari (not guaranteed to open in Safari, could be a iTunes/App Store URL that opens in an external app, most of the time the URL will get handled by Safari
                if (useSafari) {
                    [[UIApplication sharedApplication] openURL:[request URL]];
                    return NO;
                }
                //open current URL in Chrome
                if (useChrome) {
                    //replace http,https:// with googlechrome://
                    NSURL *chromeURL = [appDelegate urlAsChromeScheme:[request URL]];
                    if (chromeURL != nil) {
                        [[UIApplication sharedApplication] openURL:chromeURL];
                        
                        chromeURL = nil;
                        return NO;
                    }
                }
            }
            
            viewController = [[BrowserViewController alloc] initWithRequest:request];
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
