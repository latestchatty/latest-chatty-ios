//
//  StoryViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StoryViewController.h"


@implementation StoryViewController

@synthesize story;

- (id)initWithStory:(Story *)aStory {
  [self initWithNibName:@"StoryViewController" bundle:nil];
  
  self.story = aStory;
  self.title = self.story.title;
    
  return self;
}

- (id)initWithStateDictionary:(NSDictionary *)dictionary {
  return [self initWithStory:[dictionary objectForKey:@"story"]];
}

- (NSDictionary *)stateDictionary {
  return [NSDictionary dictionaryWithObjectsAndKeys:@"Story", @"type",
                                                    story,    @"story", nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem *chattyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ChatIcon.24.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(loadChatty)];
	self.navigationItem.rightBarButtonItem = chattyButton;
  [chattyButton release];
  
  
  // Load up web view content
  NSString *baseUrlString = [NSString stringWithFormat:@"http://shacknews.com/onearticle.x/%i", story.modelId];
  
  StringTemplate *htmlTemplate = [[StringTemplate alloc] initWithTemplateName:@"Story.html"];
  
  NSString *stylesheet = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Stylesheet.css" ofType:nil]];
  [htmlTemplate setString:stylesheet forKey:@"stylesheet"];
  [htmlTemplate setString:[Story formatDate:story.date] forKey:@"date"];
  [htmlTemplate setString:[NSString stringWithFormat:@"%i", story.modelId] forKey:@"storyId"];
  [htmlTemplate setString:story.body forKey:@"content"];
  [htmlTemplate setString:story.title forKey:@"storyTitle"];
  
  [content loadHTMLString:htmlTemplate.result baseURL:[NSURL URLWithString:baseUrlString]];
  [htmlTemplate release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)loadChatty {
  ChattyViewController *viewController = [[ChattyViewController alloc] initWithStoryId:story.modelId];
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}



- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    BrowserViewController *viewController = [[BrowserViewController alloc] initWithRequest:request];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    return NO;
  }
  
  return YES;
}

- (void)dealloc {
  [story release];
  [super dealloc];
}


@end
