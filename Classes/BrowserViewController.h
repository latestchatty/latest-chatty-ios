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
    UIBarButtonItem *refreshButton;
    UIBarButtonItem *actionButton;
    UIToolbar *bottomToolbar;
    BOOL isShackLOL;
    
    UIActionSheet *theActionSheet;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UIToolbar *mainToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *actionButton;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, retain) IBOutlet UIToolbar *bottomToolbar;
@property (nonatomic, assign) BOOL isShackLOL;

- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithRequest:(NSURLRequest *)request title:(NSString*)title isForShackLOL:(BOOL)isForShackLOL;

- (IBAction)action:(id)sender;
- (IBAction)refreshWebView:(id)sender;

@end
