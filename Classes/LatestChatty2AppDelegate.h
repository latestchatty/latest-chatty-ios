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
#import "SlideOutViewController.h"

@interface LatestChatty2AppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate, UISplitViewControllerDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
    
    // iPad
    UIBarButtonItem *navPopoverButton;
    UINavigationController *contentNavigationController;
    UIPopoverController *popoverController;

	SlideOutViewController *slideOutViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *navPopoverButton;
@property (nonatomic, retain) IBOutlet SlideOutViewController *slideOutViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *contentNavigationController;
@property (nonatomic, retain) UIPopoverController *popoverController;
	
+ (LatestChatty2AppDelegate*)delegate;

- (BOOL)reloadSavedState;

- (NSURLCredential *)userCredential;
- (id)viewControllerForURL:(NSURL *)url;
- (BOOL)isPadDevice;
	
- (void)showPopover;
- (void)dismissPopover;
	
@end

