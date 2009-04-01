//
//  SettingsViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate> {
  IBOutlet UITextField *usernameField;
  IBOutlet UITextField *passwordField;
  IBOutlet UITextField *serverField;
  IBOutlet UISwitch    *landscapeSwitch;
  
  IBOutlet UISwitch    *interestingSwitch;
  IBOutlet UIView      *interestingBackground;
  
  IBOutlet UISwitch    *offtopicSwitch;
  IBOutlet UIView      *offtopicBackground;
  
  IBOutlet UISwitch    *randomSwitch;
  IBOutlet UIView      *randomBackground;
  
  IBOutlet UISwitch    *politicsSwitch;
  IBOutlet UIView      *politicsBackground;
  
  IBOutlet UISwitch    *nwsSwitch;
  IBOutlet UIView      *nwsBackground;
}

- (IBAction)dismiss:(id)sender;

@end
