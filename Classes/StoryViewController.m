//
//    StoryViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/18/09.
//    Copyright 2009. All rights reserved.
//

#import "StoryViewController.h"

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
//    self.title = aStory.title;
    self.title = @"Story";
    
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
    self.story = model;
    self.storyLoader = nil;
    
    [self displayStory];
}

- (void)didFailToLoadModels {
    self.storyLoader = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Menu-Button-Thread.png"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(loadChatty)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Load story
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
    
    // iOS7
    self.navigationController.navigationBar.translucent = NO;
    
    // top separation bar
    UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
    
    // scroll indicator coloring
    [content.scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark Actions

- (void)displayStory {
    self.title = @"Story";
    
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

#pragma mark Web view methods

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

#pragma mark Cleanup

- (void)dealloc {
    [storyLoader cancel];
    
    [content stopLoading];
    content.delegate = nil;
}

@end
