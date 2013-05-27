//
//  SearchViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchResultsViewController.h"

@interface SearchViewController : UIViewController <UITextFieldDelegate> {
  IBOutlet UITableView *inputTable;
  IBOutlet UISegmentedControl *segmentedBar;
  
  UITextField *termsField;
  UITextField *authorField;
  UITextField *parentAuthorField;
}

- (IBAction)modeChanged;

- (IBAction)search;

@end
