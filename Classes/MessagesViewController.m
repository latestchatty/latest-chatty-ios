//
//    MessagesViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/10/09.
//    Copyright 2009. All rights reserved.
//

#import "MessagesViewController.h"

#import "SendMessageViewController.h"

@implementation MessagesViewController

@synthesize messages, refreshControl;

- (id)initWithNib {
    self = [super initWithNib];

    self.title = @"Loading...";
    
    return self;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    if ([self.presentedViewController isKindOfClass:[MessageViewController class]]) {
        return nil;
    }
    
    CGPoint cellPostion = [self.tableView convertPoint:location fromView:self.view];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cellPostion];
    
    if (indexPath) {
        UITableViewCell *tableCell = [self.tableView cellForRowAtIndexPath:indexPath];
        Message *message = [messages objectAtIndex:indexPath.row];
        MessageViewController *previewController = [[MessageViewController alloc] initWithMesage:message];
        previewingContext.sourceRect = [self.view convertRect:tableCell.frame fromView:self.tableView];
        
        return previewController;
    }
    
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[LatestChatty2AppDelegate delegate] isForceTouchEnabled]) {
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
    }
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice] &&
        self.navigationController.viewControllers.count == 1) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu-Button-List.png"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self.viewDeckController
                                                                      action:@selector(toggleLeftView)];
        self.navigationItem.leftBarButtonItem = menuButton;
    }
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isPresent] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] isPresent]) {
        return;
    }
    
    [self refresh:self.refreshControl];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu-Button-Compose.png"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(composeMessage)];
    composeButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = composeButton;
    
    self.tableView.hidden = YES;

    // new native pull to refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                       action:@selector(refresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.refreshControl setTintColor:[UIColor lightGrayColor]];
    
    [self.tableView addSubview:self.refreshControl];
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        // top separation bar, iPhone only in this view
        UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
        [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
        [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self.view addSubview:topStroke];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isPresent] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] isPresent]) {
        [UIAlertView showSimpleAlertWithTitle:@"Not Logged In"
                                      message:@"Enter your username and password in Settings."];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        self.title = @"Messages";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [loader cancel];
    [self.refreshControl endRefreshing];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)composeMessage {
	SendMessageViewController *sendMessageViewController = [SendMessageViewController controllerWithNib];
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [LatestChatty2AppDelegate delegate].contentNavigationController.viewControllers = [NSArray arrayWithObject:sendMessageViewController];
    } else {
        [self.navigationController pushViewController:sendMessageViewController animated:YES];
    }
}

- (void)refresh:(id)sender {
    [super refresh:sender];
    loader = [Message findAllWithDelegate:self];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
    self.messages = [NSMutableArray arrayWithArray:models];
    [self.tableView reloadData];
    
    loader = nil;
    
    [super didFinishLoadingAllModels:models otherData:otherData];
    
    self.title = @"Messages";
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [self.refreshControl endRefreshing];
    
    // total up the unread messages
    NSUInteger messageCount = 0;
    for (Message *message in models) {
        if (message.unread) messageCount++;
    }
    
    // save the updated message count
    [[NSUserDefaults standardUserDefaults] setInteger:messageCount forKey:@"messageCount"];
    // reflect the unread count on the app badge
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:messageCount];
    
//    NSLog(@"Message Count saved: %i", messageCount);
    
    if (self.messages.count == 0) {
        [UIAlertView showSimpleAlertWithTitle:@"Messages"
                                      message:@"No messages found."];
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
    return [messages count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = (MessageCell*)[tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    if (cell == nil) {
        cell = [[MessageCell alloc] init];
    }
	
    cell.message = [messages objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [messages objectAtIndex:indexPath.row];
    [message markRead];
    MessageViewController *viewController = [[MessageViewController alloc] initWithMesage:message];
    
    // mark the message read in the local data to reflect in the table
    message.unread = NO;
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [LatestChatty2AppDelegate delegate].contentNavigationController.viewControllers = [NSArray arrayWithObject:viewController];
    } else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(void)tableView:(UITableView *)_tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:_tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [loader cancel];
    [self.refreshControl endRefreshing];
    
	if ([LatestChatty2AppDelegate delegate] != nil && [LatestChatty2AppDelegate delegate].contentNavigationController != nil) {
        [LatestChatty2AppDelegate delegate].contentNavigationController.delegate = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    tableView.delegate = nil;
}

@end
