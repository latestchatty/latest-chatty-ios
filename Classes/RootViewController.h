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
#import "SloppySwiper.h"

@interface RootViewController : UITableViewController <ModelLoadingDelegate, IIViewDeckControllerDelegate> {
    ModelLoader *messageLoader;
    BOOL initialPhoneLoad;
    NSIndexPath *selectedIndex;
}

@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (strong, nonatomic) SloppySwiper *swiper;

@end
