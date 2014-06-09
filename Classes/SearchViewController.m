//
//    SearchViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/20/09.
//    Copyright 2009. All rights reserved.
//

#import "SearchViewController.h"

#import "RecentSearchButton.h"

@implementation SearchViewController

- (id)initWithNib {
    if (self = [super initWithNib]) {
        self.title = @"Search";
        
        termsField = [[UITextField alloc] initWithFrame:CGRectZero];
        authorField = [[UITextField alloc] initWithFrame:CGRectZero];
        parentAuthorField = [[UITextField alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu-Button-List.png"]
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignAndToggle)];
        self.navigationItem.leftBarButtonItem = menuButton;
    }
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(search)];
    [searchButton setTitleTextAttributes:[NSDictionary blueTextAttributesDictionary] forState:UIControlStateNormal];
	self.navigationItem.rightBarButtonItem = searchButton;
    
    [inputTable setSeparatorColor:[UIColor lcGroupedSeparatorColor]];
    [inputTable setBackgroundView:nil];
    [inputTable setBackgroundView:[[UIView alloc] init]];
    [inputTable setBackgroundColor:[UIColor clearColor]];
    
    [inputTable reloadData];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SearchLoaded" object:self];
    
    //moved call to modeChanged in viewDidLoad so that it only ever gets called on view load instead of everytime
    //the view appears, was causing a crash on iPhone landscape when scrolled down, did a search, and hit back to
    //bring search back into view
    segmentedBar.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"searchSegmented"];
    [self modeChanged];
    
    // iOS7
    self.navigationController.navigationBar.translucent = NO;
    
    // top separation bar
    UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
    
    // scroll indicator coloring
    [inputTable setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [recentSearchScrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // resize the scroll view on rotation
    [self sizeRecentSearchScrollView];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // scroll the scroll view to the top on rotation
    [recentSearchScrollView setContentOffset:CGPointZero animated:NO];
}

- (void)resignAndToggle {
    [[self view] endEditing:YES];
    
    [self.viewDeckController toggleLeftView];
}

- (void)showRecentSearchView {
    // resign first responder from all inputs
    [[self view] endEditing:YES];
    
    // show the recent search view
    [recentSearchView setFrame:self.view.frame];
    CGFloat yFrameOffset = segmentedBar.frameHeight + segmentedBar.frameY;
    [recentSearchView setFrameY:yFrameOffset];
    [recentSearchView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:recentSearchView];
    
    for (UIView *subview in [recentSearchScrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    // get the recent searches array
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentSearches = [NSMutableArray arrayWithArray:[defaults objectForKey:@"recentSearches"]];
    
    CGFloat yButtonOffset = 10.0f;
    CGFloat buttonHeight = 44.0f;
    // loop over the recent searches dictionary array in reverse
    for (NSDictionary *dict in [[recentSearches reverseObjectEnumerator] allObjects]) {
        // generate a button for each recent search
        RecentSearchButton *btn = [RecentSearchButton buttonWithType:UIButtonTypeCustom];
        
        // grab the data for this recent search 
        NSString *terms = [NSString stringWithString:[dict valueForKey:@"term"]];
        NSString *author = [NSString stringWithString:[dict valueForKey:@"author"]];
        NSString *parent = [NSString stringWithString:[dict valueForKey:@"parent"]];
        
        // pass the data to properties on the subclassed button
        [btn setSearchTerms:terms];
        [btn setSearchAuthor:author];
        [btn setSearchParentAuthor:parent];

        // craft the title for the button based on the search
        NSMutableString *combinedTitle = [[NSMutableString alloc] init];
        
        // some ugly string manip concat to achieve: "Terms: term | Author: author | Parent: parent"
        // for the button title
        BOOL hasTerms = NO;
        if ([terms length] > 0) {
            [combinedTitle appendFormat:@"Terms: %@", terms];
            hasTerms = YES;
        }
        BOOL hasAuthor = NO;
        if ([author length] > 0) {
            [combinedTitle appendFormat:@"%@Author: %@", (hasTerms ? @" | " : @""), author];
            hasAuthor = YES;
        }
        if ([parent length] > 0) {
            [combinedTitle appendFormat:@"%@Parent: %@", (hasTerms || hasAuthor ? @" | " : @""), parent];
        }
        
        [self applyButtonSettings:btn buttonTitle:[NSString stringWithFormat:@"%@", combinedTitle] buttonOffset:yButtonOffset buttonHeight:buttonHeight];
        
        // send a message to a new search receiver that uses the custom properties on the subclassed button
        [btn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        
        // add button to view
        [recentSearchScrollView addSubview:btn];
        
        yButtonOffset += buttonHeight + 10.0f;
    }
    
    // add clear recent search button at the end
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self applyButtonSettings:btn buttonTitle:@"Clear Recent Searches" buttonOffset:yButtonOffset buttonHeight:buttonHeight];
    // add touch event to send a message that clears the recent search array
    // or modify button title to indicate search history is empty
    if ([recentSearches count] > 0) {
        [btn addTarget:self action:@selector(clearRecentSearches:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [btn setTitle:@"Recent Searches is empty" forState:UIControlStateDisabled];
        [btn setEnabled:NO];
    }
    [recentSearchScrollView addSubview:btn];
    
    [self sizeRecentSearchScrollView];
}

- (void)applyButtonSettings:(UIButton*)btn buttonTitle:(NSString*)title
               buttonOffset:(CGFloat)yButtonOffset
               buttonHeight:(CGFloat)buttonHeight {
    // background and frame properties
    [btn setFrame:CGRectMake(segmentedBar.frameX, yButtonOffset, segmentedBar.frameWidth-1, buttonHeight)];
    [btn setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    // title label properties
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lcBlueColorHighlight] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor lcDarkGrayTextColor] forState:UIControlStateDisabled];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6.0, 0, 6.0)];
    
    CGFloat titleFontSize = 15.0f;
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        titleFontSize += 3.0f;
    }

    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
    [btn.titleLabel setMinimumScaleFactor:10.0f];
    [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [btn.titleLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1;
    if ([title isEqualToString:@"Clear Recent Searches"]) {
        [btn setTitleColor:[UIColor lcDarkGrayTextColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor lcDarkGrayTextColor].CGColor;
    } else {
        [btn setTitleColor:[UIColor lcBlueColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor lcBlueColor].CGColor;
    }
}

- (void)sizeRecentSearchScrollView {
    // loop over the scroll view's subviews to total up their height and offset for the scroll view's content height
    CGFloat scrollViewHeight = 0.0f;
    for (UIView *view in recentSearchScrollView.subviews){
        if (scrollViewHeight < view.frame.origin.y + view.frame.size.height)
            scrollViewHeight = view.frame.origin.y + view.frame.size.height;
    }
    [recentSearchScrollView setContentSize:CGSizeMake(recentSearchView.frameWidth, scrollViewHeight + recentSearchView.frameY + 20.0f)];
}

- (IBAction)modeChanged {
    [[NSUserDefaults standardUserDefaults] setInteger:segmentedBar.selectedSegmentIndex forKey:@"searchSegmented"];
    
    // if is the recent segmented control, show the view else remove it from the superview and let the
    // reset of the segemented control logic fire
    if (segmentedBar.selectedSegmentIndex == 4) {
        [self showRecentSearchView];
        [recentSearchScrollView setContentOffset:CGPointZero animated:YES];
        
        // disable and hide the top right search
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.title = @"";
        
        return;
    } else {
        [recentSearchView removeFromSuperview];
        
        // enable and show the top right search
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.title = @"Submit";
    }
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSArray *fields = [NSArray arrayWithObjects:termsField, authorField, parentAuthorField, nil];
    for (UITextField *field in fields) {
        field.enabled = YES;
        field.clearButtonMode = UITextFieldViewModeAlways;
        field.keyboardAppearance = UIKeyboardAppearanceDark;
        field.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        field.borderStyle = UITextBorderStyleNone;
        field.returnKeyType = UIReturnKeySearch;
        if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
            field.font = [UIFont systemFontOfSize:18];
        } else {
            field.font = [UIFont systemFontOfSize:16];
        }
        field.delegate = self;
    }
    
    for (UITableViewCell *cell in [inputTable visibleCells]) {
        // get and hide the lock image (last subview in cell's contentView), really ugly
        ((UIView *)cell.contentView.subviews.lastObject).hidden = YES;
    }
    
    UITextField *usernameField = nil;
    BOOL isCustom = NO;
    
    switch (segmentedBar.selectedSegmentIndex) {
        case 0:
            usernameField = authorField;
            break;
        
        case 1:
            usernameField = termsField;
            break;
            
        case 2:
            usernameField = parentAuthorField;
            break;
            
        case 3:
            isCustom = YES;
            break;

        default:
            break;
    }
    
    if (usernameField || isCustom) {
        for (UITextField *field in fields) {
            field.text = @"";
        }
    }
    
    if (usernameField) {
        usernameField.text = username;
        usernameField.enabled = NO;
        usernameField.clearButtonMode = UITextFieldViewModeNever;
        
        // get and show the lock image (last subview in cell's contentView), really ugly
        UIView *cell;
        // superview traversing apparently changed in iOS 8
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            cell = [(UITableViewCell *)usernameField.superview.superview.superview contentView];
        } else {
            cell = [(UITableViewCell *)usernameField.superview.superview contentView];
        }
        if (cell) {
            ((UIView *)cell.subviews.lastObject).hidden = NO;
        }
    }
    
    //Patch-E: always keeping focus in one of the text fields upon segemented control mode change, made the search button under the table view unecessary for iPhone, removed from iPhone xib and programmatically create one on the top right of navigation bar. Always scrolling the text field with focus into view on iPhone.
    switch (segmentedBar.selectedSegmentIndex) {
        case 1:
            [authorField becomeFirstResponder];
            break;
        default:
            [termsField becomeFirstResponder];
            break;
    }

    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [inputTable setContentOffset:CGPointZero animated:YES];
    }
}

// new search function uses properties from subclassed button to pass on to search results vc init
- (void)search:(RecentSearchButton*)sender {
    // make a dictionary out of the recent search that was just tapped
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *searchDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sender.searchTerms, @"term",
                                      sender.searchAuthor, @"author",
                                      sender.searchParentAuthor, @"parent",
                                      nil];
	// get all of the recent searches
	NSMutableArray *recentSearches = [NSMutableArray arrayWithArray:[defaults objectForKey:@"recentSearches"]];
    // filter the recent searches array to remove the recent search that was tapped
    NSMutableArray *filteredRecentSearches = [NSMutableArray array];
	for (NSDictionary *recentSearch in recentSearches) {
//        NSLog(@"recentSearch: %@", recentSearch);
        if (![recentSearch isEqual:searchDictionary]) {
//            NSLog(@"searchDictionary: %@", searchDictionary);
            [filteredRecentSearches addObject:recentSearch];
        }
	}
    // add the recent search back to the filtered search array so that it has "bubbled" to the top
    [filteredRecentSearches addObject:searchDictionary];
    // persis the new recent searches array back to user defaults
    [defaults setObject:filteredRecentSearches forKey:@"recentSearches"];
    
    // create the search results controller and push it
    SearchResultsViewController *viewController = [[SearchResultsViewController alloc] initWithTerms:sender.searchTerms
                                                                                               author:sender.searchAuthor
                                                                                         parentAuthor:sender.searchParentAuthor];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)search {
    // let's only save searches that a user added input to and weren't standard posts/vanity/replies searches
    BOOL saveSearch = NO;
    switch (segmentedBar.selectedSegmentIndex) {
        case 0:
            if (termsField.text.length > 0 || parentAuthorField.text.length > 0) saveSearch = YES;
            break;
            
        case 1:
            if (authorField.text.length > 0 || parentAuthorField.text.length > 0) saveSearch = YES;
            break;
            
        case 2:
            if (termsField.text.length > 0 || authorField.text.length > 0) saveSearch = YES;
            break;
            
        case 3:
            // custom segment will always be saved in recent searches but only if at least one field has characters
            if (termsField.text.length > 0 || authorField.text.length > 0 || parentAuthorField.text.length > 0) saveSearch = YES;
            break;
            
        default:
            break;
    }
    
    // only save the search if matched criteria in the switch statement and the user is allowing searches to be saved
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL userSaveSearchesSetting = [defaults boolForKey:@"saveSearches"];
    if (saveSearch && userSaveSearchesSetting) {
        // save this search in a dictionary and add it to the recent searches array
        NSMutableArray *recentSearches = [NSMutableArray arrayWithArray:[defaults objectForKey:@"recentSearches"]];
        NSDictionary *searchDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            termsField.text, @"term",
                                            authorField.text, @"author",
                                            parentAuthorField.text, @"parent",
                                            nil];
        
        // allowing a max of 10 most recent searches
        if (recentSearches.count == 10) {
            [recentSearches removeObjectsInRange:NSMakeRange(0, 1)];
        }
        
        // add the search dictionary and sync
        [recentSearches addObject:searchDictionary];
        [defaults setObject:recentSearches forKey:@"recentSearches"];
    }
    
    // create the search results controller and push it
    SearchResultsViewController *viewController = [[SearchResultsViewController alloc] initWithTerms:termsField.text
                                                                                               author:authorField.text
                                                                                         parentAuthor:parentAuthorField.text];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self search];
    return NO;
}

- (void)clearRecentSearches:(id)sender {
    // clear the recent searches array and stuff back in user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentSearches = [NSMutableArray arrayWithArray:[defaults objectForKey:@"recentSearches"]];
    [recentSearches removeAllObjects];
    
    [defaults setObject:recentSearches forKey:@"recentSearches"];

    // call modeChanged as an easy way of updating the UI after clearing the recent searches
    [self modeChanged];
}

#pragma mark Table View Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [cell setBackgroundColor:[UIColor lcGroupedCellColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.textLabel setTextColor:[UIColor lcGroupedCellLabelColor]];
    [cell.textLabel setShadowColor:[UIColor lcTextShadowColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0, -1.0)];

    UIImageView *lockImage = [UIImageView viewWithImageNamed:@"Lock.16.png"];
    lockImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    lockImage.frameX = cell.frameWidth - 30;
    
    CGRect fieldRect;
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
        fieldRect = CGRectMake(100, 33, 214, 22);
        lockImage.frameY = 36;
    } else {
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        fieldRect = CGRectMake(80, 12, 234, 20);
        lockImage.frameY = 13;
    }
    
    switch (indexPath.row) {
        case 0:
            [cell.contentView addSubview:termsField];
            termsField.textColor = [UIColor whiteColor];
            [termsField setFrame:fieldRect];
            cell.textLabel.text = @"Terms:";
            
            if (termsField.enabled) {
                lockImage.hidden = YES;
            }
            
            break;
            
        case 1:
            [cell.contentView addSubview:authorField];
            authorField.textColor = [UIColor lcAuthorColor];
            [authorField setFrame:fieldRect];
            cell.textLabel.text = @"Author:";
            
            if (authorField.enabled) {
                lockImage.hidden = YES;
            }
            
            break;
            
        case 2:
            [cell.contentView addSubview:parentAuthorField];
            parentAuthorField.textColor = [UIColor lcAuthorColor];
            [parentAuthorField setFrame:fieldRect];
            cell.textLabel.text = @"Parent:";
            
            if (parentAuthorField.enabled) {
                lockImage.hidden = YES;
            }
            
            break;
    }
    
    [cell.contentView addSubview:lockImage];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    inputTable.delegate = nil;
}

@end
