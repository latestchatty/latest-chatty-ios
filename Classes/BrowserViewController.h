//
//  BrowserViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKHelperKit.h"

@interface BrowserViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
    NSURLRequest *request;
    
    UIWebView *webView;
    UIBarButtonItem *backButton;
    UIBarButtonItem *forwardButton;
    UIActivityIndicatorView *spinner;
    UIToolbar *mainToolbar;
    UIBarButtonItem *lolMenuButton;
    UIBarButtonItem *actionButton;
    UIToolbar *bottomToolbar;
    BOOL isShackLOL;
}

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UIToolbar *mainToolbar;
@property (nonatomic, retain) UIBarButtonItem *lolMenuButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *actionButton;
@property (nonatomic, retain) IBOutlet UIToolbar *bottomToolbar;
@property (nonatomic, assign) BOOL isShackLOL;

- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithRequest:(NSURLRequest *)request title:(NSString*)title isForShackLOL:(BOOL)isForShackLOL;

- (IBAction)safari;
- (IBAction)action:(id)sender;
- (IBAction)closeBrowser;

@end
