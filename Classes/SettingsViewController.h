//
//  SettingsViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKHelperKit.h"

#import "Post.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate> {
  IBOutlet UITableView *tableView;
  
  IBOutlet UITextField *usernameField;
  IBOutlet UITextField *passwordField;
  IBOutlet UITextField *serverField;
  
  IBOutlet UISwitch    *landscapeSwitch;
  IBOutlet UISwitch    *youtubeSwitch;
  IBOutlet UISwitch    *pushMessagesSwitch;
  
  IBOutlet UISwitch    *interestingSwitch;
  IBOutlet UISwitch    *offtopicSwitch;
  IBOutlet UISwitch    *randomSwitch;
  IBOutlet UISwitch    *politicsSwitch;
  IBOutlet UISwitch    *nwsSwitch;
}

- (IBAction)dismiss:(id)sender;

- (UITextField *)generateTextFieldWithKey:(NSString *)key;
- (UISwitch *)generateSwitchWithKey:(NSString *)key;


@end
