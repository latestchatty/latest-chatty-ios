//
//  MessagesViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelListViewController.h"
#import "MessageCell.h"
#import "Message.h"
#import "MessageViewController.h"

@interface MessagesViewController : ModelListViewController {
  NSMutableArray *messages;
}

@property (retain) NSMutableArray *messages;

@end
