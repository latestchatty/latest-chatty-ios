//
//    ReviewThreadViewController.m
//    LatestChatty2
//
//    Created by Patrick Crager on 5/2/13.
//

#import "ReviewThreadViewController.h"
#include "LatestChatty2AppDelegate.h"

@implementation ReviewThreadViewController

@synthesize rootPost;

- (id)initWithPost:(Post *)aPost {
    self = [super initWithNib];
    
    self.title = @"Review";
    self.rootPost = aPost;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],UITextAttributeTextColor,
                                [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5],UITextAttributeTextShadowColor,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                UITextAttributeTextShadowOffset,
                                nil];
    [doneButton setTitleTextAttributes:attributes forState:UIControlStateNormal];

    [self placePostInWebView:self.rootPost];
}

- (IBAction)dismiss {
	[self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PostContentBecomeFirstResponder" object:nil];
}

- (void)placePostInWebView:(Post *)post {
    // Create HTML for the post
    StringTemplate *htmlTemplate = [StringTemplate templateWithName:@"ReviewPost.html"];

    NSString *stylesheet = [NSString stringFromResource:@"Stylesheet.css"];
    [htmlTemplate setString:stylesheet forKey:@"stylesheet"];
    [htmlTemplate setString:[Post formatDate:post.date] forKey:@"date"];
    [htmlTemplate setString:post.author forKey:@"author"];

    //set the expiration stripe's background color and size in the HTML template
    [htmlTemplate setString:[NSString rgbaFromUIColor:[Post colorForPostExpiration:post.date]] forKey:@"expirationColor"];
    [htmlTemplate setString:[NSString stringWithFormat:@"%f%%", [Post sizeForPostExpiration:post.date]] forKey:@"expirationSize"];

    [htmlTemplate setString:post.body forKey:@"body"];
    [postView loadHTMLString:htmlTemplate.result baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.shacknews.com/chatty?id=%i", post.modelId]]];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    // allow landscape setting on
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) {
        if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
            // iPad can rotate to any interface
            return UIInterfaceOrientationMaskAll;
        } else {
            // iPhone can rotate to any interface except portrait upside down
            return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
        }
    } else {
        if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
            // iPad can rotate to any portrait interface
            return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
        } else {
            // iPhone can rotate to only regular portrait
            return UIInterfaceOrientationMaskPortrait;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // never allow portrait upside down for iPhone
    if (![[LatestChatty2AppDelegate delegate] isPadDevice] && interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    }
    
    // allow landscape setting is on, allow rotation
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) {
        return YES;
    } else {
        // allow landscape setting is off, allow rotation if the orientation isn't landscape
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation))return NO;
        return YES;
    }
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"ReviewThreadViewController dealloc");
    self.rootPost = nil;
    
    [doneButton release];
    [super dealloc];
}

@end
