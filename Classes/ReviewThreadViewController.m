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
    
//    NSLog(@"%@", rootPost.description);
//    NSLog(@"%@", rootPost.preview);
    [self placePostInWebView:self.rootPost];
}

- (IBAction)doneButton {
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

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"ReviewThreadViewController dealloc");
    self.rootPost = nil;
    
    [super dealloc];
}

@end