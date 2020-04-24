//
//  StoryViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009. All rights reserved.
//

#import "Story.h"
#import "ChattyViewController.h"
#import "StringTemplate.h"
#import "BrowserViewController.h"
@import SafariServices;

@interface StoryViewController : ModelListViewController <ModelLoadingDelegate, WKNavigationDelegate, WKUIDelegate, SFSafariViewControllerDelegate> {
    NSUInteger storyId;
    ModelLoader *storyLoader;
    Story *story;
    WKWebView *content;
}

@property (nonatomic, strong) ModelLoader *storyLoader;
@property (nonatomic, strong) Story *story;
@property (nonatomic, strong) IBOutlet WKWebView *content;

- (id)initWithStoryId:(NSUInteger)aStoryId;
- (id)initWithStory:(Story *)aStory;
- (void)loadChatty;
- (void)displayStory;

@end
