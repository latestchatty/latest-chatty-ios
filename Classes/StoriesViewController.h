//
//  RootViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009. All rights reserved.
//

#import "ModelListViewController.h"
#import "ModelLoadingDelegate.h"

#import "ModelLoader.h"
#import "Story.h"
#import "Post.h"

#import "StoryCell.h"

#import "ChattyViewController.h"
#import "StoryViewController.h"
#import "SettingsViewController.h"

@interface StoriesViewController : ModelListViewController {
    NSArray *stories;
}

@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (id)initWithStateDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)stateDictionary;

//- (IBAction)tappedChattyButton:(id)sender;
//- (IBAction)tappedLatestChattyButton;

@end
