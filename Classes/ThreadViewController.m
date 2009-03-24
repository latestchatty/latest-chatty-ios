//
//  ThreadViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ThreadViewController.h"


@implementation ThreadViewController

@synthesize rootPost;

- (id)initWithThreadId:(NSUInteger)aThreadId {
  [super initWithNibName:@"ThreadViewController" bundle:nil];
  
  threadId = aThreadId;
  self.title = @"Thread";
  
  return self;
}

- (IBAction)refresh:(id)sender {
  [super refresh:sender];
  loader = [[Post findThreadWithId:threadId delegate:self] retain];
}

- (void)didFinishLoadingModel:(id)model {
  self.rootPost = (Post *)model;
  [loader release];
  loader = nil;
  
  [super didFinishLoadingAllModels:nil];
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [ReplyCell cellHeight];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
  return [[rootPost repliesArray] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
  static NSString *CellIdentifier = @"ReplyCell";
  
  ReplyCell *cell = (ReplyCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[ReplyCell alloc] init] autorelease];
  }
  
  cell.post = [[rootPost repliesArray] objectAtIndex:indexPath.row];
  NSLog(@"post id:%i", cell.post.modelId);

  return cell;
}


- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section {
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DropShadow.png"]];
  background.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 16);
  background.alpha = 0.75;
  return [background autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 16.0;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Post *post = [[rootPost repliesArray] objectAtIndex:indexPath.row];
  
  StringTemplate *htmlTemplate = [[StringTemplate alloc] initWithTemplateName:@"Post.html"];
  
  NSString *stylesheet = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Stylesheet.css" ofType:nil]];
  [htmlTemplate setString:stylesheet forKey:@"stylesheet"];
  [htmlTemplate setString:[Post formatDate:post.date] forKey:@"date"];
  [htmlTemplate setString:post.author forKey:@"author"];
  [htmlTemplate setString:post.body forKey:@"body"];
  
  [postView loadHTMLString:htmlTemplate.result baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://shacknews.com/laryn.x?id=%i", rootPost.modelId]]];
  [htmlTemplate release];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSString *url = [[request URL] absoluteString];
  if (navigationType == UIWebViewNavigationTypeLinkClicked) {
    if ([url isMatchedByRegex:@"shacknews\\.com/laryn\\.x\\?id=\\d+"]) {
      NSUInteger targetThreadId = [[url stringByMatching:@"shacknews\\.com/laryn\\.x\\?id=(\\d+)" capture:1] intValue];
      
      ThreadViewController *viewController = [[ThreadViewController alloc] initWithThreadId:targetThreadId];
      [self.navigationController pushViewController:viewController animated:YES];
      [viewController release];
      
    } else {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not implemented"
                                                      message:@"Web broswing is not yet implemented"
                                                     delegate:nil
                                            cancelButtonTitle:@"Dang it!"
                                            otherButtonTitles:nil];
      [alert show];
      [alert release];
    }
    return NO;
  }
  
  return YES;
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
  [rootPost release];
  [super dealloc];
}


@end

