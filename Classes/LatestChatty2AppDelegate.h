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
//    NSUInteger networkActivityIndicatorCount;
    
    // iPad
    UINavigationController *contentNavigationController;

	SlideOutViewController *slideOutViewController;
}

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

@property (nonatomic, strong) IBOutlet SlideOutViewController *slideOutViewController;
@property (nonatomic, strong) IBOutlet UINavigationController *contentNavigationController;

@property (strong, nonatomic) UIViewController *centerController;
@property (strong, nonatomic) UIViewController *leftController;

@property (strong, nonatomic) NSDictionary *lolCounts;

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
- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;
	
@end
