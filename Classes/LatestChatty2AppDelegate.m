//
//  LatestChatty2AppDelegate.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "LatestChatty2AppDelegate.h"

#import "StringTemplate.h"

@implementation LatestChatty2AppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  if ([defaults boolForKey:@"forgetHistory"]) {
    [defaults removeObjectForKey:@"savedState"];
    [defaults setBool:NO forKey:@"forgetHistory"];
  }
  
  if (![self reloadSavedState]) {
    // Add the stories view controller
    RootViewController *viewController = [[RootViewController alloc] init];
    [navigationController pushViewController:viewController animated:NO];
    [viewController release];
  }
  
  // Style the navigation bar
  navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
  
	// Configure and show the window
  window.backgroundColor = [UIColor blackColor];
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  
  // Settings defaults
  NSDictionary *defaultSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"",                           @"username",
                                   @"",                           @"password",
                                   @"ws.shackchatty.com",         @"server",
                                   [NSNumber numberWithBool:YES], @"landscape",
                                   [NSNumber numberWithBool:YES], @"postCategory.informative",
                                   [NSNumber numberWithBool:YES], @"postCategory.offtopic",
                                   [NSNumber numberWithBool:YES], @"postCategory.stupid",
                                   [NSNumber numberWithBool:YES], @"postCategory.political",
                                   [NSNumber numberWithBool:NO],  @"postCategory.nws",
                                   nil];
  [defaults registerDefaults:defaultSettings];
}

- (NSURLCredential *)userCredential {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
  return [NSURLCredential credentialWithUser:[defaults objectForKey:@"username"]
                                    password:[defaults objectForKey:@"password"]
                                 persistence:NSURLCredentialPersistenceNone];
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
      [controllerClassLookup setObject:[RootViewController class]    forKey:@"Root"];
      [controllerClassLookup setObject:[StoriesViewController class] forKey:@"Stories"];
      [controllerClassLookup setObject:[StoryViewController class]   forKey:@"Story"];
      [controllerClassLookup setObject:[ChattyViewController class]  forKey:@"Chatty"];
      [controllerClassLookup setObject:[ThreadViewController class]  forKey:@"Thread"];
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
  [[NSUserDefaults standardUserDefaults] setObject:state forKey:@"savedState"];
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
