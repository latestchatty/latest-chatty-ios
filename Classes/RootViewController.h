//
//  RootViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKHelperKit.h"
#import "RootCell.h"

#import "Model.h"
#import "Message.h"

#import "StoriesViewController.h"
#import "ChattyViewController.h"
#import "MessagesViewController.h"
#import "SearchViewController.h"


@interface RootViewController : UITableViewController <ModelLoadingDelegate> {
  ModelLoader *messageLoader;
  NSUInteger messageCount;
}

@property (nonatomic, retain) UIActivityIndicatorView *messagesSpinner;

@end
