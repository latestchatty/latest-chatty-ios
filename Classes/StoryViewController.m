//
//    StoryViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/18/09.
//    Copyright 2009. All rights reserved.
//

#import "StoryViewController.h"
#import "LCBrowserType.h"

@implementation StoryViewController

@synthesize storyLoader, story, content;

- (id)initWithStoryId:(NSUInteger)aStoryId {
    self = [super initWithNib];
    
    storyId = aStoryId;
    self.title = @"Loading...";
    
    return self;
}

- (id)initWithStory:(Story *)aStory {
    self = [self initWithNib];
    
    self.story = aStory;
    self.title = aStory.title;
    
    return self;
}

- (id)initWithStateDictionary:(NSDictionary *)dictionary {
    return [self initWithStory:[dictionary objectForKey:@"story"]];
}

- (NSDictionary *)stateDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Story", @"type",
            story, @"story",
            nil];
}

- (void)didFinishLoadingModel:(id)model otherData:(id)otherData {
    [super didFinishLoadingModel:nil otherData:nil];
    
    self.story = model;
    self.storyLoader = nil;
    
    [self displayStory];
}

- (void)didFailToLoadModels {
    [super didFailToLoadModels];
    
    self.storyLoader = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[LatestChatty2AppDelegate delegate] isForceTouchEnabled]) {
        [content setAllowsLinkPreview:YES];
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Menu-Button-Thread.png"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(loadChatty)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Load story
    [super refresh:nil];
    self.storyLoader = [Story findById:storyId delegate:self];
    
    NSString *baseUrlString = [NSString stringWithFormat:@"http://shacknews.com/onearticle.x/%lu", (unsigned long)story.modelId];
    StringTemplate *htmlTemplate = [[StringTemplate alloc] initWithTemplateName:@"Story.html"];
    NSString *stylesheet = [NSString stringFromResource:@"Stylesheet.css"];
    [htmlTemplate setString:stylesheet forKey:@"stylesheet"];
    [htmlTemplate setString:@"" forKey:@"date"];
    [htmlTemplate setString:@"" forKey:@"storyId"];
    [htmlTemplate setString:@"" forKey:@"content"];
    [htmlTemplate setString:@"" forKey:@"storyTitle"];
    
    [content loadHTMLString:htmlTemplate.result baseURL:[NSURL URLWithString:baseUrlString]];
    
    // top separation bar
    UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
    
    // scroll indicator coloring
    [content.scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
}

- (UIViewController *)showingViewController {
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        return [LatestChatty2AppDelegate delegate].slideOutViewController;
    } else {
        return self;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark Actions

- (void)displayStory {
    self.title = story.title;
    
    // Load up web view content
    NSString *baseUrlString = [NSString stringWithFormat:@"http://shacknews.com/onearticle.x/%lu", (unsigned long)story.modelId];
    
    StringTemplate *htmlTemplate = [[StringTemplate alloc] initWithTemplateName:@"Story.html"];
    
    NSString *stylesheet = [NSString stringFromResource:@"Stylesheet.css"];
    [htmlTemplate setString:stylesheet forKey:@"stylesheet"];
    [htmlTemplate setString:[Story formatDate:story.date] forKey:@"date"];
    [htmlTemplate setString:[NSString stringWithFormat:@"%lu", (unsigned long)story.modelId] forKey:@"storyId"];
    [htmlTemplate setString:story.body forKey:@"content"];
    [htmlTemplate setString:story.title forKey:@"storyTitle"];
    
    [content loadHTMLString:htmlTemplate.result baseURL:[NSURL URLWithString:baseUrlString]];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)loadChatty {
    UIViewController *viewController;
    
    if (story.threadId > 0) {
        viewController = [[ThreadViewController alloc] initWithThreadId:story.threadId];
    } else {
        viewController = [ChattyViewController chattyControllerWithStoryId:story.modelId];
    }

    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        if (story.threadId > 0) {
            [[LatestChatty2AppDelegate delegate].contentNavigationController pushViewController:viewController animated:YES];
        } else {
            [[LatestChatty2AppDelegate delegate].navigationController pushViewController:viewController animated:YES];
        }
    } else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark WebView methods

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UIViewController *viewController = [appDelegate viewControllerForURL:[request URL]];
        
        // No special controller, handle the URL.
        // Check URL for YouTube, open externally is necessary.
        // If not YouTube, open URL in browser preference
        if (viewController == nil) {
            BOOL isYouTubeURL = [appDelegate isYouTubeURL:[request URL]];
            BOOL useYouTube = [[NSUserDefaults standardUserDefaults] boolForKey:@"useYouTube"];
            NSUInteger browserPref = [[NSUserDefaults standardUserDefaults] integerForKey:@"browserPref"];
            
            if (isYouTubeURL && useYouTube) {
                // don't open with browser preference, open YouTube app
                [[UIApplication sharedApplication] openURL:[[request URL] YouTubeURLByReplacingScheme]];
                return NO;
            }
            // open current URL in Safari app
            if (browserPref == LCBrowserTypeSafariApp) {
                [[UIApplication sharedApplication] openURL:[request URL]];
                return NO;
            }
            // open current URL in iOS 9 Safari modal view
            if (browserPref == LCBrowserTypeSafariView) {                
                SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:[request URL]];
                [svc setDelegate:self];
                [svc setPreferredBarTintColor:[UIColor lcBarTintColor]];
                [svc setPreferredControlTintColor:[UIColor whiteColor]];
                [svc setModalPresentationCapturesStatusBarAppearance:YES];
                
                [[self showingViewController] presentViewController:svc animated:YES completion:nil];
                
                return NO;
            }
            // open current URL in Chrome app
            if (browserPref == LCBrowserTypeChromeApp) {
                // replace http,https:// with googlechrome://
                NSURL *chromeURL = [appDelegate urlAsChromeScheme:[request URL]];
                if (chromeURL != nil) {
                    [[UIApplication sharedApplication] openURL:chromeURL];
                    
                    chromeURL = nil;
                    return NO;
                }
            }
            
            viewController = [[BrowserViewController alloc] initWithRequest:request];
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
        
        return NO;
    }
    
    return YES;
}

#pragma mark Cleanup

- (void)dealloc {
    [storyLoader cancel];
    
    [content stopLoading];
    content.delegate = nil;
}

@end
