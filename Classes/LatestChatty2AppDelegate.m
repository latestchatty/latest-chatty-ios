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
	// Configure and show the window
  window.backgroundColor = [UIColor blackColor];
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  
  // Settings defaults
  NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:@"ws.shackchatty.com", @"server", nil];
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
