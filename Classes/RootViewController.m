//
//  RootViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (id)init {
  self = [self initWithNibName:@"RootViewController" bundle:nil];
  
  self.title = @"Home";
  
  return self;
}

- (id)initWithStateDictionary:(NSDictionary *)dictionary {
  return [self init];
}
- (NSDictionary *)stateDictionary {
  return [NSDictionary dictionaryWithObject:@"Root" forKey:@"type"];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewDidAppear:(BOOL)animated {
  messageLoader = [[Message findAllWithDelegate:self] retain];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
  messageCount = 0;
  for (Message *message in models) {
    if (message.unread) messageCount++;
  }
  
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:messageCount];
  [self.tableView reloadData];
  [messageLoader release];
  messageLoader = nil;
}

- (void)didFailToLoadModels {
  NSLog(@"Failed to load messages");
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 6;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  RootCell *cell = (RootCell *)[tableView dequeueReusableCellWithIdentifier:@"RootCell"];
  if (cell == nil) {
    cell = [[[RootCell alloc] init] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  }
  
  switch (indexPath.row) {
    case 0:
      cell.title = @"Stories"; break;
      
    case 1:
      cell.title = @"Latest Chatty"; break;
      
    case 2:
      if (messageCount > 0)
        cell.title = [NSString stringWithFormat:@"Messages (%i)", messageCount];
      else
        cell.title = @"Messages";
      break;
      
    case 3:
      cell.title = @"Search"; break;
      
    case 4:
      cell.title = @"Settings"; break;
      
    case 5:
      cell.title = @"About"; break;
      
    default:
      [NSException raise:@"too many rows" format:@"This table can only have 5 cells!"];
      break;
  }

  return (UITableViewCell *)cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  return [RootCell cellHeight];
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  id viewController = nil;
  BOOL modal = NO;
  
  switch (indexPath.row) {
    case 0:
      viewController = [[StoriesViewController alloc] init];
      break;
      
    case 1:
      viewController = [[ChattyViewController alloc] initWithLatestChatty];
      break;
      
    case 2:
      viewController = [[MessagesViewController alloc] init];
      break;
      
    case 3:
      viewController = [[SearchViewController alloc] init];
      break;
      
    case 4:
      modal = YES;
      viewController = [[SettingsViewController alloc] init];
      break;
      
    case 5:
      viewController = [[BrowserViewController alloc] initWithUrlString:[NSString stringWithFormat:@"http://%@/about", [[Model class] host]]];      
      break;
      
    default:
      [NSException raise:@"too many rows" format:@"This table can only have 6 cells!"];
      break;
  }
  
  if (viewController) {
    if (modal)
      [self.navigationController presentModalViewController:viewController animated:YES];
    else
      [self.navigationController pushViewController:viewController animated:YES];
      
    [viewController release];
  }
  
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
  [messageLoader release];
  [super dealloc];
}


@end

