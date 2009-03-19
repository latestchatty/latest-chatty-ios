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

@interface ChattyViewController : ModelListViewController {
  Story *story;
  NSArray *threads;
}

@property (retain) Story *story;
@property (retain) NSArray *threads;

- (id)initWithLatestChatty;
- (id)initWithStory:(Story *)aStory;

@end
