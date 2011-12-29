//
//    SearchResultsViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/21/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "UIViewController+HelperKit.h"


@implementation SearchResultsViewController

@synthesize posts;
@synthesize pull;

- (id)initWithTerms:(NSString *)searchTerms author:(NSString *)searchAuthor parentAuthor:(NSString *)searchParentAuthor {
    self = [super initWithNib];
    
    self.title = @"Search Results";
    terms = [searchTerms retain];
    author = [searchAuthor retain];
    parentAuthor = [searchParentAuthor retain];
    
    return self;
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view{
    [self refresh:self];
    [pull finishedLoading];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh:self];

    pull = [[PullToRefreshView alloc] initWithScrollView:self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];
    [pull finishedLoading];
}

- (IBAction)refresh:(id)sender {
    [super refresh:sender];
    loader = [[Post searchWithTerms:terms author:author parentAuthor:parentAuthor delegate:self] retain];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {    
    self.posts = models;
    [loader release];
    loader = nil;
    [super didFinishLoadingAllModels:nil otherData:otherData];
    [tableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [posts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThreadCell *cell = (ThreadCell *)[aTableView dequeueReusableCellWithIdentifier:@"ThreadCell"];
    if (cell == nil) cell = [[[ThreadCell alloc] init] autorelease];
    
    // Set up the cell...
    Post *post = [posts objectAtIndex:indexPath.row];
    cell.storyId = post.storyId;
    cell.rootPost = post;
    cell.showCount = NO;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [posts objectAtIndex:indexPath.row];
    
    ThreadViewController *viewController = [[ThreadViewController alloc] initWithThreadId:post.modelId];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


- (void)dealloc {
    self.posts = nil;
    [terms release];
    [author release];
    [parentAuthor release];
    [pull release];
    [super dealloc];
}


@end

