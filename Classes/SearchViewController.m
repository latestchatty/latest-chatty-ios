//
//    SearchViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/20/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"

#import "RecentSearchButton.h"

@implementation SearchViewController

- (id)initWithNib {
    if (self = [super initWithNib]) {
        self.title = @"Search";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon.24.png"]
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignAndToggle)];
        self.navigationItem.leftBarButtonItem = menuButton;
        [menuButton release];
    }
    
//    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search"
//                                                                     style:UIBarButtonItemStyleDone
//                                                                    target:self
//                                                                    action:@selector(search)];
//	self.navigationItem.rightBarButtonItem = searchButton;
//	[searchButton release];
    
    CGRect fieldRect;
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        fieldRect = CGRectMake(150, 7, inputTable.frame.size.width - 220, 20);
    } else {
        fieldRect = CGRectMake(110, 7, inputTable.frame.size.width - 120, 20);
    }
    
    [inputTable setSeparatorColor:[UIColor lcGroupedSeparatorColor]];
    [inputTable setBackgroundView:nil];
    [inputTable setBackgroundView:[[[UIView alloc] init] autorelease]];
    [inputTable setBackgroundColor:[UIColor clearColor]];
    
    termsField = [[UITextField alloc] initWithFrame:fieldRect];
    termsField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    termsField.borderStyle = UITextBorderStyleNone;
    termsField.returnKeyType = UIReturnKeySearch;
    termsField.clearButtonMode = UITextFieldViewModeAlways;
    termsField.delegate = self;
    
    authorField = [[UITextField alloc] initWithFrame:fieldRect];
    authorField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    authorField.borderStyle = UITextBorderStyleNone;
    authorField.returnKeyType = UIReturnKeySearch;
    authorField.clearButtonMode = UITextFieldViewModeAlways;
    authorField.delegate = self;
    
    parentAuthorField = [[UITextField alloc] initWithFrame:fieldRect];
    parentAuthorField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    parentAuthorField.borderStyle = UITextBorderStyleNone;
    parentAuthorField.returnKeyType = UIReturnKeySearch;
    parentAuthorField.clearButtonMode = UITextFieldViewModeAlways;
    parentAuthorField.delegate = self;
    
    // Set the appearance of the segemented control
    // Rounded edges
    UIImage *segmentSelected =
    [[UIImage imageNamed:@"segcontrol_sel.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentUnselected =
    [[UIImage imageNamed:@"segcontrol_uns.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    [segmentedBar setBackgroundImage:segmentUnselected
                            forState:UIControlStateNormal
                          barMetrics:UIBarMetricsDefault];
    [segmentedBar setBackgroundImage:segmentSelected
                            forState:UIControlStateSelected
                          barMetrics:UIBarMetricsDefault];
    // Various inner states
    UIImage *segmentSelectedUnselected = [UIImage imageNamed:@"segcontrol_sel-uns.png"];
    UIImage *segUnselectedSelected = [UIImage imageNamed:@"segcontrol_uns-sel.png"];
    UIImage *segmentUnselectedUnselected = [UIImage imageNamed:@"segcontrol_uns-uns.png"];
    
    [segmentedBar setDividerImage:segmentUnselectedUnselected
              forLeftSegmentState:UIControlStateNormal
                rightSegmentState:UIControlStateNormal
                       barMetrics:UIBarMetricsDefault];
    [segmentedBar setDividerImage:segmentSelectedUnselected
              forLeftSegmentState:UIControlStateSelected
                rightSegmentState:UIControlStateNormal
                       barMetrics:UIBarMetricsDefault];
    [segmentedBar setDividerImage:segUnselectedSelected
              forLeftSegmentState:UIControlStateNormal
                rightSegmentState:UIControlStateSelected
                       barMetrics:UIBarMetricsDefault];
    
    [inputTable reloadData];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SearchLoaded" object:self];
    
    //moved call to modeChanged in viewDidLoad so that it only ever gets called on view load instead of everytime
    //the view appears, was causing a crash on iPhone landscape when scrolled down, did a search, and hit back to
    //bring search back into view
    segmentedBar.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"searchSegmented"];
    [self modeChanged];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // resize the scroll view on rotation
    [self sizeRecentSearchScrollView];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
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
    CGFloat yFrameOffset = 40.0f;
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        yFrameOffset += 15.0f;
    }
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
        NSMutableString *combinedTitle = [[[NSMutableString alloc] init] autorelease];
        
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
        
        // set title of button to the search input text
        NSString *searchTitle = [NSString stringWithFormat:@"%@", combinedTitle];
        
        // background and frame properties
        [btn setBackgroundImage:[[UIImage imageNamed:@"BlueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(segmentedBar.frameX, yButtonOffset, segmentedBar.frameWidth, buttonHeight)];
        [btn setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        // title label properties
        [btn setTitle:searchTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6.0, 0, 6.0)];        
        CGFloat titleFontSize = 15.0f;
        if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
            titleFontSize += 3.0f;
        }
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:titleFontSize]];
        [btn.titleLabel setShadowColor:[UIColor lcTextShadowColor]];
        [btn.titleLabel setShadowOffset:CGSizeMake(0, -1)];
        [btn.titleLabel setMinimumFontSize:10.0f];
        [btn.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [btn.titleLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];

        // send a message to a new search receiver that uses the custom properties on the subclassed button
        [btn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        
        // add button to view
        [recentSearchScrollView addSubview:btn];
        
        yButtonOffset += buttonHeight + 10.0f;
    }
    [self sizeRecentSearchScrollView];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:segmentedBar.selectedSegmentIndex forKey:@"searchSegmented"];
    [defaults synchronize];
    
    // if is the recent segmented control, show the view else remove it from the superview and let the
    // reset of the segemented control logic fire
    if (segmentedBar.selectedSegmentIndex == 4) {
        [self showRecentSearchView];
        [recentSearchScrollView setContentOffset:CGPointZero animated:YES];
        return;
    } else {
        [recentSearchView removeFromSuperview];
    }
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSArray *fields = [NSArray arrayWithObjects:termsField, authorField, parentAuthorField, nil];
    for (UITextField *field in fields) {
        field.enabled = YES;
        field.clearButtonMode = UITextFieldViewModeAlways;
        [field setKeyboardAppearance:UIKeyboardAppearanceAlert];
    }
    
    for (UITableViewCell *cell in [inputTable visibleCells]) {        
        cell.accessoryView.hidden = YES;
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
        [(UITableViewCell *)usernameField.superview accessoryView].hidden = NO;
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
    // create the search results controller and push it
    SearchResultsViewController *viewController = [[[SearchResultsViewController alloc] initWithTerms:sender.searchTerms
                                                                                               author:sender.searchAuthor
                                                                                         parentAuthor:sender.searchParentAuthor] autorelease];
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
            saveSearch = NO;
            break;
            
        default:
            break;
    }
    
    if (saveSearch) {
        // save this search in a dictionary and add it to the recent searches array
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
        [defaults synchronize];
    }
    
    // create the search results controller and push it
    SearchResultsViewController *viewController = [[[SearchResultsViewController alloc] initWithTerms:termsField.text
                                                                                               author:authorField.text
                                                                                         parentAuthor:parentAuthorField.text] autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self search];
    return NO;
}

#pragma mark TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    
    cell.backgroundColor = [UIColor lcGroupedCellColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *lockImage = [UIImageView viewWithImageNamed:@"Lock.16.png"];
    lockImage.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    lockImage.hidden = YES;
    cell.accessoryView = lockImage;
    
    CGFloat leftEdge = [[LatestChatty2AppDelegate delegate] isPadDevice] ? 40 : 0;
    UILabel *prompt = [UILabel viewWithFrame:CGRectMake(leftEdge, 7, 85, 22)];
    if (indexPath.row == 0) prompt.text = @"Terms:";
    if (indexPath.row == 1) prompt.text = @"Author:";
    if (indexPath.row == 2) prompt.text = @"Parent:";
    prompt.font = [UIFont boldSystemFontOfSize:16.0];
    prompt.textAlignment = UITextAlignmentRight;
    prompt.backgroundColor = [UIColor clearColor];
    prompt.textColor = [UIColor lcGroupedCellLabelColor];
    prompt.shadowColor = [UIColor lcTextShadowColor];
    [prompt setShadowOffset:CGSizeMake(0, -1.0)];
    [cell addSubview:prompt];
    
    UITextField *textField = nil;
    
    if (indexPath.row == 0) {
        textField = termsField;
        textField.textColor = [UIColor whiteColor];
    }
    if (indexPath.row == 1) {
        textField = authorField;
    }
    if (indexPath.row == 2) {
        textField = parentAuthorField;
    }
    if (indexPath.row == 1 || indexPath.row == 2) {
        textField.textColor = [UIColor lcAuthorColor];
    }
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        textField.frameWidth = cell.frameWidth - 195;
    } else {
        textField.frameWidth = cell.frameWidth - 120;
    }
    [cell addSubview:textField];
    
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

- (void)dealloc {
    [termsField release];
    [authorField release];
    [parentAuthorField release];
    [inputTable release];
    [segmentedBar release];
    [recentSearchView release];
    [searchTerms release];
    [searchAuthor release];
    [searchParentAuthor release];
    [recentSearchScrollView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [recentSearchView release];
    recentSearchView = nil;
    [recentSearchScrollView release];
    recentSearchScrollView = nil;
    [super viewDidUnload];
}
@end
