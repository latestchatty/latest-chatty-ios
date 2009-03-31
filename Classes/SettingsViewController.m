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
  [defaults setObject:serverField.text   forKey:@"server"];
  [defaults setBool:landscapeSwitch.on   forKey:@"landscape"];
  
  [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  usernameField.text = [defaults stringForKey:@"username"];
  passwordField.text = [defaults stringForKey:@"password"];
  serverField.text   = [[defaults stringForKey:@"server"] stringByReplacingOccurrencesOfRegex:@"http://" withString:@""];
  landscapeSwitch.on = [defaults boolForKey:@"landscape"];
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
