//
//  ChattyViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PullToRefreshView.h"
#import "ModelListViewController.h"
#import "Story.h"
#import "Post.h"
#import "ThreadCell.h"
#import "ModelLoader.h"
#import "ComposeViewController.h"
#import "PinnedThreadsLoader.h"

@class ThreadViewController;

@interface ChattyViewController : ModelListViewController <PullToRefreshViewDelegate, UISplitViewControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate> {
    ThreadViewController *threadController;
    
    NSUInteger storyId;
    NSMutableArray *threads;

    NSIndexPath *indexPathToSelect;
    NSUInteger currentPage;
    NSUInteger lastPage;
    
    BOOL shouldCollapse;
}

@property (nonatomic, retain) ThreadViewController *threadController;
@property (nonatomic, retain) PullToRefreshView *pull;

@property (assign) NSUInteger storyId;
@property (retain) NSMutableArray *threads;

+ (ChattyViewController*)chattyControllerWithLatest;
+ (ChattyViewController*)chattyControllerWithStoryId:(NSUInteger)aStoryId;

- (id)initWithLatestChatty;
- (id)initWithStoryId:(NSUInteger)aStoryId;

- (NSArray*)removeDuplicateThreadsFromArray:(NSArray*)threads;

@end
