//
//  RootViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009. All rights reserved.
//

#import "RootCell.h"

#import "Model.h"
#import "Message.h"

#import "StoriesViewController.h"
#import "ChattyViewController.h"
#import "MessagesViewController.h"
#import "SearchViewController.h"
#import "IIViewDeckController.h"

@interface RootViewController : UITableViewController <ModelLoadingDelegate, IIViewDeckControllerDelegate> {
    ModelLoader *messageLoader;
//    NSUInteger messageCount;
    NSIndexPath *selectedIndex;
}

@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end
