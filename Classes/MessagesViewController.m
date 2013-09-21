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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon.24.png"]
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self.viewDeckController
                                                                      action:@selector(toggleLeftView)];
        self.navigationItem.leftBarButtonItem = menuButton;
    }
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isPresent] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] isPresent]) {
        [UIAlertView showSimpleAlertWithTitle:@"Not Logged In" message:@"Please head back to the main menu and tap \"Settings\" to set your Shacknews.com username and password"];
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self refresh:self.refreshControl];
    
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PenIcon.24.png"]
                                                                      style:UIBarButtonItemStyleBordered
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.tableView.separatorColor = [UIColor lcSeparatorDarkColor];
        self.tableView.backgroundColor = [UIColor lcTableBackgroundDarkColor];
    } else {
        self.tableView.separatorColor = [UIColor lcSeparatorColor];
        self.tableView.backgroundColor = [UIColor lcTableBackgroundColor];
    }
}

- (NSUInteger)supportedInterfaceOrientations {
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
    
    if (self.messages.count == 0) {
        [UIAlertView showSimpleAlertWithTitle:@"Messages"
                                      message:@"No messages found."];
        return;
    }
    
    self.tableView.hidden = NO;
}

- (void)didFailToLoadModels {
    [UIAlertView showSimpleAlertWithTitle:@"Error"
                                  message:@"Could not retrieve your messages."
                                          @"Check your internet connection, or your username and password in Settings"];
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
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [LatestChatty2AppDelegate delegate].contentNavigationController.viewControllers = [NSArray arrayWithObject:viewController];
    } else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
}

@end
