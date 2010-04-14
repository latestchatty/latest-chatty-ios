//
//  BrowserViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKHelperKit.h"

@interface BrowserViewController : UIViewController <UIWebViewDelegate> {
    NSURLRequest *request;
    
    UIWebView *webView;
    UIBarButtonItem *backButton;
    UIBarButtonItem *forwardButton;
    UIActivityIndicatorView *spinner;
    UIToolbar *mainToolbar;
}

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UIToolbar *mainToolbar;

- (id)initWithRequest:(NSURLRequest *)request;

- (IBAction)safari;
- (IBAction)closeBrowser;

@end
