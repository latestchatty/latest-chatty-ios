//
//  SettingsViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009. All rights reserved.
//

#import "Post.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate> {
    IBOutlet UITableView *tableView;
  
    UITextField *usernameField;
    UITextField *passwordField;
    UITextField *serverField;
    UIPickerView *serverPicker;
    
    UITextField *picsUsernameField;
    UITextField *picsPasswordField;
    UISwitch    *picsResizeSwitch;
    UISlider    *picsQualitySlider;
    UILabel     *picsQualityLabel;

    UISwitch    *saveSearchesSwitch;
    UISwitch    *darkModeSwitch;
    UISwitch    *collapseSwitch;
    UISwitch    *landscapeSwitch;
    UISwitch    *lolTagsSwitch;
    UISwitch    *youtubeSwitch;
    UISwitch    *safariSwitch;
    UISwitch    *chromeSwitch;
//    UISwitch    *pushMessagesSwitch;
    UISwitch    *modToolsSwitch;
  
    UISwitch    *interestingSwitch;
    UISwitch    *offtopicSwitch;
    UISwitch    *randomSwitch;
    UISwitch    *politicsSwitch;
    UISwitch    *nwsSwitch;

    IBOutlet UIBarButtonItem *saveButton;
    
    NSArray *apiServerNames;
    NSArray *apiServerAddresses;
}

- (IBAction)dismiss:(id)sender;

- (UITextField *)generateTextFieldWithKey:(NSString *)key;
- (UISwitch *)generateSwitchWithKey:(NSString *)key;
- (UISlider *)generateSliderWithKey:(NSString *)key;
- (UIPickerView *)generatePickerViewWithKey:(NSString *)key;

@end
