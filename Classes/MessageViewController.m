//
//  MessageViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MessageViewController.h"


@implementation MessageViewController

@synthesize message;

- (id)initWithMesage:(Message *)aMessage {
  self = [super initWithNibName:@"MessageViewController" bundle:nil];
  self.message = aMessage;
  self.title = self.message.subject;
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  StringTemplate *htmlTemplate = [[StringTemplate alloc] initWithTemplateName:@"Post.html"];
  
  NSString *stylesheet = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Stylesheet.css" ofType:nil]];
  [htmlTemplate setString:stylesheet forKey:@"stylesheet"];
  [htmlTemplate setString:[Message formatDate:message.date] forKey:@"date"];
  [htmlTemplate setString:message.from forKey:@"author"];
  [htmlTemplate setString:message.body forKey:@"body"];
  
  [webView loadHTMLString:htmlTemplate.result baseURL:[NSURL URLWithString:@"http://www.shacknews.com/msgcenter.x"]];
  
  [htmlTemplate release];
}


- (void)dealloc {
  self.message = nil;
  [super dealloc];
}


@end
