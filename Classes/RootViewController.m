//
//    RootViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/10/09.
//    Copyright 2009. All rights reserved.
//

#import "RootViewController.h"

#import "CustomBadge.h"

@implementation RootViewController

@synthesize selectedIndex;

- (id)init {
    self = [super initWithNib];
    self.title = @"Home";
    return self;
}

- (id)initWithStateDictionary:(NSDictionary *)dictionary {
    return [self init];
}

- (NSDictionary *)stateDictionary {
    return [NSDictionary dictionaryWithObject:@"Root" forKey:@"type"];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // only check for messages if it's been 5 minutes since the last check
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastMessageFetchDate = [defaults objectForKey:@"messageFetchDate"];
    NSTimeInterval interval = [lastMessageFetchDate timeIntervalSinceDate:[NSDate date]];

//    NSLog(@"%@", lastMessageFetchDate);
//    NSLog(@"%f", interval);
    
    // only check for messages if it's been 5 minutes since the last check
    if (interval == 0 || (interval * -1) > 60*5) {
        // fetch messages
        [[LatestChatty2AppDelegate delegate] setNetworkActivityIndicatorVisible:YES];
        messageLoader = [Message findAllWithDelegate:self];
    }
}

- (void)viewDidLoad {
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        // root view controller is delegate for view deck on iPhone
        self.viewDeckController.delegate = self;
        
        // initialize the index path to chatty row
        [self setSelectedIndex:[NSIndexPath indexPathForRow:1 inSection:0]];
        [self.tableView selectRowAtIndexPath:self.selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        // iOS7
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            [self.tableView setContentInset:UIEdgeInsetsMake(20.0, 0, 0, 0)];
        }
        
        // Maintain selection while view is still loaded
        [self setClearsSelectionOnViewWillAppear:NO];
    } else {
        [self setClearsSelectionOnViewWillAppear:YES];
    }
    
    // iOS7
    self.navigationController.navigationBar.translucent = NO;

    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sidebar-bg.png"]];
    self.tableView.backgroundView.contentMode = UIViewContentModeScaleToFill;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushBrowserForCredits) name:@"PushBrowserForCredits" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushBrowserForLicenses) name:@"PushBrowserForLicenses" object:nil];
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    // resign any showing keyboards
    [[LatestChatty2AppDelegate delegate].navigationController.visibleViewController.view endEditing:YES];
    
    // color the menu button blue
    if ([self centerControllerHasMenuButton:[LatestChatty2AppDelegate delegate].navigationController]) {
        [UIView animateWithDuration:0.3 animations:^{
            [[LatestChatty2AppDelegate delegate].navigationController.visibleViewController.navigationItem.leftBarButtonItem setTintColor:[UIColor lcBlueColor]];
        }];
    }
    
    // send notification to browser controller to show bars if controller on the stack
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBrowserBars" object:nil];
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController willCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated {
    // color the menu button back to white
    if ([self centerControllerHasMenuButton:[LatestChatty2AppDelegate delegate].navigationController]) {
        [UIView animateWithDuration:0.3 animations:^{
            [[LatestChatty2AppDelegate delegate].navigationController.visibleViewController.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        }];
    }
}

- (BOOL)centerControllerHasMenuButton:(UINavigationController *)navController {
    NSArray *classesWithMenuButton = @[[BrowserViewController class], [ChattyViewController class], [MessagesViewController class], [SearchViewController class], [StoriesViewController class]];
    for (Class cls in classesWithMenuButton) {
        if ([navController.visibleViewController isKindOfClass:cls]) {
            return YES;
        }
    }
    return NO;
}

- (void)pushBrowserForCredits {
    NSString *urlString = @"http://mccrager.com/latestchatty/credits";
    UIViewController *viewController =
    [[BrowserViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                                              title:@"Credits"
                                      isForShackLOL:NO];
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [[LatestChatty2AppDelegate delegate].contentNavigationController pushViewController:viewController animated:YES];
    } else {
        [[LatestChatty2AppDelegate delegate].navigationController pushViewController:viewController animated:YES];
    }
}

- (void)pushBrowserForLicenses {
    NSString *urlString = @"http://mccrager.com/latestchatty/licenses";
    UIViewController *viewController =
    [[BrowserViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                                              title:@"Licenses"
                                      isForShackLOL:NO];
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [[LatestChatty2AppDelegate delegate].contentNavigationController pushViewController:viewController animated:YES];
    } else {
        [[LatestChatty2AppDelegate delegate].navigationController pushViewController:viewController animated:YES];
    }

}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
    messageCount = 0;
    for (Message *message in models) {
        if (message.unread) messageCount++;
    }
    
//    if (messageCount > 0) {
//        UILocalNotification *messagesNotification = [[UILocalNotification alloc] init];
//        messagesNotification.alertBody = @"You have unread messages.";
//        [[UIApplication sharedApplication] scheduleLocalNotification:messagesNotification];
//    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:messageCount];
    
    // keep track if an index path had been selected, and reset it after the table is reloaded
    [self.tableView reloadData];
    [self.tableView selectRowAtIndexPath:self.selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [[LatestChatty2AppDelegate delegate] setNetworkActivityIndicatorVisible:NO];
    
    messageLoader = nil;
    
    // capture this successful messages fetch
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"messageFetchDate"];
    [defaults synchronize];
}

- (void)didFailToLoadModels {
    NSLog(@"Failed to load messages");
    [[LatestChatty2AppDelegate delegate] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        return 100;
    }
    if ([[UIScreen mainScreen] bounds].size.height == 568) return 90;
    return 80;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RootCell *cell = (RootCell *)[tableView dequeueReusableCellWithIdentifier:@"RootCell"];
    if (cell == nil) {
        cell = [[RootCell alloc] init];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.title = @"Stories";
            break;
            
        case 1:
            cell.title = @"LatestChatty";
            [cell setBadgeWithNumber:0];
			break;
            
        case 2:
            cell.title = @"Messages";    
            // set number of unread messages in badge of cell
//            messageCount = 9; // for testing
            [cell setBadgeWithNumber:messageCount];
            
            break;
            
        case 3:
            cell.title = @"Search";
            break;
            
        case 4:
            cell.title = @"Shack[lol]";
            break;
            
        case 5:
            cell.title = @"Settings";
            break;
            
        case 6:
            cell.title = @"About";
            break;
            
        default:
            [NSException raise:@"too many rows" format:@"This table can only have 5 cells!"];
            break;
    }

    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = nil;
    BOOL modal = NO;
    NSString *urlString;
    
    // save the index path selection if this isn't settings
    if (indexPath.row != 5) {
        [self setSelectedIndex:indexPath];
    }
    
    switch (indexPath.row) {
        case 0:
            viewController = [StoriesViewController controllerWithNib];
            //[UIAlertView showSimpleAlertWithTitle:@"Sorry" message:@"Stories are disabled for now.  They were broken by the shacknews.com redesign.  Check back soon!"];
            //[tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
            
        case 1:
            viewController = [ChattyViewController chattyControllerWithLatest];
            break;
            
        case 2:
            viewController = [MessagesViewController controllerWithNib];
            break;
            
        case 3:
            viewController = [SearchViewController controllerWithNib];
            
            if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                LatestChatty2AppDelegate *appDelegate = [LatestChatty2AppDelegate delegate];
                [appDelegate.contentNavigationController setViewControllers:[NSArray arrayWithObject:viewController]];
                viewController = nil;
            }
            break;
            
        case 4:
            // Pass user= on the URL for Shack[LOL] in Browser web view.
            urlString = [[NSString stringWithFormat:@"http://lol.lmnopc.com?lc_webview=1&user=%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"username"]] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            viewController = [[BrowserViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                                                                       title:nil
                                                               isForShackLOL:YES];
            
            if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                LatestChatty2AppDelegate *appDelegate = [LatestChatty2AppDelegate delegate];
                [appDelegate.contentNavigationController setViewControllers:[NSArray arrayWithObject:viewController]];
                viewController = nil;
            }
            break;
            
        case 5:
            modal = YES;
            viewController = [SettingsViewController controllerWithNib];

            // use the saved index path to re-select the previous index since settings selection should not persist as a modal
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.tableView selectRowAtIndexPath:self.selectedIndex animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            break;
            
        default:
            [NSException raise:@"too many rows" format:@"This table can only have 6 cells!"];
            break;
    }
    
    if (viewController) {
        if (modal) {
			if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                LatestChatty2AppDelegate *appDelegate = [LatestChatty2AppDelegate delegate];
				viewController.modalPresentationStyle = UIModalPresentationFormSheet;
                [appDelegate.slideOutViewController presentViewController:viewController animated:YES completion:nil];
			} else {
                [self.viewDeckController toggleLeftView];
                [self.viewDeckController presentViewController:viewController animated:YES completion:nil];
            }
        } else {
            if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                self.viewDeckController.centerController = [[UINavigationController alloc] initWithRootViewController:viewController];
                [LatestChatty2AppDelegate delegate].navigationController = (UINavigationController *)self.viewDeckController.centerController;
                [self.viewDeckController toggleLeftView];
            }
        }
    }
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
