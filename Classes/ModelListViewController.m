//
//  ModelListViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/19/09.
//  Copyright 2009. All rights reserved.
//

#import "ModelListViewController.h"

@implementation ModelListViewController

@synthesize tableView;

# pragma mark View Notifications

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    loadingView.backgroundColor = [UIColor lcOverlayColor];
    loadingView.userInteractionEnabled = NO;
    loadingView.alpha = 0.0;
    loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color = [UIColor lightGrayColor];
    [spinner startAnimating];
    spinner.contentMode = UIViewContentModeCenter;
    CGFloat offset = 0.0;
    // no longer needed with opaque nav bars
//    if (![self isKindOfClass:[ThreadViewController class]]) {
//        offset = 50;
//    }

    spinner.frame = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height / 2.0);
    spinner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [loadingView addSubview:spinner];

    [self.view addSubview:loadingView];
    
    // scroll indicator coloring
    [tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([fartSound isPlaying])
        [fartSound stop];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

# pragma mark Actions

- (IBAction)refresh:(id)sender {
    [loader cancel];

    if (![sender isKindOfClass:[UIRefreshControl class]]) {
      [self showLoadingSpinner];
    }
}

#pragma mark Loading Spinner

- (void)showLoadingSpinner {
    loadingView.alpha = 0.0;
    [UIView beginAnimations:@"LoadingViewFadeIn" context:nil];
    loadingView.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)hideLoadingSpinner {
    [UIView beginAnimations:@"LoadingViewFadeOut" context:nil];
    loadingView.alpha = 0.0;
    [UIView commitAnimations];
}

- (BOOL)loading {
    return loadingView.alpha > 0;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Override this method
    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // animate cells into view slightly with opacity animation
//    cell.alpha = 0.25;
//    [UIView animateWithDuration:0.1 animations:^{
//        cell.alpha = 1.0;
//    }];
}

#pragma mark Fart Mode

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![fartSound isPlaying]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"superSecretFartMode"]) {
            NSUInteger randomFartNumber = arc4random() % 9 + 1;
//            NSLog(@"Playing Fart #%i, don't forget to wipe!", randomFartNumber);
            NSURL *soundURL = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"Fart%lu", (unsigned long)randomFartNumber]
                                                      withExtension:@"mp3"];
            fartSound = [[AVAudioPlayer alloc]
                         initWithContentsOfURL:soundURL error:nil];
            [fartSound play];
        }
    }
}

#pragma mark Data Loading Callbacks

// Fade in table cells
- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
    [self hideLoadingSpinner];
  
    // Create cells
    [self.tableView reloadData];

    // Fade them in
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        cell.alpha = 0.0;
        [UIView beginAnimations:[NSString stringWithFormat:@"FadeInStoriesTable_%@", [cell description]] context:nil];
        cell.alpha = 1.0;
        [UIView commitAnimations];
    }
}

- (void)didFinishLoadingModel:(id)aModel otherData:(id)otherData {
    [self didFinishLoadingAllModels:nil otherData:otherData];
}

- (void)didFailToLoadModels {
    loader = nil;
    [self hideLoadingSpinner];
    self.title = @"";
    [UIAlertView showSimpleAlertWithTitle:@"Error"
                                  message:@"Could not connect to the server. Check your internet connection or your server API address in Settings."];
}

@end
