//
//  SettingsViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController


- (id)init {
  return [super initWithNibName:@"SettingsViewController" bundle:nil];
}

- (IBAction)dismiss:(id)sender {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:usernameField.text forKey:@"username"];
  [defaults setObject:passwordField.text forKey:@"password"];
  
  [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  NSLog([defaults stringForKey:@"username"]);
  
  usernameField.text = [defaults stringForKey:@"username"];
  passwordField.text = [defaults stringForKey:@"password"];
}


- (void)dealloc {
  [super dealloc];
}


@end
