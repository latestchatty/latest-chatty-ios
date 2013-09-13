//
//  BrowserViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/26/09.
//  Copyright 2009. All rights reserved.
//

@interface BrowserViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate> {
    NSURLRequest *request;
    
    UIWebView *webView;
    UIBarButtonItem *backButton;
    UIBarButtonItem *forwardButton;
    UIActivityIndicatorView *spinner;
    UIToolbar *mainToolbar;
    UIBarButtonItem *actionButton;
    UIToolbar *bottomToolbar;
    BOOL isShackLOL;
    BOOL isCredits;
    
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
@property (nonatomic, retain) IBOutlet UIToolbar *bottomToolbar;
@property (nonatomic, assign) BOOL isShackLOL;
@property (nonatomic, assign) BOOL isCredits;

- (id)initWithRequest:(NSURLRequest *)request;
- (id)initWithRequest:(NSURLRequest *)request
                title:(NSString*)title
        isForShackLOL:(BOOL)isForShackLOL
           isForCredits:(BOOL)isForCredits;

- (IBAction)action:(id)sender;
- (IBAction)refreshWebView:(id)sender;

@end
