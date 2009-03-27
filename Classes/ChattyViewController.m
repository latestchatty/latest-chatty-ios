//
//  ChattyViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ChattyViewController.h"


@implementation ChattyViewController

@synthesize storyId;
@synthesize threads;

- (id)initWithLatestChatty {
  [self initWithNibName:@"ChattyViewController" bundle:nil];
  
  self.title = @"";
  
  return self;
}

- (id)initWithStory:(Story *)story {
  [self initWithNibName:@"ChattyViewController" bundle:nil];
  
  self.storyId = story.modelId;
  self.title = story.title;
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                 target:self
                                                                                 action:@selector(tappedComposeButton:)];
  self.navigationItem.rightBarButtonItem = composeButton;
  [composeButton release];
}

- (IBAction)tappedComposeButton:(id)sender {
  ComposeViewController *viewController = [[ComposeViewController alloc] initWithStoryId:storyId post:nil];
  [self.navigationController presentModalViewController:viewController animated:YES];
  [viewController release];
}

- (IBAction)refresh:(id)sender {
  [super refresh:self];
  if (storyId)
    loader = [[Post findAllWithStoryId:self.storyId delegate:self] retain];
  else
    loader = [[Post findAllInLatestChattyWithDelegate:self] retain];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
  self.storyId = [[models objectAtIndex:0] storyId];
  self.threads = models;
  [self.tableView reloadData];
  [loader release];
  loader = nil;
  
  NSDictionary *dataDictionary = (NSDictionary *)otherData;
  self.storyId = [[dataDictionary objectForKey:@"storyId"] intValue];
  self.title   = [dataDictionary objectForKey:@"storyName"];
  
  [super didFinishLoadingAllModels:models otherData:otherData];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [threads count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"ThreadCell";
  
  ThreadCell *cell = (ThreadCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[ThreadCell alloc] init] autorelease];
  }
  
  // Set up the cell...
  cell.storyId = storyId;
  cell.rootPost = [threads objectAtIndex:indexPath.row];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [ThreadCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Post *thread = [threads objectAtIndex:indexPath.row];
  ThreadViewController *viewController = [[ThreadViewController alloc] initWithThreadId:thread.modelId];
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}


- (void)dealloc {
  NSLog(@"Dealloc ChattyViewController");
  [threads release];
  [super dealloc];
}


@end

