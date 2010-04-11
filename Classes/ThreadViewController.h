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

@interface ThreadViewController : ModelListViewController <UIWebViewDelegate, GrippyBarDelegate, UIActionSheetDelegate, UISplitViewControllerDelegate, UIScrollViewDelegate> {

    NSUInteger storyId;
    NSUInteger threadId;
    Post *rootPost;

    NSIndexPath *selectedIndexPath;

	IBOutlet UIView *postViewContainer;
    IBOutlet UIWebView *postView;
    IBOutlet GrippyBar *grippyBar;
	IBOutlet UIBarButtonItem *orderByPostDateButton;
	IBOutlet UIButton *threadPinButton;
    NSUInteger grippyBarPosition;

    NSUInteger lastReplyId;
    BOOL highlightMyPost;
	BOOL orderByPostDate;
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    UIToolbar *leftToolbar;
}

@property (nonatomic, assign) NSUInteger threadId;
@property (retain) Post *rootPost;
@property (retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIToolbar *leftToolbar;

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

- (void)resetLayout;

@end
