//
//    RootViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/10/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated {
    messageLoader = [[Message findAllWithDelegate:self] retain];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
    messageCount = 0;
    for (Message *message in models) {
        if (message.unread) messageCount++;
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:messageCount];
    [self.tableView reloadData];
    [messageLoader release];
    messageLoader = nil;
}

- (void)didFailToLoadModels {
    NSLog(@"Failed to load messages");
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
            cell.title = @"Stories"; break;
            
        case 1:
            cell.title = @"Latest Chatty"; break;
            
        case 2:
            if (messageCount > 0) {
                cell.title = [NSString stringWithFormat:@"Messages (%i)", messageCount];
            } else {
                cell.title = @"Messages";
            }
            break;
            
        case 3:
            cell.title = @"Search"; break;
            
        case 4:
            cell.title = @"Settings"; break;
            
        case 5:
            cell.title = @"About"; break;
            
        default:
            [NSException raise:@"too many rows" format:@"This table can only have 5 cells!"];
            break;
    }

    return (UITableViewCell *)cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [RootCell cellHeight];
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id viewController = nil;
    BOOL modal = NO;
    NSString *urlString;
    
    switch (indexPath.row) {
        case 0:
            viewController = [StoriesViewController controllerWithNib];
            break;
            
        case 1:
            viewController = [[[ChattyViewController alloc] initWithLatestChatty] autorelease];
            break;
            
        case 2:
            viewController = [MessagesViewController controllerWithNib];
            break;
            
        case 3:
            viewController = [SearchViewController controllerWithNib];
            break;
            
        case 4:
            modal = YES;
            viewController = [SettingsViewController controllerWithNib];
            break;
            
        case 5:
            urlString = [NSString stringWithFormat:@"http://%@/about", [Model host]];
            viewController = [[[BrowserViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]] autorelease];
            break;
            
        default:
            [NSException raise:@"too many rows" format:@"This table can only have 6 cells!"];
            break;
    }
    
    if (viewController) {
        if (modal) {
            [self.navigationController presentModalViewController:viewController animated:YES];
        } else {
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (void)dealloc {
    [messageLoader release];
    [super dealloc];
}


@end

