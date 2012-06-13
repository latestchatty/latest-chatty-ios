//
//    SearchViewController.m
//    LatestChatty2
//
//    Created by Alex Wayne on 4/20/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "LatestChatty2AppDelegate.h"

@implementation SearchViewController

- (id)initWithNib {
    if (self = [super initWithNib]) {
        self.title = @"Comment Search";
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect fieldRect;
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        fieldRect = CGRectMake(150, 7, inputTable.frame.size.width - 220, 21);
    } else {
        fieldRect = CGRectMake(110, 7, inputTable.frame.size.width - 120, 21);
    }
    
    NSLog(@"%@", inputTable);
    
    //respondsToSelector needed for versions prior to iOS 3.2
    if ([inputTable respondsToSelector:@selector(backgroundView)]) {
        [inputTable setBackgroundView:nil];
        [inputTable setBackgroundView:[[[UIView alloc] init] autorelease]];
    }

    inputTable.backgroundColor = [UIColor clearColor];
    segmentedBar.tintColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    
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
    
    [inputTable reloadData];
    [self modeChanged];
    
    [termsField becomeFirstResponder];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SearchLoaded" object:self];
}


/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)modeChanged {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSArray *fields = [NSArray arrayWithObjects:termsField, authorField, parentAuthorField, nil];
    for (UITextField *field in fields) {
        field.enabled = YES;
        field.clearButtonMode = UITextFieldViewModeAlways;
    }
    
    for (UITableViewCell *cell in [inputTable visibleCells]) {        
        cell.accessoryView.hidden = YES;
    }
    
    UITextField *usernameField = nil;
    
    switch (segmentedBar.selectedSegmentIndex) {
        case 0:
            usernameField = authorField; break;
        
        case 1:
            usernameField = termsField; break;
            
        case 2:
            usernameField = parentAuthorField; break;
    }
    
    if (usernameField) {
        for (UITextField *field in fields) {
            field.text = @"";
        }
        
        usernameField.text = username;
        usernameField.enabled = NO;
        usernameField.clearButtonMode = UITextFieldViewModeNever;
        [(UITableViewCell *)usernameField.superview accessoryView].hidden = NO;
    }
}

- (IBAction)search {
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *lockImage = [UIImageView viewWithImageNamed:@"Lock.16.png"];
    lockImage.hidden = YES;
    cell.accessoryView = lockImage;
    
    CGFloat leftEdge = [[LatestChatty2AppDelegate delegate] isPadDevice] ? 60 : 20;
    UILabel *prompt = [UILabel viewWithFrame:CGRectMake(leftEdge, 4, 85, 31)];
    if (indexPath.row == 0) prompt.text = @"Terms:";
    if (indexPath.row == 1) prompt.text = @"Author:";
    if (indexPath.row == 2) prompt.text = @"Parent Author:";
    prompt.font = [UIFont boldSystemFontOfSize:12.0];
    prompt.textAlignment = UITextAlignmentRight;
    prompt.backgroundColor = [UIColor clearColor];
    prompt.textColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [cell addSubview:prompt];
    
    UITextField *textField = nil;
    if (indexPath.row == 0) textField = termsField;
    if (indexPath.row == 1) textField = authorField;
    if (indexPath.row == 2) textField = parentAuthorField;
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        textField.frameWidth = cell.frameWidth - 200;
    } else {
        textField.frameWidth = cell.frameWidth - 120;
    }
    [cell addSubview:textField];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return YES;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc {
    [termsField release];
    [authorField release];
    [parentAuthorField release];
    [super dealloc];
}


@end
