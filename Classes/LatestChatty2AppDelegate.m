//
//    LatestChatty2AppDelegate.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/16/09.
//    Copyright 2009. All rights reserved.
//

#import "LatestChatty2AppDelegate.h"
#import "StringTemplate.h"
#import "Mod.h"
#import "NoContentController.h"
#import "IIViewDeckController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

static NSString *kWoggleBaseUrl = @"http://www.woggle.net/lcappnotification";

@implementation LatestChatty2AppDelegate

@synthesize window,
            navigationController,
            contentNavigationController,
            slideOutViewController,
            formatter,
            launchedShortcutItem;

+ (LatestChatty2AppDelegate *)delegate {
    return (LatestChatty2AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)setupInterfaceForPhoneWithOptions:(NSDictionary *)launchOptions {
    // Create and assign the left and center controllers
    IIViewDeckController* deckController = [self generateControllerStack:launchOptions];
    self.leftController = deckController.leftController;
    self.centerController = deckController.centerController;
    
    self.window.rootViewController = deckController;
}

- (void)setupInterfaceForPadWithOptions:(NSDictionary *)launchOptions {
    UIViewController *rootContentController;
    // if launched via push notification
    if (launchOptions != nil) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil) {
            NSLog(@"Launched from push notification: %@", userInfo);
            
            NSUInteger *launchThreadId = [[userInfo objectForKey:@"postid"] integerValue];
            UIViewController *viewController = [[ThreadViewController alloc] initWithThreadId:launchThreadId];
            
            if (viewController) {
                rootContentController = [UINavigationController controllerWithRootController:viewController];
            }
        }
    } else {
        rootContentController = [NoContentController controllerWithNib];
    }
    self.contentNavigationController = [UINavigationController controllerWithRootController:rootContentController];
    
//    if (![self reloadSavedState]) {
    // Add the root view controller
    [navigationController pushViewController:[RootViewController controllerWithNib] animated:NO];
//    }
    
    self.slideOutViewController =  [SlideOutViewController controllerWithNib];
    [slideOutViewController addNavigationController:navigationController contentNavigationController:contentNavigationController];

    CGRect windowBounds = [[[UIApplication sharedApplication] keyWindow] bounds];
    [slideOutViewController.view setFrame:windowBounds];

    UIView *topBar = [UIView viewWithFrame:CGRectMake(0, 0, windowBounds.size.width, 20)];
    topBar.backgroundColor = [UIColor lcTableBackgroundColor];
    [topBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [slideOutViewController.view addSubview:topBar];
    
    self.window.rootViewController = slideOutViewController;
}

- (IIViewDeckController *)generateControllerStack:(NSDictionary *)launchOptions {
    // Left controller
    RootViewController* leftController = [[RootViewController alloc] init];
    
    // Center controller
    UIViewController *centerController;
    // if launched via push notification
    if (launchOptions != nil) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil) {
            NSLog(@"Launched from push notification: %@", userInfo);
            
            NSUInteger *launchThreadId = [[userInfo objectForKey:@"postid"] integerValue];
            UIViewController *viewController = [[ThreadViewController alloc] initWithThreadId:launchThreadId];
            
            if (viewController) {
                centerController = viewController;
            }
        }
    } else {
        centerController = [ChattyViewController chattyControllerWithLatest];
        [centerController setTitle:@"Loading..."];
    }
    
    // Initialize the navigation controller with the center (chatty) controller
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:centerController];
    
    // Create the deck controller with the left and center
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.navigationController
                                                                                    leftViewController:leftController];
    // Set navigation type, left size, no elasticity
    [deckController setNavigationControllerBehavior:IIViewDeckNavigationControllerIntegrated];
    [deckController setElastic:NO];
    [deckController setPanningMode:IIViewDeckFullViewPanning];
    [deckController setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose];
    [deckController setSizeMode:IIViewDeckViewSizeMode];
    [deckController setParallaxAmount:0.5f];

    return deckController;
}

- (BOOL)handleShortcutItem:(UIApplicationShortcutItem *) shortcutItem {
    UIViewController *viewController;
    NSDictionary *userInfo;
    BOOL handled = NO;
    
    NSArray *shortcutTypes = @[@"latestchatty2.mymessages",
                               @"latestchatty2.search",
                               @"latestchatty2.newcomment",
                               @"latestchatty2.myreplies"];
    NSUInteger shortcutItemType = [shortcutTypes indexOfObject:shortcutItem.type];
    
    switch (shortcutItemType) {
        case 0: {
            viewController = [MessagesViewController controllerWithNib];
            
            userInfo = @{@"selectedIndex": @2};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SetSelectedIndex" object:nil userInfo:userInfo];
            
            handled = YES;
            break;
        }
        case 1: {
            viewController = [SearchViewController controllerWithNib];
            
            userInfo = @{@"selectedIndex": @3};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SetSelectedIndex" object:nil userInfo:userInfo];
            
            handled = YES;
            break;
        }
        case 2: {
            viewController = [[ComposeViewController alloc] initWithStoryId:0 post:nil];
            handled = YES;
            break;
        }
        case 3: {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *user = [defaults stringForKey:@"username"];
            viewController = [[SearchResultsViewController alloc] initWithTerms:@""
                                                                         author:@""
                                                                   parentAuthor:user];
            handled = YES;
            break;
        }
        default:
            break;
    }
    
    if (viewController) {
        [self handleViewController:viewController];
    }
    
    return handled;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {

    BOOL *handledShortCutItem = [self handleShortcutItem: shortcutItem];
    completionHandler(handledShortCutItem);

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Crashlytics startWithAPIKey:@"7e5579f671abccb0156cc1a6de1201f981ef170c"];
    
    [self customizeAppearance];

    self.formatter = [[NSDateFormatter alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    NSDate *lastSaveDate = [defaults objectForKey:@"savedStateDate"];
//    // If forget history is on or it's been 8 hours since the last opening, then we don't care about the saved state.
//    if ([defaults boolForKey:@"forgetHistory"] || [lastSaveDate timeIntervalSinceNow] < -8*60*60) {
//        [defaults removeObjectForKey:@"savedState"];
//    }

    // Settings defaults
    NSDictionary *defaultSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"",                           @"username",
                                     @"",                           @"password",
                                     @"winchatty.com/chatty",       @"serverApi",
                                     [NSNumber numberWithBool:NO],  @"collapse",
                                     [NSNumber numberWithBool:YES], @"landscape",
                                     [NSNumber numberWithBool:NO],  @"useYouTube",
                                     [NSNumber numberWithBool:NO],  @"pushMessages",
                                     [NSNumber numberWithBool:YES], @"pushMessages.firstLaunch",
                                     [NSNumber numberWithBool:YES], @"pushMessages.vanity",
                                     [NSNumber numberWithBool:YES], @"pushMessages.replies",
                                     @"",                           @"pushMessages.deviceToken",
                                     [NSNumber numberWithBool:YES], @"picsResize",
                                     [NSNumber numberWithFloat:0.7],@"picsQuality",
                                     [NSNumber numberWithInt:0],    @"browserPref",
                                     [NSNumber numberWithBool:NO],  @"useChrome",
                                     [NSNumber numberWithBool:YES], @"postCategory.informative",
                                     [NSNumber numberWithBool:YES], @"postCategory.offtopic",
                                     [NSNumber numberWithBool:YES], @"postCategory.stupid",
                                     [NSNumber numberWithBool:YES], @"postCategory.political",
                                     [NSNumber numberWithBool:NO],  @"postCategory.nws",
                                     [NSNumber numberWithInt:0],    @"lastRefresh",
                                     [NSNumber numberWithInt:1],    @"grippyBarPosition",
                                     [NSNumber numberWithBool:NO],  @"orderByPostDate",
                                     [NSNumber numberWithInt:0],    @"searchSegmented",
                                     [NSMutableArray array],        @"pinnedThreads",
                                     [NSMutableArray array],        @"collapsedThreads",
                                     [NSMutableArray array],        @"recentSearches",
                                     [NSNumber numberWithBool:NO],  @"superSecretFartMode",
                                     [NSNumber numberWithBool:YES], @"saveSearches",
                                     [NSNumber numberWithBool:NO],  @"lolTags",
                                     nil];
    [defaults registerDefaults:defaultSettings];
    
    // register for iCloud notifications to the keystore
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeChanged:)
                                                 name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                               object:store];
    [Fabric with:@[[Crashlytics class]]];
    [CrashlyticsKit setUserName:[defaults stringForKey:@"username"]];
    
    // clear the captured date of the last successful lol fetch
    [defaults removeObjectForKey:@"lolFetchDate"];
    
    [self cleanUpCollapsedThreads];
    [self cleanUpPinnedThreads];

    [defaults synchronize];
    // fire synchronize on app load to sync settings from iCloud
    // freshing install: will pull all existing iCloud user settings down and put into user defaults database
    // existing install: will pull down any changes in the iCloud user settings and sync to the user defaults database
    [store synchronize];
    
    if ([self isPadDevice]) {
        [self setupInterfaceForPadWithOptions:launchOptions];
    } else {
        [self setupInterfaceForPhoneWithOptions:launchOptions];
    }
    
    if ([self isForceTouchEnabled]) {
        launchedShortcutItem = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
    }
    
    [self pushRegistration];
    
    [window makeKeyAndVisible];
    
    // Modified requestBody and request URL for May 2013 Shacknews login changes
    if ([defaults boolForKey:@"modTools"] == YES) {
        //Mods need cookies
        NSString *usernameString = [[defaults stringForKey:@"username"] stringByEscapingURL];
        NSString *passwordString = [[defaults stringForKey:@"password"] stringByEscapingURL];
        //NSString *requestBody = [NSString stringWithFormat:@"email=%@&password=%@&login=login", usernameString, passwordString];
        NSString *requestBody = [NSString stringWithFormat:@"get_fields%%5B%%5D=result&user-identifier=%@&supplied-pass=%@&remember-login=1", usernameString, passwordString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
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

- (void)cleanUpPinnedThreads {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Self-clearing the pinnedThreads array based on date of each pinned thread.
    // Keep threads pinned only if they haven't passed a set hours threshold.
    // Should be more efficient to create a new array of threads to keep rather than the inverse
    // of creating an array of threads to remove with [pinnedThreads removeObjectsInArray:array].
    NSMutableArray *pinnedThreads = [NSMutableArray arrayWithArray:[defaults objectForKey:@"pinnedThreads"]];
    NSMutableArray *pinnedThreadsToKeep = [NSMutableArray array];
    
    BOOL aThreadWasRemoved = NO;
    // loop over pinnedThread dictionaries in array
    for (NSDictionary *pinnedThreadDict in pinnedThreads) {
        NSDate *date = [pinnedThreadDict objectForKey:@"date"];
        if (date) {
            // build time interval from now to original post date of collapsed thread
            NSTimeInterval ti = [date timeIntervalSinceNow];
            NSInteger hours = (ti / 3600) * -1;
            
            // if pinned thread is less than 24 hours old, add dictionary to pinnedThreadsToKeep array
            if (hours < 24) {
                //NSLog(@"keeping thread pinned: %@", pinnedThreadDict);
                [pinnedThreadsToKeep addObject:pinnedThreadDict];
            } else {
                aThreadWasRemoved = YES;
            }
        } else {
            // handles any 0 id threads that may be stuck in the array
            // the don't have dates associated, so always remove them
            aThreadWasRemoved = YES;
        }
    }
    if (aThreadWasRemoved) {
        // update pinnedThreads array
        [defaults setObject:pinnedThreadsToKeep forKey:@"pinnedThreads"];
        [[NSUbiquitousKeyValueStore defaultStore] setObject:pinnedThreadsToKeep forKey:@"pinnedThreads"];
    }
}

- (void)cleanUpCollapsedThreads {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Self-clearing the collapsedThreads array based on date of each collapsed thread.
    // Keep threads collapsed only if they haven't expired yet from the chatty.
    // Should be more efficient to create a new array of threads to keep rather than the inverse
    // of creating an array of threads to remove with [collapsedThreads removeObjectsInArray:array].
    NSMutableArray *collapsedThreads = [NSMutableArray arrayWithArray:[defaults objectForKey:@"collapsedThreads"]];
    NSMutableArray *collapsedThreadsToKeep = [NSMutableArray array];
    
    BOOL aThreadWasRemoved = NO;
    // loop over collapsedThread dictionaries in array
    for (NSDictionary *collapsedThreadDict in collapsedThreads) {
        // build time interval from now to original post date of collapsed thread
        NSTimeInterval ti = [[collapsedThreadDict objectForKey:@"date"] timeIntervalSinceNow];
        NSInteger hours = (ti / 3600) * -1;
        
        // if collapsed thread hasn't expired, add dictionary collapsedThreadsToKeep array
        if (hours < 18) {
            //NSLog(@"keeping thread collapsed: %@", collapsedThreadDict);
            [collapsedThreadsToKeep addObject:collapsedThreadDict];
        } else {
            aThreadWasRemoved = YES;
        }
    }
    if (aThreadWasRemoved) {
        // update collapsedThreads array
        [defaults setObject:collapsedThreadsToKeep forKey:@"collapsedThreads"];
        [[NSUbiquitousKeyValueStore defaultStore] setObject:collapsedThreadsToKeep forKey:@"collapsedThreads"];
    }
}

// handler fired when iCloud keystore synchronizes
- (void)storeChanged:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *reason = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    
    if (reason) {
        NSInteger reasonValue = [reason integerValue];
        // 0 = not a fresh install, sync existing settings
        // 1 = new install, sync all settings
        NSLog(@"storeChanged with reason %ld", (long)reasonValue);
        
        if ((reasonValue == NSUbiquitousKeyValueStoreServerChange) ||
            (reasonValue == NSUbiquitousKeyValueStoreInitialSyncChange)) {
            
            NSArray *keys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
            NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            // all key names locally and in iCloud are the same, so we can loop over the changed keys and sync easily
            for (NSString *key in keys) {
                id value = [store objectForKey:key];
                [userDefaults setObject:value forKey:key];
                NSLog(@"storeChanged updated value for %@",key);
            }
        }
    }
}

// Check a URL to see if it is for youtube.com
- (BOOL)isYouTubeURL:(NSURL *)url {
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
        viewController = [[ThreadViewController alloc] initWithThreadId:targetThreadId];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/laryn\\.x\\?story=\\d+"]) {
        NSUInteger targetStoryId = [[uri stringByMatching:@"shacknews\\.com/laryn\\.x\\?story=(\\d+)" capture:1] intValue];
        viewController = [[ChattyViewController alloc] initWithStoryId:targetStoryId];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/profile/.*"]) {
        NSString *profileName = [[uri stringByMatching:@"shacknews\\.com/profile/(.*)" capture:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        viewController = [[SearchResultsViewController alloc] initWithTerms:@"" author:[profileName stringByReplacingOccurrencesOfString:@"+" withString:@" "] parentAuthor:@""];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/user/.*/posts"]) {
        NSString *profileName = [[uri stringByMatching:@"shacknews\\.com/user/(.*)/posts" capture:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        viewController = [[SearchResultsViewController alloc] initWithTerms:@"" author:[profileName stringByReplacingOccurrencesOfString:@"+" withString:@" "] parentAuthor:@""];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/search\\?chatty=1&type=4"]) {
        //http://www.shacknews.com/search?chatty=1&type=4&chatty_term=test&chatty_user=test&chatty_author=test&chatty_filter=all&result_sort=postdate_desc
        NSString *terms = [[uri stringByMatching:@"&chatty_term=([^&]*)" capture:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *author = [[uri stringByMatching:@"&chatty_user=([^&]*)" capture:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        NSString *parentAuthor = [[uri stringByMatching:@"&chatty_author=([^&]*)" capture:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        if (terms || author || parentAuthor) {
            viewController = [[SearchResultsViewController alloc]
                              initWithTerms:(terms ? [terms stringByReplacingOccurrencesOfString:@"+" withString:@" "] : @"")
                              author:(author ? [author stringByReplacingOccurrencesOfString:@"+" withString:@" "] : @"")
                              parentAuthor:(parentAuthor ? [parentAuthor stringByReplacingOccurrencesOfString:@"+" withString:@" "] : @"")];
        }
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/search\\?q=([^&]*)&type=4"]) {
        //http://www.shacknews.com/search?q=test&type=4
        NSString *terms = [[uri stringByMatching:@"q=([^&]*)" capture:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        if (terms) {
            viewController = [[SearchResultsViewController alloc] initWithTerms:terms author:@"" parentAuthor:@""];
        }
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/chatty/?\\?id=\\d+"]) {
        NSUInteger targetThreadId = [[uri stringByMatching:@"shacknews\\.com/chatty/?\\?id=(\\d+)" capture:1] intValue];
        viewController = [[ThreadViewController alloc] initWithThreadId:targetThreadId];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/chatty/\\d+"]) {
        NSUInteger targetThreadId = [[uri stringByMatching:@"shacknews\\.com/chatty/(\\d+)" capture:1] intValue];
        viewController = [[ThreadViewController alloc] initWithThreadId:targetThreadId];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/chatty\\?story=\\d+"]) {
        NSUInteger targetStoryId = [[uri stringByMatching:@"shacknews\\.com/chatty\\?story=(\\d+)" capture:1] intValue];
        viewController = [[ChattyViewController alloc] initWithStoryId:targetStoryId];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/onearticle.x/\\d+"]) {
        NSUInteger targetStoryId = [[uri stringByMatching:@"shacknews\\.com/onearticle.x/(\\d+)" capture:1] intValue];
        viewController = [[StoryViewController alloc] initWithStoryId:targetStoryId];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/article/.*\\?id=\\d+"]) {
        NSUInteger targetThreadId = [[uri stringByMatching:@"shacknews\\.com/article/.*\\?id=(\\d+)" capture:1] intValue];
        viewController = [[ThreadViewController alloc] initWithThreadId:targetThreadId];
    } else if ([uri isMatchedByRegex:@"shacknews\\.com/article/\\d+"]) {
        NSUInteger targetStoryId = [[uri stringByMatching:@"shacknews\\.com/article/(\\d+)" capture:1] intValue];
        viewController = [[StoryViewController alloc] initWithStoryId:targetStoryId];
    }

    return viewController;
}

//- (BOOL)reloadSavedState {
//    @try {
//        // Find saved state
//        NSData *savedState = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedState"];
//        
//        if (savedState) {
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedState"];
//            NSArray *controllerDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:savedState];
//            
//            // Create a dictionary to convert controller type strings to class objects
//            NSMutableDictionary *controllerClassLookup = [NSMutableDictionary dictionary];
//            [controllerClassLookup setObject:[RootViewController class]    forKey:@"Root"];
//            [controllerClassLookup setObject:[StoriesViewController class] forKey:@"Stories"];
//            [controllerClassLookup setObject:[StoryViewController class]   forKey:@"Story"];
//            [controllerClassLookup setObject:[ChattyViewController class]  forKey:@"Chatty"];
//            [controllerClassLookup setObject:[ThreadViewController class]  forKey:@"Thread"];
//            [controllerClassLookup setObject:[BrowserViewController class] forKey:@"Browser"];
//            
//            for (NSDictionary *dictionary in controllerDictionaries) {
//                // find the right controller class
//                NSString *controllerName = [dictionary objectForKey:@"type"];
//                Class class = [controllerClassLookup objectForKey:controllerName];
//                
//                if (class) {
//                    id viewController = [[class alloc] initWithStateDictionary:dictionary];
//                    [navigationController pushViewController:viewController animated:NO];
//                } else {
//                    NSLog(@"No known view controller for the type: %@", controllerName);
//                    return NO;
//                }
//            }
//        } else {
//            return NO;
//        }
//        
//    }
//    @catch (NSException *e) {
//        // Something went wrong restoring state, so just start over.
//        navigationController.viewControllers = nil;
//        return NO;
//    }
//    
//    return YES;
//}

- (BOOL)isPadDevice {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (BOOL)isCompactView {
    BOOL result = [self isPadDevice] && [[UIApplication sharedApplication] keyWindow].bounds.size.width <= 320.0f;
    
//    NSLog(@"is compact view? %@", (result ? @"YES" : @"NO"));
    
    return result;
}

- (BOOL)isSplitView {
    BOOL result = [self isPadDevice] && [[UIApplication sharedApplication] keyWindow].bounds.size.width < 768.0f;
    
    //    NSLog(@"is compact view? %@", (result ? @"YES" : @"NO"));
    
    return result;
}

- (BOOL)isForceTouchEnabled {
    BOOL result = NO;
    
    if ([self.window.rootViewController.traitCollection respondsToSelector:@selector(forceTouchCapability)] &&
        (self.window.rootViewController.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)) {
        result = YES;
    }
    
    return result;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self cleanUpCollapsedThreads];
    [self cleanUpPinnedThreads];
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    NSLog(@"post active notification");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateViewsForMultitasking" object:self];
    
    if (!launchedShortcutItem) { return; }
    [self handleShortcutItem: launchedShortcutItem];
    launchedShortcutItem = nil;
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
    
    [self handleViewController:viewController];
    
    return YES;
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    static NSInteger numberOfCallsToSetVisible = 0;
    if (setVisible)
        numberOfCallsToSetVisible++;
    else
        numberOfCallsToSetVisible--;
    
//    NSLog(@"%i", numberOfCallsToSetVisible);
//    NSAssert(numberOfCallsToSetVisible >= 0, @"Network Activity Indicator was asked to hide more often than shown");
    
    // display the indicator as long as our static counter is > 0.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(numberOfCallsToSetVisible > 0)];
}

- (NSURLCredential *)userCredential {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [NSURLCredential credentialWithUser:[defaults objectForKey:@"username"]
                                      password:[defaults objectForKey:@"password"]
                                   persistence:NSURLCredentialPersistenceNone];
}

- (UIViewController *)makeThreadViewController {
    return [[ThreadViewController alloc] initWithThreadId:threadId];
}

- (void)handleViewController:(UIViewController *)viewController {
    if ([self isPadDevice]) {
        [self.contentNavigationController pushViewController:viewController animated:YES];
    } else {
        // close view deck menu if it was opened
        [[self.navigationController viewDeckController] closeLeftView];
        
        // dismiss any modally presented view controllers
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        // handle the view controller
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    viewController = nil;
}

#pragma mark - Appearance customizations

// Custom appearance settings for UIKit items
- (void)customizeAppearance {
    // status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Give the navigation bar title text coloring & shadowing
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary titleTextAttributesDictionary]];
    
    // nav/toolbar tinting
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor lcBarTintColor]];
    [[UIToolbar appearanceWhenContainedIn:[BrowserViewController class], nil] setTintColor:[UIColor whiteColor]];
    [[UIToolbar appearance] setBarTintColor:[UIColor lcBarTintColor]];
    
    // progress bar (uploading to chattypics)
    [[UIProgressView appearance] setProgressTintColor:[UIColor lcSwitchOnColor]];
    [[UIProgressView appearance] setTrackTintColor:[UIColor lcSliderMaximumColor]];
}

#pragma mark - Rotation

+ (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

+ (UIInterfaceOrientationMask)supportedInterfaceOrientations {
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

#pragma mark - Notification Support

- (void)pushRegistration {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults valueForKey:@"username"] length] != 0 && [defaults boolForKey:@"pushMessages.firstLaunch"] == YES) {
        // Add registration for remote notifications
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        [defaults setBool:NO forKey:@"pushMessages.firstLaunch"];
        
    } else if ([defaults  boolForKey:@"pushMessages.firstLaunch"] == NO &&
              [[defaults valueForKey:@"pushMessages.deviceToken"] length] != 0) {
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        UIUserNotificationType notificationTypes = settings.types;
        
        BOOL *isPushAlertEnabled = (notificationTypes & UIUserNotificationTypeAlert) ? YES : NO;
        if (!isPushAlertEnabled) {
            // unregister to woggle
            //change.php?action=remove&type=device&devicetoken=
            NSString *deviceToken = [defaults valueForKey:@"pushMessages.deviceToken"];
            NSDictionary *removedeviceParameters =
            @{@"action": @"remove",
              @"type": @"device",
              @"devicetoken": deviceToken};
            NSLog(@"calling removedevice w/ parameters: %@", removedeviceParameters);
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [manager POST:[NSString stringWithFormat:@"%@/change.php", kWoggleBaseUrl]
               parameters:removedeviceParameters
                 progress:nil
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      [defaults setBool:NO forKey:@"pushMessages"];
                      [defaults setValue:@"" forKey:@"pushMessages.deviceToken"];
                  }
                  failure:nil];
        }
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Get Bundle Info for Remote Registration (handy if you have more than one app)
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    // Check what Notifications the user has turned on.
    // We registered for all three, but they may have manually disabled some or all of them.
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    UIUserNotificationType notificationTypes = settings.types;

    // Set the defaults to disabled unless we find otherwise...
    NSString *pushBadge = (notificationTypes & UIUserNotificationTypeBadge) ? @"enabled" : @"disabled";
    NSString *pushAlert = (notificationTypes & UIUserNotificationTypeAlert) ? @"enabled" : @"disabled";
    NSString *pushSound = (notificationTypes & UIUserNotificationTypeSound) ? @"enabled" : @"disabled";
    
    // Get the users Device Model, Display Name, Unique ID, Token & Version Number
    NSString *deviceUuid = [defaults valueForKey:@"deviceUuid"];
    if (!deviceUuid) {
        deviceUuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [defaults setValue:deviceUuid forKey:@"deviceUuid"];
    }
    UIDevice *dev = [UIDevice currentDevice];
    NSString *deviceName = [dev.name stringByEscapingURL];
    NSString *deviceModel = dev.model;
    NSString *deviceSystemVersion = dev.systemVersion;
    
    // SHACK USERNAME
    NSString *shackUserName = [[defaults stringForKey:@"username"] stringByEscapingURL];
    
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<" withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString:@" " withString:@""];
    [defaults setValue:deviceToken forKey:@"pushMessages.deviceToken"];
    
    // Build parameter dictionary for Registration
    NSDictionary *registerParameters =
        @{@"task": @"register",
          @"appname": appName,
          @"appversion": appVersion,
          @"deviceuid": deviceUuid,
          @"devicetoken": deviceToken,
          @"devicename": deviceName,
          @"devicemodel": deviceModel,
          @"deviceversion": deviceSystemVersion,
          @"pushbadge": pushBadge,
          @"pushalert": pushAlert,
          @"pushsound": pushSound,
          @"clientid": shackUserName};
    NSLog(@"calling register w/ parameters: %@", registerParameters);
    
    // Register the device
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@//apns.php", kWoggleBaseUrl]
      parameters:registerParameters
        progress:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             // get their current prefs
             NSLog(@"calling getuser w/ parameters: %@", @{@"user": shackUserName});
             [manager POST:[NSString stringWithFormat:@"%@/getuser.php", kWoggleBaseUrl]
               parameters:@{@"user": shackUserName}
                 progress:nil
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      
                      // adduser with their current prefs (defaulted to yes)
                      BOOL vanity = YES;
                      BOOL replies = YES;
                      if ([responseObject objectForKey:@"get_vanity"]) {
                          vanity = [responseObject boolForKey:@"get_vanity"];
                      }
                      if ([responseObject objectForKey:@"get_replies"]) {
                          replies = [responseObject boolForKey:@"get_replies"];
                      }
                      
                      NSDictionary *adduserParameters =
                          @{@"action": @"add",
                            @"type": @"user",
                            @"user": shackUserName,
                            @"getvanity": vanity ? @"1" : @"0",
                            @"getreplies": replies ? @"1" : @"0"};
                      NSLog(@"calling adduser w/ parameters: %@", adduserParameters);
                      [manager POST:[NSString stringWithFormat:@"%@/change.php", kWoggleBaseUrl]
                        parameters:adduserParameters
                          progress:nil
                           success:nil
                           failure:nil];
                  }
                  failure:nil];
         }
         failure:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Remote notification: %@",[userInfo description]);
    
    threadId = [[userInfo objectForKey:@"postid"] integerValue];
    if (application.applicationState == UIApplicationStateActive) {
        [UIAlertView showWithTitle:@"Notification Received"
                           message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                          delegate:self
                 cancelButtonTitle:@"Dismiss"
                 otherButtonTitles:@"View", nil];
    } else {
        // if app is running in the background, fire this notification
        [self handleViewController:[self makeThreadViewController]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self handleViewController:[self makeThreadViewController]];
    }
}

@end
