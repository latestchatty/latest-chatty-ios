//
//  RootViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "StoriesViewController.h"
#import "LatestChatty2AppDelegate.h"


@implementation StoriesViewController

@synthesize stories;

- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  
  self.title = @"Shacknews Stories";
  
  return self;
};


- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem *latestChattyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ChatIcon.24.png"]
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(tappedLatestChattyButton:)];
  self.navigationItem.rightBarButtonItem = latestChattyButton;
  [latestChattyButton release];
  
  [Story findAllWithDelegate:self];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}
*/

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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didFinishLoadingModels:(NSArray *)models {
  self.stories = models;
  [self.tableView reloadData];
  
  for (UITableViewCell *cell in [self.tableView visibleCells]) cell.alpha = 0.0;
  [UIView beginAnimations:@"FadeInStoriesTable" context:nil];
  for (UITableViewCell *cell in [self.tableView visibleCells]) cell.alpha = 1.0;
  [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger count = 0;
  if (self.stories) count = [self.stories count];
  return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"StoryCell";
  
  StoryCell *cell = (StoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[StoryCell alloc] init] autorelease];
    [cell.chattyButton addTarget:self action:@selector(tappedChattyButton:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  // Set the story
  cell.story = [stories objectAtIndex:indexPath.row];

  return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [StoryCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Story *story = [stories objectAtIndex:indexPath.row];
  StoryViewController *viewController = [[StoryViewController alloc] initWithStory:story];
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

- (IBAction)tappedChattyButton:(id)sender {
  NSIndexPath *indexPath;
  for (StoryCell *cell in [self.tableView visibleCells]) {
    if (cell.chattyButton == sender)
      indexPath = [self.tableView indexPathForCell:cell];
  }
  
  Story *story = [stories objectAtIndex:indexPath.row];
  ChattyViewController *viewController = [[ChattyViewController alloc] initWithStory:story];
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

- (IBAction)tappedLatestChattyButton:(id)sender {
  ChattyViewController *viewController = [[ChattyViewController alloc] initWithLatestChatty];
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
  self.stories = nil;
  [super dealloc];
}


@end

