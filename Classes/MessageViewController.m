//
//  MessageViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MessageViewController.h"
#include "LatestChatty2AppDelegate.h"

@implementation MessageViewController

@synthesize message;

- (id)initWithMesage:(Message *)aMessage {
    self = [super initWithNib];
    self.message = aMessage;
    self.title = self.message.subject;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StringTemplate *htmlTemplate = [StringTemplate templateWithName:@"Post.html"];
    
    [htmlTemplate setString:[NSString stringFromResource:@"Stylesheet.css"] forKey:@"stylesheet"];
    [htmlTemplate setString:[Message formatDate:message.date] forKey:@"date"];
    [htmlTemplate setString:message.from forKey:@"author"];
    [htmlTemplate setString:message.body forKey:@"body"];
    
    [webView loadHTMLString:htmlTemplate.result baseURL:[NSURL URLWithString:@"http://www.shacknews.com/msgcenter.x"]];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        LatestChatty2AppDelegate *appDelegate = (LatestChatty2AppDelegate *)[[UIApplication sharedApplication] delegate];
        id viewController = [appDelegate viewControllerForURL:[request URL]];
        if (viewController == nil) viewController = [[[BrowserViewController alloc] initWithRequest:request] autorelease];
        [self.navigationController pushViewController:viewController animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (void)dealloc {
    self.message = nil;
    [super dealloc];
}


@end
