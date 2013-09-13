//
//  SearchViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/20/09.
//  Copyright 2009. All rights reserved.
//

#import "SearchResultsViewController.h"

@interface SearchViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITableView *inputTable;
    IBOutlet UISegmentedControl *segmentedBar;
    IBOutlet UIView *recentSearchView;
    IBOutlet UIScrollView *recentSearchScrollView;
    
    UITextField *termsField;
    UITextField *authorField;
    UITextField *parentAuthorField;
    
    NSString *searchTerms;
    NSString *searchAuthor;
    NSString *searchParentAuthor;
}

- (IBAction)modeChanged;

- (IBAction)search;

@end
