//
//  ModelListViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelLoadingDelegate.h"
#import "ModelLoader.h"

@interface ModelListViewController : UIViewController <ModelLoadingDelegate> {
  ModelLoader *loader;
  UIView *loadingView;
  IBOutlet UITableView *tableView;
}

@property (retain) UITableView *tableView;

- (IBAction)refresh:(id)sender;

@end
