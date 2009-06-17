//
//  SettingsViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "RegexKitLite.h"

@implementation SettingsViewController


- (id)init {
  return [super initWithNibName:@"SettingsViewController" bundle:nil];
}

- (id)initWithStateDictionary:(NSDictionary *)dictionary {
  return [self init];
}

- (NSDictionary *)stateDictionary {
  return [NSDictionary dictionaryWithObject:@"Settings" forKey:@"type"];
}

- (IBAction)dismiss:(id)sender {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:usernameField.text forKey:@"username"];
  [defaults setObject:passwordField.text forKey:@"password"];
  [defaults setBool:landscapeSwitch.on   forKey:@"landscape"];
  [defaults setBool:youtubeSwitch.on     forKey:@"embedYoutube"];
  
  NSString *serverAddress = serverField.text;
  serverAddress = [serverAddress stringByReplacingOccurrencesOfRegex:@"^http://" withString:@""];
  serverAddress = [serverAddress stringByReplacingOccurrencesOfRegex:@"/$" withString:@""];
  [defaults setObject:serverAddress forKey:@"server"];
  
  [defaults setBool:interestingSwitch.on forKey:@"postCategory.informative"];
  [defaults setBool:offtopicSwitch.on    forKey:@"postCategory.offtopic"];
  [defaults setBool:randomSwitch.on      forKey:@"postCategory.stupid"];
  [defaults setBool:politicsSwitch.on    forKey:@"postCategory.political"];
  [defaults setBool:nwsSwitch.on         forKey:@"postCategory.nws"];
  
  [self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
//  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//  
//  usernameField.text = [defaults stringForKey:@"username"];
//  passwordField.text = [defaults stringForKey:@"password"];
//  serverField.text   = [defaults stringForKey:@"server"];
//  
//  landscapeSwitch.on = [defaults boolForKey:@"landscape"];
//  youtubeSwitch.on   = [defaults boolForKey:@"embedYoutube"];
//
//  
//  // Filter switches
//  interestingSwitch.on  = [defaults boolForKey:@"postCategory.informative"];
//  offtopicSwitch.on     = [defaults boolForKey:@"postCategory.offtopic"];
//  randomSwitch.on       = [defaults boolForKey:@"postCategory.stupid"];
//  politicsSwitch.on     = [defaults boolForKey:@"postCategory.political"];
//  nwsSwitch.on          = [defaults boolForKey:@"postCategory.nws"];
//  
//  // Set filter background colors
//  interestingBackground.backgroundColor = [Post colorForPostCategory:@"informative"];
//  offtopicBackground.backgroundColor    = [Post colorForPostCategory:@"offtopic"];
//  randomBackground.backgroundColor      = [Post colorForPostCategory:@"stupid"];
//  politicsBackground.backgroundColor    = [Post colorForPostCategory:@"political"];
//  nwsBackground.backgroundColor         = [Post colorForPostCategory:@"nws"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == usernameField) {
    [passwordField becomeFirstResponder];
  } else if (textField == passwordField) {
    [passwordField resignFirstResponder];
  } else if (textField == serverField) {
    [serverField resignFirstResponder];
  }
  return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
  return NO;
}

#pragma mark Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return 3;
      break;
      
    case 1:
      return 2;
      break;
    
    case 2:
      return 5;
      break;
      
    default:
      return 0;
      break;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return @"Connection";
      break;
      
    case 1:
      return @"Preferences";
      break;
      
    case 2:
      return @"Post Categories";
      break;
      
    default:
      return 0;
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  // username/password/server text entry fields
  if (indexPath.section == 0) {
    UITextField *textField;
  
    switch (indexPath.row) {
      case 0:
        if (usernameField)
          textField = usernameField;
        else
          textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 20)];
        
        textField.returnKeyType = UIReturnKeyNext;
        textField.placeholder = @"Enter Username";
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.text = [defaults stringForKey:@"username"];
        usernameField = textField;
        cell.text = @"Username:";
        break;
        
      case 1:
        if (passwordField)
          textField = passwordField;
        else
          textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 20)];
        
        textField.returnKeyType = UIReturnKeyDone;
        textField.secureTextEntry = YES;
        textField.placeholder = @"Enter Password";
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.text = [defaults stringForKey:@"password"];
        passwordField = textField;
        cell.text = @"Password:";
        break;
        
      case 2:
        if (serverField)
          textField = serverField;
        else
          textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 20)];
        
        textField.placeholder = @"Enter: shackchatty.com";
        textField.returnKeyType = UIReturnKeyDone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.text = [defaults stringForKey:@"server"];
        serverField = textField;
        cell.text = @"Server URL:";
        break;
        
    }
    textField.delegate = self;
    cell.accessoryView = textField;
  }
  
  // Preference toggles
  if (indexPath.section == 1) {
    UISwitch *toggle;
    
    switch (indexPath.row) {
      case 0:
        if (landscapeSwitch)
          toggle = landscapeSwitch;
        else
          toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        toggle.on = [defaults boolForKey:@"landscape"];
        landscapeSwitch = toggle;
        cell.text = @"Allow Landscape:";
        break;
      
      case 1:
        if (youtubeSwitch)
          toggle = youtubeSwitch;
        else
          toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        toggle.on = [defaults boolForKey:@"embedYoutube"];
        youtubeSwitch = toggle;
        cell.text = @"Embed Youtube:";
        break;
    }
    cell.accessoryView = toggle;
  }
  
  // Post category toggles
  if (indexPath.section == 2) {
    UISwitch *toggle;
    UIView *categoryColor = [[UIView alloc] initWithFrame:CGRectMake(18, 9, 6, 28)];
    [cell addSubview:categoryColor];
    
    switch (indexPath.row) {
      case 0:
        if (interestingSwitch)
          toggle = interestingSwitch;
        else
          toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        toggle.on = [defaults boolForKey:@"postCategory.informative"];
        interestingSwitch = toggle;
        cell.text = @"  Interesting:";
        categoryColor.backgroundColor = [Post colorForPostCategory:@"informative"];
        break;
        
      case 1:
        if (offtopicSwitch)
          toggle = offtopicSwitch;
        else
          toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        toggle.on = [defaults boolForKey:@"postCategory.offtopic"];
        offtopicSwitch = toggle;
        cell.text = @"  Off Topic:";
        categoryColor.backgroundColor = [Post colorForPostCategory:@"offtopic"];
        break;
        
        
      case 2:
        if (randomSwitch)
          toggle = randomSwitch;
        else
          toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        toggle.on = [defaults boolForKey:@"postCategory.stupid"];
        randomSwitch = toggle;
        cell.text = @"  Stupid:";
        categoryColor.backgroundColor = [Post colorForPostCategory:@"stupid"];
        break;
        
        
      case 3:
        if (politicsSwitch)
          toggle = politicsSwitch;
        else
          toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        toggle.on = [defaults boolForKey:@"postCategory.political"];
        politicsSwitch = toggle;
        cell.text = @"  Politics / Religion:";
        categoryColor.backgroundColor = [Post colorForPostCategory:@"political"];
        break;
        
        
      case 4:
        if (nwsSwitch)
          toggle = nwsSwitch;
        else
          toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        toggle.on = [defaults boolForKey:@"postCategory.nwsSwitch"];
        nwsSwitch = toggle;
        cell.text = @"  NWS:";
        categoryColor.backgroundColor = [Post colorForPostCategory:@"nws"];
        break;
    }
    cell.accessoryView = toggle;
  }
  
  
  return [cell autorelease];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

- (void)dealloc {
  [super dealloc];
}


@end
