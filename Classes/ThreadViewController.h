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

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
#define DELEGATES UIWebViewDelegate, GrippyBarDelegate, UIActionSheetDelegate, UISplitViewControllerDelegate
#else
#define DELEGATES UIWebViewDelegate, GrippyBarDelegate, UIActionSheetDelegate
#endif

@interface ThreadViewController : ModelListViewController <DELEGATES> {

    NSUInteger storyId;
    NSUInteger threadId;
    Post *rootPost;

    NSIndexPath *selectedIndexPath;

	IBOutlet UIView *postViewContainer;
    IBOutlet UIWebView *postView;
    IBOutlet GrippyBar *grippyBar;
	IBOutlet UIBarButtonItem *orderByPostDateButton;
    NSUInteger grippyBarPosition;

    NSUInteger lastReplyId;
    BOOL highlightMyPost;
	BOOL orderByPostDate;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    UIPopoverController *popoverController;
#endif
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

- (NSString *)postBodyWithYoutubeWidgets:(NSString *)body;

- (void)refreshWithThreadId:(NSUInteger)threadId;

- (void)resetLayout;

@end
