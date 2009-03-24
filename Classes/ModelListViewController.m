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

- (void)viewDidLoad {
  [super viewDidLoad];
  
  loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  loadingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  loadingView.userInteractionEnabled = NO;
  loadingView.alpha = 0.0;
  
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [spinner startAnimating];
  spinner.contentMode = UIViewContentModeCenter;
  spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 2.0/3.0);
  [loadingView addSubview:spinner];
  [spinner release];
  
  [self.view addSubview:loadingView];
  
  [self refresh:self];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.tableView flashScrollIndicators];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction)refresh:(id)sender {
  loadingView.alpha = 0.0;
  [UIView beginAnimations:@"LoadingViewFadeIn" context:nil];
  loadingView.alpha = 1.0;
  [UIView commitAnimations];
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
  return [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"tableCell"] autorelease];
}


// Fade in table cells
- (void)didFinishLoadingAllModels:(NSArray *)models {
  NSLog(@"loadingview alpha: %f", loadingView.alpha);
  loadingView.alpha = 1.0;
  [UIView beginAnimations:@"LoadingViewFadeOut" context:nil];
  loadingView.alpha = 0.0;
  [UIView commitAnimations];
  
  // Create cells
  [self.tableView reloadData];
  
  // Fade them in
  for (NSInteger i = 0; i < [[self.tableView visibleCells] count]; i++) {
    UITableViewCell *cell = [[self.tableView visibleCells] objectAtIndex:i];
    
    cell.alpha = 0.0;
    [UIView beginAnimations:[NSString stringWithFormat:@"FadeInStoriesTable_%i", i] context:nil];
    [UIView setAnimationDelay:0.05 * i];
    cell.alpha = 1.0;
    [UIView commitAnimations];
  }
}

- (void)didFinishLoadingModel:(id)aModel {
  [self didFinishLoadingAllModels:nil];
}


- (void)dealloc {
  [loader release];
  [loadingView release];
  [super dealloc];
}


@end

