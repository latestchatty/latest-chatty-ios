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
}

- (IBAction)refresh:(id)sender {
  [super refresh:sender];
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


- (void)didFinishLoadingModels:(NSArray *)models {
  self.stories = models;
  [super didFinishLoadingModels:models];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

#pragma mark Shake Handler

// FIXME: This never gets called
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//  NSLog(@"Shook!");
//  if (motion == UIEventSubtypeMotionShake) [self refresh:self];
//}

#pragma mark Table view methods

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger count = 0;
  if (self.stories) count = [self.stories count];
  return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"StoryCell";
  
  StoryCell *cell = (StoryCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
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

- (void)dealloc {
  self.stories = nil;
  [super dealloc];
}


@end

