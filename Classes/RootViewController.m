//
//    RootViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/10/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "CustomBadge.h"

@implementation RootViewController

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
    return [LatestChatty2AppDelegate supportedInterfaceOrientationsWithController:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation withController:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.messagesSpinner startAnimating];
    messageLoader = [[Message findAllWithDelegate:self] retain];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
    messageCount = 0;
    for (Message *message in models) {
        if (message.unread) messageCount++;
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:messageCount];
    [self.tableView reloadData];
    [self.messagesSpinner stopAnimating];
    
    [messageLoader release];
    messageLoader = nil;
}

- (void)didFailToLoadModels {
    NSLog(@"Failed to load messages");
    [self.messagesSpinner stopAnimating];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RootCell *cell = (RootCell *)[tableView dequeueReusableCellWithIdentifier:@"RootCell"];
    if (cell == nil) {
        cell = [[[RootCell alloc] init] autorelease];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.title = @"Stories";
            break;
            
        case 1:
            cell.title = @"LatestChatty";
			break;
            
        case 2:
            // add activity spinner to messages cell that starts spinning when messages are loading and stops when the messages call has finished
            [self setMessagesSpinner:[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
            int center = [cell iconImage].frameHeight / 2; //vertical center
            CGFloat spinnerSize = 25.0f;
            // place spinner on top of messages icon
            [self.messagesSpinner setFrame:CGRectMake(center - spinnerSize / 2, center - spinnerSize / 2, spinnerSize, spinnerSize)];
            [[cell iconImage] addSubview:self.messagesSpinner];
            [self.messagesSpinner release];
            
            if (messageCount > 0) {
                //cell.title = [NSString stringWithFormat:@"Messages (%i)", messageCount];
                //messageCount = 9999;
                
                // create a iOS-like badge and place on the top right of the messages icon to hold a count of unread messages
                // uses CustomBadge class that fully draws in scalable Quartz
                CustomBadge *unreadMessageBadge =
                [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%i", messageCount]withStringColor:[UIColor whiteColor]
                                    withInsetColor:[UIColor colorWithRed:255.0/255.0 green:0 blue:0 alpha:0.75]
                                    withBadgeFrame:YES
                               withBadgeFrameColor:[UIColor whiteColor]
                                         withScale:1.0
                                       withShining:NO
                                        withShadow:NO];
                // modify left edge of badge frame depending on how many digits are in the unread message count
                float leftEdge = cell.iconImage.frameWidth - 20;
                if (messageCount >= 10) leftEdge = leftEdge - 10;
                if (messageCount >= 100) leftEdge = leftEdge - 10;
                if (messageCount >= 1000) leftEdge = leftEdge - 10;
                [unreadMessageBadge setFrame:CGRectMake(leftEdge, 0, unreadMessageBadge.frame.size.width, unreadMessageBadge.frame.size.height)];
                [[cell iconImage] addSubview:unreadMessageBadge];
            } else {
                cell.title = @"Messages";
            }
            
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
            
            //Patch-E: added new menu item for Shack[LOL]-tergration! Passes user= on the URL to allow lol'ing within the web view on the Shack[LOL] site. Uses new BrowserViewController constructor.
        case 4:
            urlString = [[NSString stringWithFormat:@"http://lol.lmnopc.com?lc_webview=1&user=%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"username"]] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            viewController = [[[BrowserViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] title:@"Shack[lol]" isForShackLOL:YES] autorelease];
            
            if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                LatestChatty2AppDelegate *appDelegate = [LatestChatty2AppDelegate delegate];
                [appDelegate.contentNavigationController setViewControllers:[NSArray arrayWithObject:viewController]];
                viewController = nil;
            }
            break;
            
        case 5:
            if ([[LatestChatty2AppDelegate delegate] isPadDevice]) modal = YES;
            viewController = [SettingsViewController controllerWithNib];
            break;
            
        case 6:
            urlString = [NSString stringWithFormat:@"http://%@/about", [Model host]];
            viewController = [[[BrowserViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]] autorelease];
            
            if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                LatestChatty2AppDelegate *appDelegate = [LatestChatty2AppDelegate delegate];
                [appDelegate.contentNavigationController setViewControllers:[NSArray arrayWithObject:viewController]];
                viewController = nil;
            }
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
				[appDelegate.slideOutViewController presentModalViewController:viewController animated:YES];
			} else {
				[self.navigationController presentModalViewController:viewController animated:YES];
            }
        } else {
            if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                self.viewDeckController.centerController = [[UINavigationController alloc] initWithRootViewController:viewController];
                [self.viewDeckController toggleLeftView];
            }
        }
    }
}

- (void)dealloc {
    [messageLoader release];
    [super dealloc];
}

@end
