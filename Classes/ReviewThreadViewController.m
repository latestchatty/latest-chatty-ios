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
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) return UIInterfaceOrientationMaskAll;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeLeft;
}

-(BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return YES;
    return NO;
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"ReviewThreadViewController dealloc");
    self.rootPost = nil;
    
    [doneButton release];
    [super dealloc];
}

@end
