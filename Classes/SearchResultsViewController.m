//
//    SearchResultsViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/21/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "UIViewController+HelperKit.h"

#import "LatestChatty2AppDelegate.h"

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

    currentPage = 1;
    loader = [[Post searchWithTerms:terms author:author parentAuthor:parentAuthor page:currentPage delegate:self] retain];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {    
	if (currentPage <= 1) {
		self.posts = models;
	} else {
        NSMutableArray *mutableThreadsArray = [NSMutableArray arrayWithArray:self.posts];
        [mutableThreadsArray addObjectsFromArray:models];
        self.posts = mutableThreadsArray;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
	}

	[self.tableView reloadData];
	[loader release];
	loader = nil;
  
    // Override super method so there is no fade if we are loading a second page.
	if (currentPage <= 1) {
		[super didFinishLoadingAllModels:models otherData:otherData];
	} else {
		// Hide the loader
		[self hideLoadingSpinner];
		
		// Refresh the table
		[self.tableView reloadData];
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([posts count] % 15 == 0) return [posts count] + 1;
    return [posts count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [posts count]) {
        ThreadCell *cell = (ThreadCell *)[aTableView dequeueReusableCellWithIdentifier:@"ThreadCell"];
        if (cell == nil) cell = [[[ThreadCell alloc] init] autorelease];
        
        // Set up the cell...
        Post *post = [posts objectAtIndex:indexPath.row];
        cell.storyId = post.storyId;
        cell.rootPost = post;
        cell.showCount = NO;
        
        return cell;
	} else {
		UITableViewCell *cell                = [[[UITableViewCell alloc] initWithFrame:self.tableView.frame] autorelease];
        
        //checking posts count for 0, and returning a blank cell if it is
        //without this a cell is allocated with a spinner in it while the view is loading initially
        if ([posts count] == 0) {
            return cell;
        }
        
        UIActivityIndicatorView *cellSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [cell.contentView addSubview:cellSpinner];
        
        [cellSpinner setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [cellSpinner setCenter:cell.contentView.center];
        [cellSpinner startAnimating];
        
        [cellSpinner release];
		return cell;
	}
	
	return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //checking posts count for 0, and returning if it is
    //without this the view fires off the initial load request and a loadMorePosts, and continually fires loadMorePosts when a search doesn't results in any posts being returned
    if ([posts count] == 0) {
        return;
    }
    
    if (indexPath.row == [posts count]) {
        [self loadMorePosts];
    }
}

-(void)loadMorePosts {
    [loader cancel];
    [loader release];
    currentPage++;
    loader = [[Post searchWithTerms:terms author:author parentAuthor:parentAuthor page:currentPage delegate:self] retain];
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
