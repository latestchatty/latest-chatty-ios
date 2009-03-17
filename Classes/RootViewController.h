//
//  RootViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelLoadingDelegate.h"
#import "Story.h"

@interface RootViewController : UITableViewController <ModelLoadingDelegate> {
  NSArray *stories;
}

@property (retain) NSArray *stories;

@end
