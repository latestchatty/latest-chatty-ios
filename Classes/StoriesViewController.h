//
//  RootViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelListViewController.h"
#import "ModelLoadingDelegate.h"

#import "ModelLoader.h"
#import "Story.h"
#import "Post.h"

#import "StoryCell.h"

#import "ChattyViewController.h"
#import "StoryViewController.h"
#import "SettingsViewController.h"
#import "PullToRefreshView.h"

@interface StoriesViewController : ModelListViewController <PullToRefreshViewDelegate> {
  NSArray *stories;
}

@property (retain) NSArray *stories;
@property (nonatomic, retain) PullToRefreshView *pull;

- (id)initWithStateDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)stateDictionary;

- (IBAction)tappedChattyButton:(id)sender;
- (IBAction)tappedLatestChattyButton;

@end
