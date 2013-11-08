//
//  MessagesViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009. All rights reserved.
//

#import "ModelListViewController.h"
#import "MessageCell.h"
#import "Message.h"
#import "MessageViewController.h"

@interface MessagesViewController : ModelListViewController {
    NSMutableArray *messages;
}

@property (strong) NSMutableArray *messages;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)composeMessage;

@end
