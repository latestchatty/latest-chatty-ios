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

#import "Story.h"
#import "Post.h"

#import "StoryCell.h"

#import "ChattyViewController.h"
#import "StoryViewController.h"

@interface StoriesViewController : ModelListViewController {
  NSArray *stories;
}

@property (retain) NSArray *stories;

- (IBAction)tappedChattyButton:(id)sender;
- (IBAction)tappedLatestChattyButton:(id)sender;

- (IBAction)refresh:(id)sender;

@end
