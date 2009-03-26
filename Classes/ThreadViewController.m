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
  
  // Find the target post in the thread.
  Post *firstPost;
  if (rootPost.modelId == threadId) {
    firstPost = rootPost;
  } else {
    for (Post *reply in [rootPost repliesArray]) {
      if (reply.modelId == threadId) firstPost = reply;
    }
  }
  
  // Select and display the targeted post
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[rootPost repliesArray] indexOfObject:firstPost] inSection:0];
  if (indexPath == nil) indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem *replyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                                               target:self
                                                                               action:@selector(tappedReplyButton)];
  self.navigationItem.rightBarButtonItem = replyButton;
  [replyButton release];
}

- (IBAction)tappedReplyButton {
  NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
  Post *post = [[rootPost repliesArray] objectAtIndex:indexPath.row];
  
  ComposeViewController *viewController = [[ComposeViewController alloc] initWithStoryId:0 post:post];
  [self.navigationController presentModalViewController:viewController animated:YES];
  [viewController release];
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
  NSLog(@"loading...");
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

- (void)grippyBarDidSwipeUp {
  [UIView beginAnimations:@"ShrinkPostView" context:nil];
  CGFloat usableHeight = self.view.frame.size.height - 24.0;
  
  // Expand post view
  postView.frame = CGRectMake(postView.frame.origin.x,
                              postView.frame.origin.y,
                              postView.frame.size.width,
                              floor(usableHeight / 2));
  
  // move grippy bar
  grippyBar.frame = CGRectMake(grippyBar.frame.origin.x,
                               floor(usableHeight / 2),
                               grippyBar.frame.size.width,
                               grippyBar.frame.size.height);
  
  // Shrink thread table
  tableView.frame = CGRectMake(tableView.frame.origin.x,
                               floor(usableHeight / 2) + 24,
                               tableView.frame.size.width,
                               floor(usableHeight / 2));
  
  [UIView commitAnimations];
}

- (void)grippyBarDidSwipeDown {
  [UIView beginAnimations:@"ExpandPostView" context:nil];
  CGFloat usableHeight = self.view.frame.size.height - 24.0;
  
  // Expand post view
  postView.frame = CGRectMake(postView.frame.origin.x,
                              postView.frame.origin.y,
                              postView.frame.size.width,
                              floor(usableHeight * 4.0/5.0));
    
  // move grippy bar
  grippyBar.frame = CGRectMake(grippyBar.frame.origin.x,
                               floor(usableHeight * 4.0/5.0),
                               grippyBar.frame.size.width,
                               grippyBar.frame.size.height);
  
  // Shrink thread table
  tableView.frame = CGRectMake(tableView.frame.origin.x,
                               floor(usableHeight * 4.0/5.0) + 24,
                               tableView.frame.size.width,
                               floor(usableHeight * 1.0/5.0));
  
  [UIView commitAnimations];
}

- (void)grippyBarDidSwipeRight {
  NSIndexPath *oldIndexPath = [tableView indexPathForSelectedRow];
  
  NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:oldIndexPath.row + 1 inSection:0];
  if (oldIndexPath.row == [[rootPost repliesArray] count] - 1) newIndexPath = oldIndexPath;
  
  [tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  [self tableView:tableView didSelectRowAtIndexPath:newIndexPath];
}

- (void)grippyBarDidSwipeLeft {
  NSIndexPath *oldIndexPath = [tableView indexPathForSelectedRow];
  
  NSIndexPath *newIndexPath;
  if (oldIndexPath.row == 0)
    newIndexPath = oldIndexPath;
  else
    newIndexPath = [NSIndexPath indexPathForRow:oldIndexPath.row - 1 inSection:0];
  
  [tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  [self tableView:tableView didSelectRowAtIndexPath:newIndexPath];  
}

- (void)dealloc {
  [rootPost release];
  [super dealloc];
}


@end

