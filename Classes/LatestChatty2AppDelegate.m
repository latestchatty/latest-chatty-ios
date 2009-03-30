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
  if (![self reloadSavedState]) {
    // Add the stories view controller
    StoriesViewController *viewController = [[StoriesViewController alloc] init];
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
  NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"ws.shackchatty.com",         @"server",
                            [NSNumber numberWithBool:YES], @"landscape",
                            nil];
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (BOOL)reloadSavedState {
  // Find saved state
  NSData *savedState = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedState"];
  if (savedState) {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"savedState"];
    NSArray *controllerDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:savedState];
    
    // Create a dictionary to convert controller type strings to class objects
    NSMutableDictionary *controllerClassLookup = [NSMutableDictionary dictionary];
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
  
  return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
  NSMutableArray *savedControllers = [NSMutableArray array];
  for (id viewController in [navigationController viewControllers]) {
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
