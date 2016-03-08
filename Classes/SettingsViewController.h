//
//  SettingsViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009. All rights reserved.
//

#import "Post.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIGestureRecognizerDelegate> {
    IBOutlet UITableView     *tableView;
    IBOutlet UIBarButtonItem *saveButton;
    IBOutlet UIBarButtonItem *cancelButton;
  
    UITextField  *usernameField;
    UITextField  *passwordField;
    UITextField  *serverField;
    UIPickerView *serverPicker;
    
    UITextField *picsUsernameField;
    UITextField *picsPasswordField;
    UISwitch    *picsResizeSwitch;
    UISlider    *picsQualitySlider;
    UILabel     *picsQualityLabel;

    UISwitch     *orderByPostDateSwitch;
    UISwitch     *saveSearchesSwitch;
    UISwitch     *collapseSwitch;
    UISwitch     *landscapeSwitch;
    UISwitch     *lolTagsSwitch;
    UISwitch     *youTubeSwitch;
    UIPickerView *browserPrefPicker;
    UISwitch     *modToolsSwitch;
    
    UISwitch *pushMessagesSwitch;
    UISwitch *vanityPrefSwitch;
    UISwitch *repliesPrefSwitch;
    
    UISwitch *interestingSwitch;
    UISwitch *offtopicSwitch;
    UISwitch *randomSwitch;
    UISwitch *politicsSwitch;
    UISwitch *nwsSwitch;
    
    NSArray *apiServerNames;
    NSArray *apiServerAddresses;
    
    NSMutableArray *browserTypes;
    NSMutableArray *browserTypesValues;
}

- (IBAction)cancel:(id)sender;
- (IBAction)dismiss:(id)sender;

- (UITextField *)generateTextFieldWithKey:(NSString *)key;
- (UISwitch *)generateSwitchWithKey:(NSString *)key;
- (UISlider *)generateSliderWithKey:(NSString *)key;
- (UIPickerView *)generatePickerViewWithTag:(NSUInteger)tag;

@end
