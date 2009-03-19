//
//  ModelListViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelLoadingDelegate.h"


@interface ModelListViewController : UIViewController <ModelLoadingDelegate> {
  UIView *loadingView;
  IBOutlet UITableView *tableView;
}

@property (retain) UITableView *tableView;

- (IBAction)refresh:(id)sender;

@end
