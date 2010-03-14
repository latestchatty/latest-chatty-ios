//
//  LatestChatty2AppDelegate.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringAdditions.h"

#import "RootViewController.h"
#import "StoriesViewController.h"
#import "SettingsViewController.h"
#import "ChattyViewController.h"
#import "ThreadViewController.h"
#import "BrowserViewController.h"
#import "ImageViewController.h"
#import "MessagesViewController.h"

@interface LatestChatty2AppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
  UIWindow *window;
  UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (BOOL)reloadSavedState;

- (NSURLCredential *)userCredential;
- (id)viewControllerForURL:(NSURL *)url;

@end

