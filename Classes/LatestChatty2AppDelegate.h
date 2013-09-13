//
//  LatestChatty2AppDelegate.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009. All rights reserved.
//

#import "RootViewController.h"
#import "StoriesViewController.h"
#import "SettingsViewController.h"
#import "ChattyViewController.h"
#import "ThreadViewController.h"
#import "ReviewThreadViewController.h"
#import "BrowserViewController.h"
#import "MessagesViewController.h"
#import "SlideOutViewController.h"
#import "IIViewDeckController.h"

@interface LatestChatty2AppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate, UISplitViewControllerDelegate> {
    UIWindow *window;
    UINavigationController *navigationController;
    
    // iPad
    UINavigationController *contentNavigationController;

	SlideOutViewController *slideOutViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet SlideOutViewController *slideOutViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *contentNavigationController;

@property (retain, nonatomic) UIViewController *centerController;
@property (retain, nonatomic) UIViewController *leftController;

- (IIViewDeckController*)generateControllerStack;

+ (LatestChatty2AppDelegate*)delegate;
+ (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;
+ (NSUInteger)supportedInterfaceOrientations;
+ (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (BOOL)reloadSavedState;

- (NSURLCredential *)userCredential;
- (BOOL)isYoutubeURL:(NSURL *)url;
- (id)urlAsChromeScheme:(NSURL *)url;
- (id)viewControllerForURL:(NSURL *)url;
- (BOOL)isPadDevice;
	
@end

