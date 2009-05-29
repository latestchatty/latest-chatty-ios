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



- (id)initWithStateDictionary:(NSDictionary *)dictionary {
  return [self initWithRequest:[dictionary objectForKey:@"initialRequest"]];
}

- (id)initWithUrlString:(NSString *)urlString {
  NSLog(urlString);
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  return [self initWithRequest:request];
}

- (NSDictionary *)stateDictionary {
  return [NSDictionary dictionaryWithObjectsAndKeys:@"Browser",     @"type",
                                                    initialRequest, @"initialRequest", nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
}

- (IBAction)dragonDrop {
	[initialRequest setValue:@"" forHTTPHeaderField:@"Referer"];
	[webView loadRequest:initialRequest];
}

- (IBAction)openInSafari {
  [[UIApplication sharedApplication] openURL:[webView.request URL]];
}


- (void)dealloc {
  [initialRequest release];
  [super dealloc];
}


@end
