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

@interface ThreadViewController : ModelListViewController <UIWebViewDelegate, GrippyBarDelegate> {
  NSUInteger threadId;
  Post *rootPost;
  
  IBOutlet UIWebView *postView;
  IBOutlet GrippyBar *grippyBar;
}

@property (retain) Post *rootPost;

- (id)initWithThreadId:(NSUInteger)aThreadId;

@end
