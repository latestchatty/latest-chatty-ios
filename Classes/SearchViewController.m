//
//  SearchViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"


@implementation SearchViewController

- (id)init {
  self = [super initWithNibName:@"SearchViewController" bundle:nil];
  self.title = @"Comment Search";
  return self;
}



- (void)viewDidLoad {
  [super viewDidLoad];
  inputTable.backgroundColor = [UIColor clearColor];
  segmentedBar.tintColor = [UIColor colorWithWhite:0.4 alpha:1.0];
  
  termsField = [[UITextField alloc] initWithFrame:CGRectMake(110, 7, inputTable.frame.size.width - 120, 21)];
  termsField.borderStyle = UITextBorderStyleNone;
  termsField.returnKeyType = UIReturnKeySearch;
  termsField.clearButtonMode = UITextFieldViewModeAlways;
  
  authorField = [[UITextField alloc] initWithFrame:CGRectMake(110, 7, inputTable.frame.size.width - 120, 21)];
  authorField.borderStyle = UITextBorderStyleNone;
  authorField.returnKeyType = UIReturnKeySearch;
  authorField.clearButtonMode = UITextFieldViewModeAlways;
  
  parentAuthorField = [[UITextField alloc] initWithFrame:CGRectMake(110, 7, inputTable.frame.size.width - 120, 21)];
  parentAuthorField.borderStyle = UITextBorderStyleNone;
  parentAuthorField.returnKeyType = UIReturnKeySearch;
  parentAuthorField.clearButtonMode = UITextFieldViewModeAlways;
  
  [inputTable reloadData];
  [self modeChanged];
  
  [termsField becomeFirstResponder];
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
    for (UITextField *field in fields) field.text = @"";
    
    usernameField.text = username;
    usernameField.enabled = NO;
    usernameField.clearButtonMode = UITextFieldViewModeNever;
    [(UITableViewCell *)usernameField.superview accessoryView].hidden = NO;
  }
}

#pragma mark TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"searchInputCell"];
  
  UIImageView *lockImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lock.16.png"]];
  lockImage.hidden = YES;
  cell.accessoryView = lockImage;
  [lockImage release];
  
  UILabel *prompt = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 85, 31)];
  if (indexPath.row == 0) prompt.text = @"Terms:";
  if (indexPath.row == 1) prompt.text = @"Author:";
  if (indexPath.row == 2) prompt.text = @"Parent Author:";
  prompt.font = [UIFont boldSystemFontOfSize:12.0];
  prompt.textAlignment = UITextAlignmentRight;
  prompt.backgroundColor = [UIColor clearColor];
  prompt.textColor = [UIColor colorWithWhite:0.0 alpha:0.6];
  [cell addSubview:prompt];
  [prompt release];
  
  if (indexPath.row == 0) [cell addSubview:termsField];
  if (indexPath.row == 1) [cell addSubview:authorField];
  if (indexPath.row == 2) [cell addSubview:parentAuthorField];
  
  return [cell autorelease];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}


- (void)dealloc {
  [termsField release];
  [authorField release];
  [parentAuthorField release];
  [super dealloc];
}


@end
