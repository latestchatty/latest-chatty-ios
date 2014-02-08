//
//    ReviewThreadViewController.m
//    LatestChatty2
//
//    Created by Patrick Crager on 5/2/13.
//

#import "ReviewThreadViewController.h"

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

    [self placePostInWebView:self.rootPost];
    
    [doneButton setTitleTextAttributes:[NSDictionary blueTextAttributesDictionary] forState:UIControlStateNormal];
    
    // iOS7
    self.navigationController.navigationBar.translucent = NO;
    
    // top separation bar
    UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, postView.frameY, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
    
    // scroll indicator coloring
    [postView.scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
}

- (IBAction)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [htmlTemplate setString:[NSString rgbaFromUIColor:[Post colorForPostExpiration:post.date withCategory:post.category]] forKey:@"expirationColor"];
    [htmlTemplate setString:[NSString stringWithFormat:@"%f%%", [Post sizeForPostExpiration:post.date]] forKey:@"expirationSize"];

    [htmlTemplate setString:post.body forKey:@"body"];
    [postView loadHTMLString:htmlTemplate.result baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.shacknews.com/chatty?id=%lu", (unsigned long)post.modelId]]];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [postView.scrollView setContentInset:UIEdgeInsetsMake(64.0, 0, 0, 0)];
    } else {
        [postView.scrollView setContentInset:UIEdgeInsetsMake(52.0, 0, 0, 0)];
    }
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
