//
//    LatestChatty2AppDelegate.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/16/09.
//    Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "StringTemplate.h"
#import "Mod.h"
#import "NoContentController.h"
#import "IIViewDeckController.h"

@implementation LatestChatty2AppDelegate

@synthesize window,
            navigationController,
            contentNavigationController,
            slideOutViewController;

+ (LatestChatty2AppDelegate*)delegate {
    return (LatestChatty2AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)setupInterfaceForPhoneWithOptions:(NSDictionary *)launchOptions {
//    if (![self reloadSavedState]) {
//        // Add the root view controller
//        RootViewController *viewController = [RootViewController controllerWithNib];
//        [navigationController pushViewController:viewController animated:NO];
//    }
////    if ([[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"message_id"]) {
////        // Tapped a messge push's view button
////        MessagesViewController *viewController = [MessagesViewController controllerWithNib];
////        [navigationController pushViewController:viewController animated:NO];
////    }
    
//    // Style the navigation bar
//    navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

//    // Configure and show the window
//    window.backgroundColor = [UIColor blackColor];
//    window.rootViewController = navigationController;
    
    // Create and assign the left and center controllers
    IIViewDeckController* deckController = [self generateControllerStack];
    self.leftController = deckController.leftController;
    self.centerController = deckController.centerController;
    
    self.window.rootViewController = deckController;
}

- (void)setupInterfaceForPadWithOptions:(NSDictionary *)launchOptions {
    self.contentNavigationController = [UINavigationController controllerWithRootController:[NoContentController controllerWithNib]];
    contentNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    contentNavigationController.navigationBar.tintColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    navigationController.navigationBar.tintColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    
    if (![self reloadSavedState]) {
        // Add the root view controller
        [navigationController pushViewController:[RootViewController controllerWithNib] animated:NO];
    }
    
//    if ([[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"message_id"]) {
//        // Tapped a messge push's view button
//        MessagesViewController *viewController = [MessagesViewController controllerWithNib];
//        [navigationController pushViewController:viewController animated:NO];
//    }
    
    self.slideOutViewController =  [SlideOutViewController controllerWithNib];
    [slideOutViewController addNavigationController:navigationController contentNavigationController:contentNavigationController];
    [slideOutViewController.view setFrame:CGRectMake(0, 20, 768, 1004)];
    
    self.window.rootViewController = slideOutViewController;
}

- (IIViewDeckController*)generateControllerStack {
    // Left controller
    RootViewController* leftController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    // Center controller
    ChattyViewController *centerController = [[ChattyViewController alloc] initWithNibName:@"ChattyViewController" bundle:nil];
    [centerController setTitle:@"Loading..."];
    
    // Initialize the navigation controller with the center (chatty) controller
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:centerController];
    
    // Create the deck controller with the left and center
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.navigationController
                                                                                    leftViewController:leftController];
    // Set navigation type, left size, no elasticity
    [deckController setNavigationControllerBehavior:IIViewDeckNavigationControllerIntegrated];
    [deckController setLeftSize:255.0f];
    [deckController setElastic:NO];
    [deckController setPanningMode:IIViewDeckFullViewPanning];
    [deckController setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose];
    [deckController setCenterViewCornerRadius:7.0f];
    
    return deckController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customizeAppearance];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *lastSaveDate = [defaults objectForKey:@"savedStateDate"];
    
//    // Register for Push
//    if ([defaults boolForKey:@"push.messages"]) {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
//    }
    
    // If forget history is on or it's been 8 hours since the last opening, then we don't care about the saved state.
    if ([defaults boolForKey:@"forgetHistory"] || [lastSaveDate timeIntervalSinceNow] < -8*60*60) {
        [defaults removeObjectForKey:@"savedState"];
    }        

    // Settings defaults
    NSDictionary *defaultSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"",                           @"username",
                                     @"",                           @"password",
                                     @"shackapi.stonedonkey.com",   @"server",
                                     [NSNumber numberWithBool:YES], @"landscape",
                                     [NSNumber numberWithBool:YES], @"embedYoutube",
                                     //[NSNumber numberWithBool:NO],  @"push.messages",
                                     [NSNumber numberWithBool:YES], @"picsResize",
                                     [NSNumber numberWithFloat:0.7],@"picsQuality",
                                     [NSNumber numberWithBool:YES], @"embedYoutube",
                                     [NSNumber numberWithBool:NO],  @"useSafari",
                                     [NSNumber numberWithBool:NO],  @"useChrome",
                                     [NSNumber numberWithBool:YES], @"postCategory.informative",
                                     [NSNumber numberWithBool:YES], @"postCategory.offtopic",
                                     [NSNumber numberWithBool:YES], @"postCategory.stupid",
                                     [NSNumber numberWithBool:YES], @"postCategory.political",
                                     [NSNumber numberWithBool:NO],  @"postCategory.nws",
                                     [NSNumber numberWithInt:0],    @"lastRefresh",
                                     [NSNumber numberWithInt:1],    @"grippyBarPosition",
                                     [NSNumber numberWithBool:NO],  @"orderByPostDate",
                                     [NSMutableArray array],        @"pinnedPosts",
                                     nil];
    [defaults registerDefaults:defaultSettings];

    if ([self isPadDevice]) {
        [self setupInterfaceForPadWithOptions:launchOptions];
    } else {
        [self setupInterfaceForPhoneWithOptions:launchOptions];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [window makeKeyAndVisible];
    
    // Modified requestBody and request URL for May 2013 Shacknews login changes
    if([defaults boolForKey:@"modTools"]==YES){
        //Mods need cookies
        NSString *usernameString = [[defaults stringForKey:@"username"] stringByEscapingURL];
        NSString *passwordString = [[defaults stringForKey:@"password"] stringByEscapingURL];
        //NSString *requestBody = [NSString stringWithFormat:@"email=%@&password=%@&login=login", usernameString, passwordString];
        NSString *requestBody = [NSString stringWithFormat:@"get_fields%%5B%%5D=result&user-identifier=%@&supplied-pass=%@&remember-login=1", usernameString, passwordString];        
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];

        //[request setURL:[NSURL URLWithString:@"http://www.shacknews.com"]];
        [request setURL:[NSURL URLWithString:@"https://www.shacknews.com/account/signin"]];
        [request setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [NSURLConnection connectionWithRequest:request delegate:nil];
        
        // Use for testing login above and to output current cookies for www.shacknews.com
//        NSString *responseBody = [NSString stringWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]];
//        NSLog(@"%@", responseBody);
//        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"https://www.shacknews.com"]];
//        for (int i=0;i<cookies.count;i++) {
//            NSHTTPCookie *cookie = cookies[i];
//            NSLog(@"%@", cookie.description);
//        }
    }
    return YES;
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    if ([userInfo objectForKey:@"message_id"]) {
//        [UIAlertView showWithTitle:@"Incoming Message"
//                           message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
//                          delegate:self
//                 cancelButtonTitle:@"Dismiss"
//                 otherButtonTitles:@"View", nil];
//    }
//}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        MessagesViewController *viewController = [[MessagesViewController alloc] init];
//        [navigationController pushViewController:viewController animated:YES];
//        [viewController release];
//    }
//}

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
//    [request setURL:[NSURL URLWithString:[[Model class] urlStringWithPath:@"/devices"]]];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *pushToken = [[deviceToken description] stringByReplacingOccurrencesOfRegex:@"<|>" withString:@""];
//    NSString *usernameString = [[defaults stringForKey:@"username"] stringByEscapingURL];
//    NSString *passwordString = [[defaults stringForKey:@"password"] stringByEscapingURL];
//    NSString *requestBody = [NSString stringWithFormat:@"token=%@&username=%@&password=%@", pushToken, usernameString, passwordString];
//    [request setHTTPBody:[requestBody dataUsingEncoding:NSASCIIStringEncoding]];
//    [request setHTTPMethod:@"POST"];
//
//    [NSURLConnection connectionWithRequest:request delegate:nil];
//}
//
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"Error in registration. Error: %@", error);
//}


- (NSURLCredential *)userCredential {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    return [NSURLCredential credentialWithUser:[defaults objectForKey:@"username"]
                                      password:[defaults objectForKey:@"password"]
                                   persistence:NSURLCredentialPersistenceNone];
}

// Check the "Embed YouTube" user setting, if embedding is turned off open YouTube URL in either the YouTube app (if installed, either the Apple created pre-iOS 6 app or Google created app) or Safari if a YouTube app isn't installed. If embedding turned on, open YouTube URL in web view.
- (BOOL)isYoutubeURL:(NSURL *)url {
    if ([[url host] containsString:@"youtube.com"] || [[url host] containsString:@"youtu.be"]) {
        return YES;
    }
    return NO;
}

// If user has URLs set to open in Chrome, check to see if the app can open Chrome. If it can, construct the URL on the googlechrome:// URL scheme and return it.
- (id)urlAsChromeScheme:(NSURL *)url {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]]) {
        NSString *absoluteURLString = [url absoluteString];
        NSRange rangeForScheme = [absoluteURLString rangeOfString:@":"];
        NSString *urlWithNoScheme =  [absoluteURLString substringFromIndex:rangeForScheme.location];
        NSString *chromeURLString = [@"googlechrome" stringByAppendingString:urlWithNoScheme];
        NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
        
        absoluteURLString = nil;
        urlWithNoScheme = nil;
        chromeURLString = nil;
        
        return chromeURL;
    }
    return nil;
}

- (id)viewControllerForURL:(NSURL *)url {
    NSString *uri = [url absoluteString];
    UIViewController *viewController = nil;
    
    if ([uri isMatchedByRegex:@"shacknews\\.com/laryn\\.x\\?id=\\d+"]) {
        NSUInteger targetThreadId = [[uri stringByMatching:@"shacknews\\.com/laryn\\.x\\?id=(\\d+)" capture:1] intValue];
        viewController = [[[ThreadViewController alloc] initWithThreadId:targetThreadId] autorelease];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/laryn\\.x\\?story=\\d+"]) {
        NSUInteger targetStoryId = [[uri stringByMatching:@"shacknews\\.com/laryn\\.x\\?story=(\\d+)" capture:1] intValue];
        viewController = [[[ChattyViewController alloc] initWithStoryId:targetStoryId] autorelease];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/profile/.*"]) {
        NSString *profileName = [[uri stringByMatching:@"shacknews\\.com/profile/(.*)" capture:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        viewController = [[[SearchResultsViewController alloc] initWithTerms:@"" author:profileName parentAuthor:@""] autorelease];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/chatty\\?id=\\d+"]) {
        NSUInteger targetThreadId = [[uri stringByMatching:@"shacknews\\.com/chatty\\?id=(\\d+)" capture:1] intValue];
        viewController = [[[ThreadViewController alloc] initWithThreadId:targetThreadId] autorelease];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/chatty\\?story=\\d+"]) {
        NSUInteger targetStoryId = [[uri stringByMatching:@"shacknews\\.com/chatty\\?story=(\\d+)" capture:1] intValue];
        viewController = [[[ChattyViewController alloc] initWithStoryId:targetStoryId] autorelease];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/onearticle.x/\\d+"]) {
        NSUInteger targetStoryId = [[uri stringByMatching:@"shacknews\\.com/onearticle.x/(\\d+)" capture:1] intValue];
        viewController = [[[StoryViewController alloc] initWithStoryId:targetStoryId] autorelease];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/article/\\d+"]) {
        NSUInteger targetStoryId = [[uri stringByMatching:@"shacknews\\.com/article/(\\d+)" capture:1] intValue];
        viewController = [[[StoryViewController alloc] initWithStoryId:targetStoryId] autorelease];
    }

    return viewController;
}

- (BOOL)reloadSavedState {
    @try {
        // Find saved state
        NSData *savedState = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedState"];
        
        if (savedState) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedState"];
            NSArray *controllerDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:savedState];
            
            // Create a dictionary to convert controller type strings to class objects
            NSMutableDictionary *controllerClassLookup = [NSMutableDictionary dictionary];
            [controllerClassLookup setObject:[RootViewController class]        forKey:@"Root"];
            [controllerClassLookup setObject:[StoriesViewController class] forKey:@"Stories"];
            [controllerClassLookup setObject:[StoryViewController class]     forKey:@"Story"];
            [controllerClassLookup setObject:[ChattyViewController class]    forKey:@"Chatty"];
            [controllerClassLookup setObject:[ThreadViewController class]    forKey:@"Thread"];
            [controllerClassLookup setObject:[BrowserViewController class] forKey:@"Browser"];
            
            for (NSDictionary *dictionary in controllerDictionaries) {
                // find the right controller class
                NSString *controllerName = [dictionary objectForKey:@"type"];
                Class class = [controllerClassLookup objectForKey:controllerName];
                
                if (class) {
                    id viewController = [[class alloc] initWithStateDictionary:dictionary];
                    [navigationController pushViewController:viewController animated:NO];
                    [viewController release];
                } else {
                    NSLog(@"No known view controller for the type: %@", controllerName);
                    return NO;
                }
            }
        } else {
            return NO;
        }
        
    }
    @catch (NSException *e) {
        // Something went wrong restoring state, so just start over.
        navigationController.viewControllers = nil;
        return NO;
    }
    
    return YES;
}

- (BOOL)isPadDevice {
    return CGRectGetMaxX([[UIScreen mainScreen] bounds]) > 480;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSMutableArray *savedControllers = [NSMutableArray array];
    for (id viewController in [navigationController viewControllers]) {
        BOOL hasState = [viewController respondsToSelector:@selector(stateDictionary)];
        BOOL hasLoading = [viewController respondsToSelector:@selector(loading)];
        BOOL isDoneLoading = hasLoading && ![viewController loading];
        
        if (hasState && (isDoneLoading || !hasLoading))
            [savedControllers addObject:[viewController stateDictionary]];
    }
    
    NSData *state = [NSKeyedArchiver archivedDataWithRootObject:savedControllers];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:state forKey:@"savedState"];
    [defaults setObject:[NSDate date] forKey:@"savedStateDate"];
    [defaults synchronize];
    
    //'logout' essentially
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* shackCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://www.shacknews.com"]];
    for (NSHTTPCookie* cookie in shackCookies) {
        NSLog(@"Name: %@ : Value: %@", cookie.name, cookie.value);
        [cookies deleteCookie:cookie];
    }
}

// Handle the registered latestchatty:// URL scheme
// Uses the existing AppDelegate method viewControllerForURL to determine what kind of ViewController to instantiate and push onto the appropriate navigation controller stack.
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"Passed in URL: %@", url);
    if (!url) {
        return NO;
    }
    
    NSLog(@"Loading passed in URL.");
    UIViewController *viewController = [self viewControllerForURL:url];
    
    if (viewController == nil) {
        NSLog(@"URL passed in did not match any handlers.");
        return NO;
    }
    
    if ([self isPadDevice]) {
        [self.contentNavigationController pushViewController:viewController animated:YES];
    } else {
        [self.navigationController dismissModalViewControllerAnimated:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    return YES;
}

#pragma mark - Customizations

// Custom appearance settings for UIKit items
- (void)customizeAppearance {
    // Set a corner radius around the whole app window
    [self.window.layer setCornerRadius:7.0f];
    [self.window.layer setMasksToBounds:YES];
    
    // Same navbar/toolbar background image for all orientations    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage toolbarBgImage]
                                           forBarMetrics:UIBarMetricsDefault];
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage navbarBgImage]
                                           forBarMetrics:UIBarMetricsDefault];
    }
    [[UIToolbar appearance] setBackgroundImage:[UIImage toolbarBgImage]
                            forToolbarPosition:UIToolbarPositionAny
                                    barMetrics:UIBarMetricsDefault];
    
    // Left button (back arrow) normal and highlight states
    // Portrait back button states
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage backButtonImage]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage backButtonHighlightImage]
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsDefault];
    // Landscape highlight back button states
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage backButtonLandscapeImage]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsLandscapePhone];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage backButtonHighlightLandscapeImage]
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsLandscapePhone];
    
    // Load all images for normal, highlight, and done style buttons along with their landscape counterparts    
    // iOS 6 allows usage of appearance proxy to customize done and normal buttons independently
    // downside to the following is that iOS 5 will not have blue color done style buttons, do we care?
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        // Normal button state with landscape
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage barButtonNormalImage]
                                                                                            forState:UIControlStateNormal
                                                                                               style:UIBarButtonItemStyleBordered
                                                                                          barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage barButtonNormalLandscapeImage]
                                                                                            forState:UIControlStateNormal
                                                                                               style:UIBarButtonItemStyleBordered
                                                                                          barMetrics:UIBarMetricsLandscapePhone];
        // Highlight normal button state with landscape
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage barButtonNormalHighlightImage]
                                                                                            forState:UIControlStateHighlighted
                                                                                               style:UIBarButtonItemStyleBordered
                                                                                          barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage barButtonNormalHighlightLandscapeImage]
                                                                                            forState:UIControlStateHighlighted
                                                                                               style:UIBarButtonItemStyleBordered
                                                                                          barMetrics:UIBarMetricsLandscapePhone];
        // Done button style (blue) with landscape
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage barButtonDoneImage]
                                                forState:UIControlStateNormal
                                                   style:UIBarButtonItemStyleDone
                                              barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage barButtonDoneLandscapeImage]
                                                forState:UIControlStateNormal
                                                   style:UIBarButtonItemStyleDone
                                              barMetrics:UIBarMetricsLandscapePhone];
    } else { // iOS 5
        // Normal button state with landscape
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage barButtonNormalImage]
                                                                                            forState:UIControlStateNormal
                                                                                          barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage barButtonNormalLandscapeImage]
                                                                                            forState:UIControlStateNormal
                                                                                          barMetrics:UIBarMetricsLandscapePhone];
        // Highlight normal button state with landscape        
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage barButtonNormalHighlightImage]
                                                                                            forState:UIControlStateHighlighted
                                                                                          barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:[UIImage barButtonNormalHighlightLandscapeImage]
                                                                                            forState:UIControlStateHighlighted
                                                                                          barMetrics:UIBarMetricsLandscapePhone];
    }
    
    // Give the navigation bar title text text shadowing
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary whiteTextAttributesDictionary]];
    
    // Give text in buttons gray coloring with text shadowing
    // Done style buttons will get styled here, but it gets overridden in the view controller for any view that uses Done style buttons
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary grayTextAttributesDictionary]
                                                forState:UIControlStateNormal];
    
    // iOS 6 allows more built-in customization of switch/slider than iOS 5
    // They won't look the same without subclassing UISwitch, do we care?
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        [[UISwitch appearance] setTintColor:[UIColor lcSwitchOffColor]];
        [[UISlider appearance] setThumbTintColor:[UIColor lcSliderThumbColor]];
    }
    [[UISwitch appearance] setOnTintColor:[UIColor lcSwitchOnColor]];
    [[UISlider appearance] setMinimumTrackTintColor:[UIColor lcSwitchOnColor]];
    [[UISlider appearance] setMaximumTrackTintColor:[UIColor lcSliderThumbColor]];
    [[UIProgressView appearance] setProgressTintColor:[UIColor lcSwitchOnColor]];
    [[UIProgressView appearance] setTrackTintColor:[UIColor lcSliderThumbColor]];
}

#pragma Rotation

+ (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

+ (NSUInteger)supportedInterfaceOrientations {
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

+ (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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

- (void)dealloc {
    self.navigationController = nil;
    self.window = nil;
    self.contentNavigationController = nil;
    self.slideOutViewController = nil;
    [super dealloc];
}

@end
