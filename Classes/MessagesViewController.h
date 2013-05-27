//
//  MessagesViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ModelListViewController.h"
#import "MessageCell.h"
#import "Message.h"
#import "MessageViewController.h"
#import "PullToRefreshView.h"

@interface MessagesViewController : ModelListViewController <PullToRefreshViewDelegate> {
  NSMutableArray *messages;
}

@property (retain) NSMutableArray *messages;

- (void)composeMessage;

@property (nonatomic, retain) PullToRefreshView *pull;

@end
