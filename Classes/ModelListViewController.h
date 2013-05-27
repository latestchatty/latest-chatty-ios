//
//  ModelListViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ModelLoadingDelegate.h"
#import "ModelLoader.h"

@interface ModelListViewController : UIViewController <ModelLoadingDelegate, UITableViewDelegate, UITableViewDataSource> {
  ModelLoader *loader;
  UIView *loadingView;
  IBOutlet UITableView *tableView;
}

@property (retain) UITableView *tableView;
@property (readonly) BOOL loading;

- (void)showLoadingSpinner;
- (void)hideLoadingSpinner;

- (IBAction)refresh:(id)sender;

@end
