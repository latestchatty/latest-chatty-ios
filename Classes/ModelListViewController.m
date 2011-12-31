//
//  ModelListViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ModelListViewController.h"


@implementation ModelListViewController

@synthesize tableView;

# pragma mark View Notifications

- (void)viewDidLoad {
  [super viewDidLoad];
  
  loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  loadingView.userInteractionEnabled = NO;
  loadingView.alpha = 0.0;
  loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [spinner startAnimating];
  spinner.contentMode = UIViewContentModeCenter;
  spinner.frame = CGRectMake(0, 0, self.view.frame.size.width -1, self.view.frame.size.height / 2.0 -1);
  spinner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [loadingView addSubview:spinner];
  [spinner release];
  
  [self.view addSubview:loadingView];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.tableView flashScrollIndicators];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return YES;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

# pragma mark Actions

- (IBAction)refresh:(id)sender {
  [loader cancel];
  [loader release];
  [self showLoadingSpinner];
}

#pragma mark Loading Spinner

- (void)showLoadingSpinner {
  loadingView.alpha = 0.0;
  [UIView beginAnimations:@"LoadingViewFadeIn" context:nil];
  loadingView.alpha = 1.0;
  [UIView commitAnimations];
}

- (void)hideLoadingSpinner {
  [UIView beginAnimations:@"LoadingViewFadeOut" context:nil];
  loadingView.alpha = 0.0;
  [UIView commitAnimations];
}

- (BOOL)loading {
  return loadingView.alpha > 0;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  // Override this method
    return [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
}


#pragma mark Data Loading Callbacks

// Fade in table cells
- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
  [self hideLoadingSpinner];
  
  // Create cells
  [self.tableView reloadData];
  
  // Fade them in
  for (UITableViewCell *cell in [self.tableView visibleCells]) {
    cell.alpha = 0.0;
    [UIView beginAnimations:[NSString stringWithFormat:@"FadeInStoriesTable_%@", [cell description]] context:nil];
    cell.alpha = 1.0;
    [UIView commitAnimations];
  }
}

- (void)didFinishLoadingModel:(id)aModel otherData:(id)otherData {
  [self didFinishLoadingAllModels:nil otherData:otherData];
}

- (void)didFailToLoadModels {
  [loader release];
  loader = nil;
  [self hideLoadingSpinner];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                  message:@"I could not connect to the server. Check your internet connection or you server address in your settings. Or try again later."
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];
}


#pragma mark Cleanup

- (void)dealloc {
  [loader release];
  [loadingView release];
  [super dealloc];
}


@end

