//
//  ChattyViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelListViewController.h"
#import "Story.h"
#import "Post.h"
#import "ThreadCell.h"
#import "ModelLoader.h"
#import "ThreadViewController.h"
#import "ComposeViewController.h"

@interface ChattyViewController : ModelListViewController {
  NSUInteger storyId;
  NSArray *threads;
}

@property (assign) NSUInteger storyId;
@property (retain) NSArray *threads;

- (id)initWithLatestChatty;
- (id)initWithStoryId:(NSUInteger)aStoryId;

- (IBAction)tappedComposeButton;

@end
