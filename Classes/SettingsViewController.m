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
  
  [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  usernameField.text = [defaults stringForKey:@"username"];
  passwordField.text = [defaults stringForKey:@"password"];
  serverField.text   = [defaults stringForKey:@"server"];
  
  landscapeSwitch.on = [defaults boolForKey:@"landscape"];
  youtubeSwitch.on   = [defaults boolForKey:@"embedYoutube"];

  
  // Filter switches
  interestingSwitch.on  = [defaults boolForKey:@"postCategory.informative"];
  offtopicSwitch.on     = [defaults boolForKey:@"postCategory.offtopic"];
  randomSwitch.on       = [defaults boolForKey:@"postCategory.stupid"];
  politicsSwitch.on     = [defaults boolForKey:@"postCategory.political"];
  nwsSwitch.on          = [defaults boolForKey:@"postCategory.nws"];
  
  // Set filter background colors
  interestingBackground.backgroundColor = [Post colorForPostCategory:@"informative"];
  offtopicBackground.backgroundColor    = [Post colorForPostCategory:@"offtopic"];
  randomBackground.backgroundColor      = [Post colorForPostCategory:@"stupid"];
  politicsBackground.backgroundColor    = [Post colorForPostCategory:@"political"];
  nwsBackground.backgroundColor         = [Post colorForPostCategory:@"nws"];
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

- (void)dealloc {
  [super dealloc];
}


@end
