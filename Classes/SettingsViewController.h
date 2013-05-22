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
  
    UITextField *usernameField;
    UITextField *passwordField;
    UITextField *serverField;
    
    UITextField *picsUsernameField;
    UITextField *picsPasswordField;
    UISwitch    *picsResizeSwitch;
    UISlider    *picsQualitySlider;
    UILabel     *picsQualityLabel;
  
    UISwitch    *landscapeSwitch;
    UISwitch    *youtubeSwitch;
    UISwitch    *safariSwitch;
    UISwitch    *chromeSwitch;
    UISwitch    *pushMessagesSwitch;
    UISwitch    *modToolsSwitch;
  
    UISwitch    *interestingSwitch;
    UISwitch    *offtopicSwitch;
    UISwitch    *randomSwitch;
    UISwitch    *politicsSwitch;
    UISwitch    *nwsSwitch;

    UIBarButtonItem *saveButton;
}

- (IBAction)dismiss:(id)sender;

- (UITextField *)generateTextFieldWithKey:(NSString *)key;
- (UISwitch *)generateSwitchWithKey:(NSString *)key;

@end
