//
//  StoryViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import "ChattyViewController.h"
#import "StringTemplate.h"
#import "BrowserViewController.h"

@interface StoryViewController : UIViewController <UIWebViewDelegate> {
  Story *story;
  
  IBOutlet UIWebView *content;
}

@property (retain) Story *story;

- (id)initWithStory:(Story *)aStory;
- (void)loadChatty;

@end
