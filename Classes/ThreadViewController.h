//
//  ThreadViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/24/09.
//  Copyright 2009. All rights reserved.
//

#import "ModelListViewController.h"
#import "Post.h"
#import "Tag.h"
#import "Mod.h"
#import "ReplyCell.h"
#import "StringTemplate.h"
#import "GrippyBar.h"
#import "ComposeViewController.h"
#import "BrowserViewController.h"
#import "ChattyViewController.h"
@import SafariServices;

@interface ThreadViewController : ModelListViewController <UIWebViewDelegate, GrippyBarDelegate, UIActionSheetDelegate, UISplitViewControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, SFSafariViewControllerDelegate> {

    NSUInteger storyId;
    NSUInteger threadId;
    Post *rootPost;
    NSString *threadStarter;

    NSIndexPath *selectedIndexPath;

    IBOutlet UIView *postViewContainer;
    IBOutlet UIWebView *postView;
    IBOutlet GrippyBar *grippyBar;
    IBOutlet UIButton *threadPinButton;
    IBOutlet UIBarButtonItem *tagButton;
    NSInteger grippyBarPosition;

    NSUInteger lastReplyId;
    BOOL highlightMyPost;
}

@property (nonatomic, assign) NSUInteger threadId;
@property (strong) Post *rootPost;
@property (nonatomic, copy) NSString *threadStarter;
@property (strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, assign) CGPoint scrollPosition;

- (id)initWithThreadId:(NSUInteger)aThreadId;

- (IBAction)tappedReplyButton;
- (IBAction)refresh:(id)sender;
- (IBAction)tag;
- (IBAction)previous;
- (IBAction)next;

//- (NSString *)postBodyWithYoutubeWidgets:(NSString *)body;

- (void)refreshWithThreadId:(NSUInteger)threadId;

- (void)resetLayout:(BOOL)animated;

@end
