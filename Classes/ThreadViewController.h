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
#import "ReplyCell.h"
#import "StringTemplate.h"
#import "RegexKitLite.h"
#import "GrippyBar.h"
#import "ComposeViewController.h"
#import "BrowserViewController.h"

@interface ThreadViewController : ModelListViewController <UIWebViewDelegate, GrippyBarDelegate> {
  NSUInteger storyId;
  NSUInteger threadId;
  Post *rootPost;
  
  NSIndexPath *selectedIndexPath;
  
  IBOutlet UIWebView *postView;
  IBOutlet GrippyBar *grippyBar;
}

@property (retain) Post *rootPost;
@property (retain) NSIndexPath *selectedIndexPath;

- (id)initWithThreadId:(NSUInteger)aThreadId;
- (IBAction)tappedReplyButton;

@end
