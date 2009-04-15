//
//  MessagesViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MessagesViewController.h"


@implementation MessagesViewController

@synthesize messages;

- (id)init {
  self = [self initWithNibName:@"MessagesViewController" bundle:nil];
  
  self.title = @"Messages";
  
  return self;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidLoad {
  [super viewDidLoad];
  [self refresh:self];
}

- (IBAction)refresh:(id)sender {
  [super refresh:self];
  loader = [[Message findAllWithDelegate:self] retain];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
  self.messages = [NSMutableArray arrayWithArray:models];
  [self.tableView reloadData];
  
  [loader release];
  loader = nil;
  
  [super didFinishLoadingAllModels:models otherData:otherData];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [messages count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
  if (cell == nil) {
    cell = [[[MessageCell alloc] init] autorelease];
  }
  
  cell.message = [messages objectAtIndex:indexPath.row];

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Message *message = [messages objectAtIndex:indexPath.row];
  [message markRead];
  
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

- (void)dealloc {
  [super dealloc];
}


@end

