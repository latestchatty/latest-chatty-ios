//
//  ChattyViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/17/09.
//  Copyright 2009. All rights reserved.
//

#import "ModelListViewController.h"
#import "Story.h"
#import "Post.h"
#import "ThreadCell.h"
#import "ComposeViewController.h"

@class ThreadViewController;

@interface ChattyViewController : ModelListViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate> {
    ThreadViewController *threadController;
    
    NSUInteger storyId;
    NSMutableArray *threads;

    NSIndexPath *indexPathToSelect;
    NSUInteger currentPage;
    NSUInteger lastPage;
    
    BOOL shouldCollapse;
}

@property (nonatomic, strong) ThreadViewController *threadController;
@property (nonatomic, strong) NSMutableArray *threads;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) NSUInteger storyId;

+ (ChattyViewController*)chattyControllerWithLatest;
+ (ChattyViewController*)chattyControllerWithStoryId:(NSUInteger)aStoryId;

- (id)initWithLatestChatty;
- (id)initWithStoryId:(NSUInteger)aStoryId;

- (NSArray*)removeDuplicateThreadsFromArray:(NSArray*)threads;

@end
