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

@interface ThreadViewController : ModelListViewController <UIWebViewDelegate, GrippyBarDelegate, UIActionSheetDelegate> {
  NSUInteger storyId;
  NSUInteger threadId;
  Post *rootPost;
  
  NSIndexPath *selectedIndexPath;
  
  IBOutlet UIWebView *postView;
  IBOutlet GrippyBar *grippyBar;
  NSUInteger grippyBarPosition;
  
  NSUInteger lastReplyId;
  BOOL highlightMyPost;
}

@property (retain) Post *rootPost;
@property (retain) NSIndexPath *selectedIndexPath;

- (id)initWithThreadId:(NSUInteger)aThreadId;
- (IBAction)tappedReplyButton;
- (NSString *)postBodyWithYoutubeWidgets:(NSString *)body;

- (void)resetLayout;

@end
