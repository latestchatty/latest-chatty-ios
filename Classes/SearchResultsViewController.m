//
//    SearchResultsViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/21/09.
//    Copyright 2009. All rights reserved.
//

#import "SearchResultsViewController.h"

@implementation SearchResultsViewController

@synthesize posts, refreshControl;

- (id)initWithTerms:(NSString *)searchTerms author:(NSString *)searchAuthor parentAuthor:(NSString *)searchParentAuthor {
    self = [super initWithNib];
    
    self.title = @"Search Results";
    terms = searchTerms;
    author = searchAuthor;
    parentAuthor = searchParentAuthor;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh:self.refreshControl];
    
    self.tableView.hidden = YES;

    // replaced open source pull-to-refresh with native SDK refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor lightGrayColor]];
    
    [self.tableView addSubview:self.refreshControl];
    
    // iOS7
    self.navigationController.navigationBar.translucent = NO;
    
    // top separation bar
    UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
//        self.tableView.separatorColor = [UIColor lcSeparatorDarkColor];
//        self.tableView.backgroundColor = [UIColor lcTableBackgroundDarkColor];
//    } else {
//        self.tableView.separatorColor = [UIColor lcSeparatorColor];
//        self.tableView.backgroundColor = [UIColor lcTableBackgroundColor];
//    }
}

// handled popping back to search view when no results in both viewDidAppear and in didFinishLoadingAllModels
// because popping back to the search view immediately after the model finished with no results
// could sometimes occur before viewDidAppear fired causing a bad visual bug and warning in console
// capturing which finishes first and eval'ing that along with 0 results to let either method pop back
- (void)viewDidAppear:(BOOL)animated {
    if (modelFinished && self.posts.count == 0) {
        [UIAlertView showSimpleAlertWithTitle:@"Search"
                                      message:@"No results found for entered criteria."];
        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"popping back from viewDidAppear");
    }
    
    viewDidAppearFinished = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [loader cancel];
    [self.refreshControl endRefreshing];
}

- (void)refresh:(id)sender {
    [super refresh:sender];

    currentPage = 1;
    loader = [Post searchWithTerms:terms author:author parentAuthor:parentAuthor page:currentPage delegate:self];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {    
	if (currentPage <= 1) {
		self.posts = models;
	} else {
        NSMutableArray *mutableThreadsArray = [NSMutableArray arrayWithArray:self.posts];
        [mutableThreadsArray addObjectsFromArray:models];
        self.posts = mutableThreadsArray;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
	}
    
    lastPage = [[otherData objectForKey:@"lastPage"] intValue];

	[self.tableView reloadData];
	loader = nil;
  
    // Override super method so there is no fade if we are loading a second page.
	if (currentPage <= 1) {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
        
		[super didFinishLoadingAllModels:models otherData:otherData];
	} else {
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        } else {
            // Hide the loader
            [self hideLoadingSpinner];
        }
		
		// Refresh the table
		[self.tableView reloadData];
	}
    
    modelFinished = YES;
    
    if (viewDidAppearFinished && self.posts.count == 0) {
        [UIAlertView showSimpleAlertWithTitle:@"Search"
                                      message:@"No results found for entered criteria."];
        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"popping back from didFinishLoadingAllModels");
        return;
    }
    
    self.tableView.hidden = NO;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (currentPage < lastPage) return [posts count] + 1;
    return [posts count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [posts count]) {
        ThreadCell *cell = (ThreadCell *)[aTableView dequeueReusableCellWithIdentifier:@"ThreadCell"];
        if (cell == nil) cell = [[ThreadCell alloc] init];
        
        // Set up the cell...
        Post *post = [posts objectAtIndex:indexPath.row];
        post.pinned = NO;
        cell.storyId = post.storyId;
        cell.rootPost = post;
        cell.showCount = NO;
        
        return cell;
	} else {
		UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:self.tableView.frame];
        
        //checking posts count for 0, and returning a blank cell if it is
        //without this a cell is allocated with a spinner in it while the view is loading initially
        if ([posts count] == 0) {
            return cell;
        }
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10000, 0, 0)];
        
        UIView *selectionView = [[UIView alloc] initWithFrame:CGRectMake(cell.frameX, cell.frameY, cell.frameWidth, cell.frameHeight-1)];
        selectionView.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = selectionView;
        
        UIActivityIndicatorView *cellSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [cellSpinner setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [cellSpinner setCenter:cell.contentView.center];
        [cellSpinner setColor:[UIColor lightGrayColor]];        
        [cellSpinner startAnimating];
        [cell.contentView addSubview:cellSpinner];
        
		return cell;
	}
	
	return nil;
}

-(void)tableView:(UITableView *)_tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:_tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
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
    
    currentPage++;
    loader = [Post searchWithTerms:terms author:author parentAuthor:parentAuthor page:currentPage delegate:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [posts count]) {
        Post *post = [posts objectAtIndex:indexPath.row];
        
        ThreadViewController *viewController = [[ThreadViewController alloc] initWithThreadId:post.modelId];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [loader cancel];
    [self.refreshControl endRefreshing];
    
	if ([LatestChatty2AppDelegate delegate] != nil && [LatestChatty2AppDelegate delegate].contentNavigationController != nil) {
        [LatestChatty2AppDelegate delegate].contentNavigationController.delegate = nil;
    }
    
    tableView.delegate = nil;
}

@end
