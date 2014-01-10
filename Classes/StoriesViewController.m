//
//    RootViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/16/09.
//    Copyright 2009. All rights reserved.
//

#import "StoriesViewController.h"

@implementation StoriesViewController

@synthesize stories, refreshControl;

- (id)initWithNib {
    if (self = [super initWithNib]) {
        self.title = @"Loading...";
    }
    return self;
}

- (id)initWithStateDictionary:(NSDictionary *)dictionary {
    if (!(self = [self init])) return nil;
    
    self.stories = [dictionary objectForKey:@"stories"];
    
    return self;
}

- (NSDictionary *)stateDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:@"Stories", @"type", stories, @"stories", nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (stories == nil || [stories count] == 0) [self refresh:self.refreshControl];
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu-Button-List.png"]
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self.viewDeckController
                                                                      action:@selector(toggleLeftView)];
        self.navigationItem.leftBarButtonItem = menuButton;
    }
    
//    UIBarButtonItem *latestChattyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ChatIcon.24.png"]
//																		   style:UIBarButtonItemStyleDone
//																		  target:self
//																		  action:@selector(tappedLatestChattyButton)];
//    self.navigationItem.rightBarButtonItem = latestChattyButton;
//    [latestChattyButton release];
    
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [loader cancel];
    [self.refreshControl endRefreshing];
}

- (void)refresh:(id)sender {
    [super refresh:sender];
    loader = [Story findAllWithDelegate:self];
}

- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
    self.stories = models;
    loader = nil;
    [super didFinishLoadingAllModels:models otherData:otherData];
    
    self.title = @"Stories";
    
    [self.refreshControl endRefreshing];
    
    if (self.stories.count == 0) {
        [UIAlertView showSimpleAlertWithTitle:@"Latest Chatty"
                                      message:@"There was an error loading stories. Please try again."];
        return;
    }
    
    self.tableView.hidden = NO;
}

#pragma mark Table view methods

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.stories) count = [self.stories count];
    return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"StoryCell";
    
    StoryCell *cell = (StoryCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StoryCell alloc] init];
        [cell.chattyButton addTarget:self action:@selector(tappedChattyButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // Set the story
    cell.story = [stories objectAtIndex:indexPath.row];

    return (UITableViewCell *)cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Story *story = [stories objectAtIndex:indexPath.row];
    StoryViewController *viewController = [[StoryViewController alloc] initWithStoryId:story.modelId];
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [LatestChatty2AppDelegate delegate].contentNavigationController.viewControllers = [NSArray arrayWithObject:viewController];
    } else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(void)tableView:(UITableView *)_tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:_tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark Actions

//- (IBAction)tappedChattyButton:(id)sender {
//    NSIndexPath *indexPath;
//    for (StoryCell *cell in [self.tableView visibleCells]) {
//        if (cell.chattyButton == sender) {
//            indexPath = [self.tableView indexPathForCell:cell];
//        }
//    }
//
//    Story *story = [stories objectAtIndex:indexPath.row];
//    UIViewController *viewController = [ChattyViewController chattyControllerWithStoryId:story.modelId];
//    //UIViewController *viewController = [[ThreadViewController alloc] initWithThreadId:29061947]; // for testing
//    [self.navigationController pushViewController:viewController animated:YES];
//}

//- (IBAction)tappedLatestChattyButton {
//    ChattyViewController *viewController = [ChattyViewController chattyControllerWithLatest];
//    [self.navigationController pushViewController:viewController animated:YES];
//}

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
