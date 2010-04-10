//
//  ChattyViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKHelperKit.h"

#import "ModelListViewController.h"
#import "Story.h"
#import "Post.h"
#import "ThreadCell.h"
#import "ModelLoader.h"
#import "ComposeViewController.h"

@class ThreadViewController;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
@interface ChattyViewController : ModelListViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate> {
#else
@interface ChattyViewController : ModelListViewController <UINavigationControllerDelegate> {
#endif
    ThreadViewController *threadController;
    
    NSUInteger storyId;
    NSArray *threads;

    NSIndexPath *indexPathToSelect;
    NSUInteger currentPage;
    NSUInteger lastPage;
}

@property (nonatomic, retain) ThreadViewController *threadController;

@property (assign) NSUInteger storyId;
@property (retain) NSArray *threads;

+ (ChattyViewController*)chattyControllerWithLatest;
+ (ChattyViewController*)chattyControllerWithStoryId:(NSUInteger)aStoryId;

- (id)initWithLatestChatty;
- (id)initWithStoryId:(NSUInteger)aStoryId;

- (IBAction)tappedComposeButton;

@end
