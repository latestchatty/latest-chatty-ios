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
	if( self = [self initWithNibName:@"ChattyViewController" bundle:nil] ){
		self.storyId = 0;
		self.title = @"Loading...";
	}
	return self;
}

- (id)initWithStoryId:(NSUInteger)aStoryId {
	if( self = [self initWithNibName:@"ChattyViewController" bundle:nil] ){
		self.storyId = aStoryId;
		self.title = @"Loading...";
	}
	return self;
}



- (id)initWithStateDictionary:(NSDictionary *)dictionary {
	if( self = [self initWithStoryId:[[dictionary objectForKey:@"storyId"] intValue]] ){
		
		self.storyId = [[dictionary objectForKey:@"storyId"] intValue];
		self.threads = [dictionary objectForKey:@"threads"];
		self.title =   [dictionary objectForKey:@"title"];
		lastPage =     [[dictionary objectForKey:@"lastPage"] intValue];
		currentPage =  [[dictionary objectForKey:@"currentPage"] intValue];
		
		indexPathToSelect = [[dictionary objectForKey:@"selectedIndexPath"] retain];
	}
	return self;
}

- (NSDictionary *)stateDictionary {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Chatty", @"type",
									   [NSNumber numberWithInt:self.storyId], @"storyId",
									   threads, @"threads",
									   self.title, @"title",
									   [NSNumber numberWithInt:lastPage], @"lastPage",
									   [NSNumber numberWithInt:currentPage], @"currentPage", nil];
	
	NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
	if (selectedIndexPath) [dictionary setObject:selectedIndexPath forKey:@"selectedIndexPath"];
	
	return dictionary;
}



- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (threads == nil || [threads count] == 0) {
		[self refresh:self];
	} else {
		[self.tableView reloadData];
		if (indexPathToSelect) [self.tableView selectRowAtIndexPath:indexPathToSelect animated:NO scrollPosition:UITableViewScrollPositionTop];
	}
	
	UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
																				   target:self
																				   action:@selector(tappedComposeButton)];
	composeButton.enabled = (self.storyId > 0);
	self.navigationItem.rightBarButtonItem = composeButton;
	[composeButton release];
}

- (IBAction)tappedComposeButton {
	ComposeViewController *viewController = [[ComposeViewController alloc] initWithStoryId:storyId post:nil];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)refresh:(id)sender {
	[super refresh:self];
	currentPage = 1;
	
	if (storyId > 0)
		loader = [[Post findAllWithStoryId:self.storyId delegate:self] retain];
	else
		loader = [[Post findAllInLatestChattyWithDelegate:self] retain];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
	NSUInteger page = [[otherData objectForKey:@"page"] intValue];
	self.navigationItem.rightBarButtonItem.enabled = YES;
	NSLog(@"loaded to chattyview");
	BOOL hasPosts = [models count] > 0;
	
	if (page <= 1) {
		if (hasPosts) self.storyId = [[models objectAtIndex:0] storyId];
		self.threads = models;
	} else {
		NSMutableArray *newThreadsArray = [NSMutableArray arrayWithArray:self.threads];
		[newThreadsArray addObjectsFromArray:models];
		self.threads = newThreadsArray;
		[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
	}
	
	lastPage = [[otherData objectForKey:@"lastPage"] intValue];
	
	NSMutableDictionary* postHistoryDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PostCountHistory"]];
	
	// Filter Posts
	NSMutableArray *filteredThreads = [NSMutableArray array];
	for (Post *rootPost in self.threads) {
		NSString* modelID = [NSString stringWithFormat:@"%d", rootPost.modelId];
		NSNumber* numPosts = [postHistoryDict objectForKey:modelID];
		if( numPosts ){
			rootPost.newReplies = rootPost.replyCount-[numPosts intValue];
		}
		else rootPost.newReplies = rootPost.replyCount;
		
		[postHistoryDict setObject:[NSNumber numberWithInt:rootPost.replyCount] forKey:modelID];
		if ([rootPost.category isEqualToString:@"ontopic"]) {
			[filteredThreads addObject:rootPost];
		} else if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"postCategory.%@", rootPost.category]]) {
			[filteredThreads addObject:rootPost];
		}
	}
	self.threads = filteredThreads;
	
	[[NSUserDefaults standardUserDefaults] setValue:[postHistoryDict autorelease] forKey:@"PostCountHistory"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	
	[self.tableView reloadData];
	[loader release];
	loader = nil;
	
	NSDictionary *dataDictionary = (NSDictionary *)otherData;
	self.storyId = [[dataDictionary objectForKey:@"storyId"] intValue];
	self.title   = [dataDictionary objectForKey:@"storyName"];
	
	// Override super method so there is no fade if we are loading a second page.
	if (page <= 1) {
		[super didFinishLoadingAllModels:models otherData:otherData];
	} else {
		// Hide the loader
		[self hideLoadingSpinner];
		
		// Refresh the table
		[self.tableView reloadData];
		
		// Scroll the table so that the first thread from the next page is at the top of the screen
		NSUInteger firstThreadIndex = [self.threads indexOfObject:[models objectAtIndex:0]];
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:firstThreadIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
	
	// Record this refresh
	if (hasPosts) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSUInteger oldLastRefresh = [defaults integerForKey:@"lastRefresh"];
		NSUInteger newLastRefresh = [[models objectAtIndex:0] lastReplyId];
		if (newLastRefresh > oldLastRefresh)
			[defaults setInteger:newLastRefresh forKey:@"lastRefresh"];
	}
	
	
	//login to shack - the cookie expires after 30 days
	//but we might as well reset it on every refresh
	//And this is how we check for the modflag
	NSLog(@"logging in - checking mod cookie");
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* usernameString = [[defaults stringForKey:@"username"] stringByUrlEscape];
	NSString* passwordString = [[defaults stringForKey:@"password"] stringByUrlEscape];
	NSString* myRequestString = [NSString stringWithFormat:@"username=%@&password=%@", usernameString, passwordString];
	NSHTTPURLResponse * response;
	NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
	NSData *data;
	NSError * error;
	NSMutableURLRequest *request;
	request=[[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.shacknews.com/login.x"]
										  cachePolicy:NSURLRequestReloadIgnoringCacheData 
									  timeoutInterval:60] autorelease];
	[request setHTTPMethod: @"POST" ];
	[request setHTTPBody:myRequestData];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	

	request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.shacknews.com/mod_laryn.x"]
											cachePolicy:NSURLRequestReloadIgnoringCacheData 
										timeoutInterval:60] autorelease];
	data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];	
	//seems necessary to set the cookies, odd but oh well
	NSArray *all = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:[NSURL URLWithString:@"www.shacknews.com"]];
	NSString *modResult = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
	if([modResult rangeOfString:@"Invalid moderation flags"].location != NSNotFound){
		[defaults setBool:YES forKey:@"modFlag"];		
	}else{
		[defaults setBool:NO forKey:@"modFlag"];
	}
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (currentPage < lastPage) return [threads count] + 1;
	return [threads count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [threads count]) {
		ThreadCell *cell = (ThreadCell *)[aTableView dequeueReusableCellWithIdentifier:@"ThreadCell"];
		if (cell == nil) {
			cell = [[[ThreadCell alloc] init] autorelease];
		}
		
		// Set up the cell...
		cell.storyId = storyId;
		cell.rootPost = [threads objectAtIndex:indexPath.row];    
		
		return cell;
	} else {
		UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
		cell.text = @"Load More";
		cell.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
		cell.textAlignment = UITextAlignmentCenter;
		return [cell autorelease];
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ThreadCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [threads count]) {
		Post *thread = [threads objectAtIndex:indexPath.row];
		ThreadViewController *viewController = [[ThreadViewController alloc] initWithThreadId:thread.modelId];
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	} else {
		[self showLoadingSpinner];
		[loader cancel];
		[loader release];
		currentPage++;
		loader = [[Post findAllWithStoryId:storyId pageNumber:currentPage delegate:self] retain];
	}
}


- (void)dealloc {
	NSLog(@"Dealloc ChattyViewController");
	[threads release];
	[super dealloc];
}


@end

