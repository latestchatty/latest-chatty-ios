//
//  ThreadViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelListViewController.h"
#import "Post.h"
#import "Tag.h"
#import "Mod.h"
#import "ReplyCell.h"
#import "StringTemplate.h"
#import "RegexKitLite.h"
#import "GrippyBar.h"
#import "ComposeViewController.h"
#import "BrowserViewController.h"
#import "ChattyViewController.h"

@interface ThreadViewController : ModelListViewController <UIWebViewDelegate, GrippyBarDelegate, UIActionSheetDelegate, UISplitViewControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate> {

    NSUInteger storyId;
    NSUInteger threadId;
    Post *rootPost;
    NSString *threadStarter;

    NSIndexPath *selectedIndexPath;

    IBOutlet UIView *postViewContainer;
    IBOutlet UIWebView *postView;
    IBOutlet GrippyBar *grippyBar;
    IBOutlet UIBarButtonItem *orderByPostDateButton;
    IBOutlet UIButton *threadPinButton;
    IBOutlet UIBarButtonItem *tagButton;
    NSInteger grippyBarPosition;

    NSUInteger lastReplyId;
    BOOL highlightMyPost;
    BOOL orderByPostDate;
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    UIToolbar *leftToolbar;
    
    UIActionSheet *theActionSheet;
    CGPoint scrollPosition;
    
    UILongPressGestureRecognizer *longPress;
    CGPoint longPressPoint;
    NSIndexPath *longPressIndexPath;
    
    UISwipeGestureRecognizer *swipe;
}

@property (nonatomic, assign) NSUInteger threadId;
@property (retain) Post *rootPost;
@property (nonatomic, copy) NSString *threadStarter;
@property (retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIToolbar *leftToolbar;
@property (retain) NSIndexPath *longPressIndexPath;

- (id)initWithThreadId:(NSUInteger)aThreadId;

- (IBAction)tappedReplyButton;
- (IBAction)refresh:(id)sender;
- (IBAction)tag;
- (IBAction)previous;
- (IBAction)next;
- (IBAction)toggleOrderByPostDate;
- (IBAction)toggleThreadPinned;

- (NSString *)postBodyWithYoutubeWidgets:(NSString *)body;

- (void)refreshWithThreadId:(NSUInteger)threadId;

- (void)resetLayout:(BOOL)animated;

@end
