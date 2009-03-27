//
//  BrowserViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"


@implementation BrowserViewController

- (id)initWithRequest:(NSURLRequest *)request {
  if (self = [super initWithNibName:@"BrowserViewController" bundle:nil]) {
    initialRequest = [request retain];
    
    self.title = @"Browser";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem *safariButton = [[UIBarButtonItem alloc] initWithTitle:@"Safari"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(openInSafari)];
  self.navigationItem.rightBarButtonItem = safariButton;
  [safariButton release];
  
  [webView loadRequest:initialRequest];
  [initialRequest release];
  initialRequest = nil;
}

- (IBAction)openInSafari {
  NSLog(@"Open in safari");
}

- (void)dealloc {
  [initialRequest release];
  [super dealloc];
}


@end
