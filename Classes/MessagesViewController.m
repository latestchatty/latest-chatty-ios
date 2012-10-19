//
//    MessagesViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/10/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MessagesViewController.h"
#import "SendMessageViewController.h"
#import "LatestChatty2AppDelegate.h"

@implementation MessagesViewController

@synthesize messages, pull;

- (id)initWithNib {
    self = [super initWithNib];

    self.title = @"Loading...";
    
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return YES;
    return YES;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh:self];
	UIBarButtonItem *composeButton = [UIBarButtonItem itemWithSystemType:UIBarButtonSystemItemCompose target:self action:@selector(composeMessage)];
    composeButton.enabled = NO;
	self.navigationItem.rightBarButtonItem = composeButton;
    
    pull = [[PullToRefreshView alloc] initWithScrollView:self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];
    [pull finishedLoading];
}

- (void)composeMessage {
	SendMessageViewController *sendMessageViewController = [SendMessageViewController controllerWithNib];
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [LatestChatty2AppDelegate delegate].contentNavigationController.viewControllers = [NSArray arrayWithObject:sendMessageViewController];
    } else {
        [self.navigationController pushViewController:sendMessageViewController animated:YES];
    }
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view{
    NSLog(@"Pull?");
    [self refresh:self];
    [pull finishedLoading];
}

- (IBAction)refresh:(id)sender {
    [super refresh:self];
    loader = [[Message findAllWithDelegate:self] retain];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
    self.messages = [NSMutableArray arrayWithArray:models];
    [self.tableView reloadData];
    
    [loader release];
    loader = nil;
    
    [super didFinishLoadingAllModels:models otherData:otherData];
	[self layoutCellsForOrientation:[self interfaceOrientation]];
    
    self.title = @"Messages";
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)didFailToLoadModels {
    [UIAlertView showSimpleAlertWithTitle:@"Error"
                                  message:@"Could not retrieve your messages.    "
                                          @"Check your internet connection, or your username and password in Settings"];
}


- (void)layoutCellsForOrientation:(UIInterfaceOrientation)orientation {		
	for (UIView *subView in [tableView subviews]) {
		if(![subView isKindOfClass:[MessageCell class]]) continue;
		MessageCell *cell = (MessageCell *)subView;
		CGRect cellFrame = cell.frame;

		cell.previewLabel.frame = CGRectMake(10, 30, cellFrame.size.width - 30, 42);
		cell.subjectLabel.frame = CGRectMake(10, 18, cellFrame.size.width - 30, 18);
		cell.dateLabel.frame = CGRectMake(cellFrame.size.width - 137, 0, 112, 21);
	}
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self layoutCellsForOrientation:toInterfaceOrientation];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messages count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = (MessageCell*)[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (cell == nil) {
        cell = [[[MessageCell alloc] init] autorelease];
    }
	
    cell.message = [messages objectAtIndex:indexPath.row];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [messages objectAtIndex:indexPath.row];
    [message markRead];
    MessageViewController *viewController = [[[MessageViewController alloc] initWithMesage:message] autorelease];
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [LatestChatty2AppDelegate delegate].contentNavigationController.viewControllers = [NSArray arrayWithObject:viewController];
    } else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)dealloc {
    self.messages = nil;
    [pull release];
    [super dealloc];
}


@end

