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
@interface ThreadViewController : ModelListViewController <UIWebViewDelegate, GrippyBarDelegate, UIActionSheetDelegate, UISplitViewControllerDelegate> {
#else
@interface ThreadViewController : ModelListViewController <UIWebViewDelegate, GrippyBarDelegate, UIActionSheetDelegate> {
#endif
    NSUInteger storyId;
    NSUInteger threadId;
    Post *rootPost;

    NSIndexPath *selectedIndexPath;

	IBOutlet UIView *postViewContainer;
    IBOutlet UIWebView *postView;
    IBOutlet GrippyBar *grippyBar;
    NSUInteger grippyBarPosition;

    NSUInteger lastReplyId;
    BOOL highlightMyPost;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    UIPopoverController *popoverController;
#endif
    UIToolbar *toolbar;
}

@property (nonatomic, assign) NSUInteger threadId;
@property (retain) Post *rootPost;
@property (retain) NSIndexPath *selectedIndexPath;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

- (id)initWithThreadId:(NSUInteger)aThreadId;

- (IBAction)tappedReplyButton;
- (IBAction)refresh:(id)sender;
- (IBAction)tag;
- (IBAction)previous;
- (IBAction)next;


- (NSString *)postBodyWithYoutubeWidgets:(NSString *)body;

- (void)refreshWithThreadId:(NSUInteger)threadId;

- (void)resetLayout;

@end
