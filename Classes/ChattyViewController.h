//
//  ChattyViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKHelperKit.h"
#import "PullToRefreshView.h"

#import "ModelListViewController.h"
#import "Story.h"
#import "Post.h"
#import "ThreadCell.h"
#import "ModelLoader.h"
#import "ComposeViewController.h"
#import "PinnedThreadsLoader.h"

@class ThreadViewController;

@interface ChattyViewController : ModelListViewController <PullToRefreshViewDelegate, UISplitViewControllerDelegate, UINavigationControllerDelegate> {
    ThreadViewController *threadController;
    
    NSUInteger storyId;
    NSArray *threads;

    NSIndexPath *indexPathToSelect;
    NSUInteger currentPage;
    NSUInteger lastPage;
}

@property (nonatomic, retain) ThreadViewController *threadController;
@property (nonatomic, retain) PullToRefreshView *pull;

@property (assign) NSUInteger storyId;
@property (retain) NSArray *threads;

+ (ChattyViewController*)chattyControllerWithLatest;
+ (ChattyViewController*)chattyControllerWithStoryId:(NSUInteger)aStoryId;

- (id)initWithLatestChatty;
- (id)initWithStoryId:(NSUInteger)aStoryId;

- (NSArray*)removeDuplicateThreadsFromArray:(NSArray*)threads;

@end
