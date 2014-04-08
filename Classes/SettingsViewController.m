//
//  SettingsViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009. All rights reserved.
//

#import "SettingsViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation SettingsViewController

- (id)initWithNib {
    self = [super initWithNib];
	if (self) {
        self.title = @"Settings";
        
        usernameField = [self generateTextFieldWithKey:@"username"];
        usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Username" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        usernameField.returnKeyType = UIReturnKeyNext;
        usernameField.keyboardType = UIKeyboardTypeEmailAddress;
        usernameField.textColor = [UIColor lcAuthorColor];
        
        passwordField = [self generateTextFieldWithKey:@"password"];
        passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Password" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        passwordField.secureTextEntry = YES;
        passwordField.returnKeyType = UIReturnKeyDone;
        
        serverField = [self generateTextFieldWithKey:@"serverApi"];
        serverField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter API Server" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        serverField.returnKeyType = UIReturnKeyDone;
        serverField.keyboardType = UIKeyboardTypeURL;
        
        serverPicker = [self generatePickerViewWithKey:@"serverApi"];
        serverPicker.tintColor = [UIColor darkGrayColor];
        
        picsUsernameField = [self generateTextFieldWithKey:@"picsUsername"];
        picsUsernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Username" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        picsUsernameField.returnKeyType = UIReturnKeyNext;
        picsUsernameField.keyboardType = UIKeyboardTypeEmailAddress;
        picsUsernameField.textColor = [UIColor lcAuthorColor];
        
        picsPasswordField = [self generateTextFieldWithKey:@"picsPassword"];
        picsPasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Password" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        picsPasswordField.secureTextEntry = YES;
        picsPasswordField.returnKeyType = UIReturnKeyDone;

        saveSearchesSwitch = [self generateSwitchWithKey:@"saveSearches"];
//        darkModeSwitch     = [self generateSwitchWithKey:@"darkMode"];
        collapseSwitch     = [self generateSwitchWithKey:@"collapse"];
        landscapeSwitch    = [self generateSwitchWithKey:@"landscape"];
        lolTagsSwitch      = [self generateSwitchWithKey:@"lolTags"];
        picsResizeSwitch   = [self generateSwitchWithKey:@"picsResize"];
        picsQualitySlider  = [self generateSliderWithKey:@"picsQuality"];
        youtubeSwitch      = [self generateSwitchWithKey:@"embedYoutube"];
        chromeSwitch       = [self generateSwitchWithKey:@"useChrome"];
        safariSwitch       = [self generateSwitchWithKey:@"useSafari"];
//        pushMessagesSwitch = [[self generateSwitchWithKey:@"push.messages"] retain];
        modToolsSwitch     = [self generateSwitchWithKey:@"modTools"];
        
        interestingSwitch  = [self generateSwitchWithKey:@"postCategory.informative"];
        offtopicSwitch     = [self generateSwitchWithKey:@"postCategory.offtopic"];
        randomSwitch       = [self generateSwitchWithKey:@"postCategory.stupid"];
        politicsSwitch     = [self generateSwitchWithKey:@"postCategory.political"];
        nwsSwitch          = [self generateSwitchWithKey:@"postCategory.nws"];

        [picsQualitySlider addTarget:self action:@selector(handlePicsQualitySlider:) forControlEvents:UIControlEventValueChanged];
        [safariSwitch addTarget:self action:@selector(handleSafariSwitch) forControlEvents:UIControlEventValueChanged];
        [chromeSwitch addTarget:self action:@selector(handleChromeSwitch) forControlEvents:UIControlEventValueChanged];
    }	
	
	return self;
}

- (id)initWithStateDictionary:(NSDictionary *)dictionary {
	return [self init];
}

- (NSDictionary *)stateDictionary {
	return [NSDictionary dictionaryWithObject:@"Settings" forKey:@"type"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon.24.png"]
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignAndToggle)];
        self.navigationItem.leftBarButtonItem = menuButton;
    }
    
    [saveButton setTitleTextAttributes:[NSDictionary blueTextAttributesDictionary] forState:UIControlStateNormal];
    
    [tableView setSeparatorColor:[UIColor lcGroupedSeparatorColor]];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundView:[[UIView alloc] init]];
    [tableView setBackgroundColor:[UIColor clearColor]];
    
    // iOS7
    self.navigationController.navigationBar.translucent = NO;
    
    // top separation bar
    UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, tableView.frameY, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
    
    // scroll indicator coloring
    [tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    // two possible api servers are hardcoded into the app along with a manual entry possibility
    apiServerNames = @[@"Manual",
                       @"ShackAPI",
                       @"WinChatty"];
    apiServerAddresses = @[@"",
                           @"shackapi.stonedonkey.com",
                           @"winchatty.com/chatty"];
    
    // get the user's saved api server address
    NSString *userServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverApi"];
    NSUInteger index = [apiServerAddresses indexOfObject:userServer];
    // if manually entered API, default the picker to the zero slot (manual)
    // otherwise, set the picker to the server saved in the "serverApi" user default
    if (index == NSNotFound) index = 0;
    [serverPicker selectRow:index inComponent:0 animated:NO];
    [serverPicker reloadComponent:0];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (UITextField *)generateTextFieldWithKey:(NSString *)key {
    CGFloat frameWidth;
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        frameWidth = 220;
    } else {
        frameWidth = 170;
    }
    
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frameWidth, 22)];

	textField.returnKeyType = UIReturnKeyNext;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.delegate = self;
	textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    textField.textColor = [UIColor whiteColor];
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    textField.font = [UIFont systemFontOfSize:16];
	
	return textField;
}

- (UISwitch *)generateSwitchWithKey:(NSString *)key {
	UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
	toggle.on = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
    // moved appearance proxy settings from app delegate to directly on the controls
    [toggle setOnTintColor:[UIColor lcSwitchOnColor]];
    [toggle setTintColor:[UIColor lcSwitchOffColor]];
    
	return toggle;
}

- (UISlider *)generateSliderWithKey:(NSString *)key {
	UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 155, 20)];
    slider.value = [[NSUserDefaults standardUserDefaults] floatForKey:key];
    slider.continuous = YES;
    slider.minimumValue = 0.10f;
    slider.minimumValue = 0.10f;
    
    // moved appearance proxy settings from app delegate to directly on the controls
    // slider appearance proxy was affecting volume slider in video player unintentionaly
    [slider setMaximumTrackTintColor:[UIColor lcSliderMaximumColor]];
    
	return slider;
}

- (UIPickerView *)generatePickerViewWithKey:(NSString *)key {
    CGFloat frameWidth;
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        frameWidth = 220;
    } else {
        frameWidth = 170;
    }
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, 22)];
    
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    picker.clipsToBounds = YES;
    
    return picker;
}

- (void)resignAndToggle {
    [[self view] endEditing:YES];
    
    [self.viewDeckController toggleLeftView];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == usernameField) {
		[passwordField becomeFirstResponder];
	} else if (textField == passwordField) {
		[passwordField resignFirstResponder];
	} else if (textField == serverField) {
		[serverField resignFirstResponder];
	} else if (textField == picsUsernameField) {
        [picsPasswordField becomeFirstResponder];
    } else if (textField == picsPasswordField) {
        [picsPasswordField resignFirstResponder];
    }
	return NO;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	return NO;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    //scroll the tapped text field into view so that it's never under the keyboard on focus
    UITableViewCell *cell = (UITableViewCell *) [[textField superview] superview];
    [tableView scrollToRowAtIndexPath:[tableView indexPathForCell:cell]
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:YES];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark Actions

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [UIAlertView showWithTitle:@"Super Secret Fart Mode"
                           message:@"Allow the farts?"
                          delegate:self
                 cancelButtonTitle:@"No!"
                 otherButtonTitles:@"Yes!", nil];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([[alertView title] isEqualToString:@"Super Secret Fart Mode"]) {
        BOOL allowFarts = NO;
        if (buttonIndex == 1)  {
            allowFarts = YES;
        }
        [[NSUserDefaults standardUserDefaults] setBool:allowFarts forKey:@"superSecretFartMode"];
    }
}

- (void)handlePicsQualitySlider:(UISlider *)slider {
    picsQualityLabel.text = [NSString stringWithFormat:@"Quality: %d%%", (int)(slider.value*100)];
}

-(void)handleSafariSwitch {
    if (safariSwitch.on) {
        [chromeSwitch setOn:NO animated:YES];
    }
}

-(void)handleChromeSwitch {
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Google Chrome"
                                                            message:@"App not found on device, install it first to use this option."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [chromeSwitch setOn:NO animated:YES];
        [alertView show];
    }
    
    if (chromeSwitch.on) {
        [safariSwitch setOn:NO animated:YES];
    }
}

-(void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject:usernameField.text      forKey:@"username"];
	[defaults setObject:passwordField.text      forKey:@"password"];
    [defaults setObject:picsUsernameField.text  forKey:@"picsUsername"];
    [defaults setObject:picsPasswordField.text  forKey:@"picsPassword"];
	[defaults setBool:saveSearchesSwitch.on     forKey:@"saveSearches"];
//	[defaults setBool:darkModeSwitch.on         forKey:@"darkMode"];
	[defaults setBool:collapseSwitch.on         forKey:@"collapse"];
	[defaults setBool:landscapeSwitch.on        forKey:@"landscape"];
	[defaults setBool:lolTagsSwitch.on          forKey:@"lolTags"];
    [defaults setBool:picsResizeSwitch.on       forKey:@"picsResize"];
    
    NSNumber *picsQuality = [NSNumber numberWithFloat:picsQualitySlider.value];
    [defaults setObject:picsQuality             forKey:@"picsQuality"];
    
	[defaults setBool:youtubeSwitch.on          forKey:@"embedYoutube"];
    [defaults setBool:safariSwitch.on           forKey:@"useSafari"];
    [defaults setBool:chromeSwitch .on          forKey:@"useChrome"];
//	[defaults setBool:pushMessagesSwitch.on     forKey:@"push.messages"];
    [defaults setBool:modToolsSwitch.on         forKey:@"modTools"];
	
    //	if (pushMessagesSwitch.on) {
    //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    //    } else {
    //        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    //    }
    
	NSString *serverApi = serverField.text;
	serverApi = [serverApi stringByReplacingOccurrencesOfRegex:@"^http://" withString:@""];
	serverApi = [serverApi stringByReplacingOccurrencesOfRegex:@"/$" withString:@""];
	[defaults setObject:serverApi forKey:@"serverApi"];
	
	[defaults setBool:interestingSwitch.on forKey:@"postCategory.informative"];
	[defaults setBool:offtopicSwitch.on    forKey:@"postCategory.offtopic"];
	[defaults setBool:randomSwitch.on      forKey:@"postCategory.stupid"];
	[defaults setBool:politicsSwitch.on    forKey:@"postCategory.political"];
	[defaults setBool:nwsSwitch.on         forKey:@"postCategory.nws"];
	
	[defaults synchronize];
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
	[store setObject:usernameField.text      forKey:@"username"];
	[store setObject:passwordField.text      forKey:@"password"];
    [store setObject:picsUsernameField.text  forKey:@"picsUsername"];
    [store setObject:picsPasswordField.text  forKey:@"picsPassword"];
	[store setBool:saveSearchesSwitch.on     forKey:@"saveSearches"];
//	[store setBool:darkModeSwitch.on         forKey:@"darkMode"];
	[store setBool:collapseSwitch.on         forKey:@"collapse"];
//	[store setBool:landscapeSwitch.on        forKey:@"landscape"];
	[store setBool:lolTagsSwitch.on          forKey:@"lolTags"];
    [store setBool:picsResizeSwitch.on       forKey:@"picsResize"];
    [store setObject:picsQuality             forKey:@"picsQuality"];
	[store setBool:youtubeSwitch.on          forKey:@"embedYoutube"];
    [store setBool:safariSwitch.on           forKey:@"useSafari"];
    [store setBool:chromeSwitch .on          forKey:@"useChrome"];
//	[store setBool:pushMessagesSwitch.on     forKey:@"push.messages"];
    [store setBool:modToolsSwitch.on         forKey:@"modTools"];
	[store setObject:serverApi               forKey:@"serverApi"];
	[store setBool:interestingSwitch.on      forKey:@"postCategory.informative"];
	[store setBool:offtopicSwitch.on         forKey:@"postCategory.offtopic"];
	[store setBool:randomSwitch.on           forKey:@"postCategory.stupid"];
	[store setBool:politicsSwitch.on         forKey:@"postCategory.political"];
	[store setBool:nwsSwitch.on              forKey:@"postCategory.nws"];
    
    [store synchronize];
    
    [Crashlytics setUserName:[defaults stringForKey:@"username"]];
}

- (IBAction)dismiss:(id)sender {
    [self saveSettings];
	
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openCredits {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushBrowserForCredits" object:nil];
    }];
}

- (void)openLicenses {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushBrowserForLicenses" object:nil];
    }];
}

- (void)openDonate {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushBrowserForDonate" object:nil];
    }];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 4;
			break;
        case 1:
            return 4;
            break;
			
		case 2:
			return 8;
			break;
			
		case 3:
			return 5;
			break;
            
        case 4:
            return 2;
            break;
			
		default:
			return 0;
			break;
	}
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"SHACKNEWS.COM ACCOUNT";
			break;
        
        case 1:
            return @"CHATTYPICS.COM ACCOUNT";
            break;
			
		case 2:
			return @"PREFERENCES";
			break;
			
		case 3:
			return @"POST CATEGORIES";
			break;
        
        case 4:
            return @"ABOUT";
            break;
			
		default:
			return 0;
			break;
	}
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Generate a custom view with a label for each section
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 280, 44)];
    
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    [titleLabel setText:[self titleForHeaderInSection:section]];
    [titleLabel setTextColor:[UIColor lcGroupedTitleColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];

    [titleView addSubview:titleLabel];
    
    return titleView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [cell setBackgroundColor:[UIColor lcGroupedCellColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setClipsToBounds: YES];
    
    [cell.textLabel setTextColor:[UIColor lcGroupedCellLabelColor]];
    [cell.textLabel setShadowColor:[UIColor lcTextShadowColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0, -1.0)];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    
	// username/password/server text entry fields
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				cell.accessoryView = usernameField;
				cell.textLabel.text = @"Username:";
				break;
				
			case 1:
				cell.accessoryView = passwordField;
				cell.textLabel.text = @"Password:";
				break;
				
            case 2:
                cell.accessoryView = serverPicker;
                cell.textLabel.text = @"API Selector:";
                break;
                
			case 3:
				cell.accessoryView = serverField;
				cell.textLabel.text = @"API Server:";
				break;
		}
	}
    
    // ChattyPics text fields
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.accessoryView = picsUsernameField;
                cell.textLabel.text = @"Username:";
                break;
            
            case 1:
                cell.accessoryView = picsPasswordField;
                cell.textLabel.text = @"Password:";
                break;
                
            case 2:
				cell.accessoryView = picsQualitySlider;
				cell.textLabel.text = [NSString stringWithFormat:@"Quality: %d%%", (int)(picsQualitySlider.value*100)];
                picsQualityLabel = cell.textLabel;
				break;
                
            case 3:
				cell.accessoryView = picsResizeSwitch;
				cell.textLabel.text = @"Scale Uploads:";
				break;
        }
    }
	
	// Preference toggles
	if (indexPath.section == 2) {
		switch (indexPath.row) {
            case 0:
				cell.accessoryView = collapseSwitch;
				cell.textLabel.text = @"Allow Collapse:";
				break;
                
            case 1:
				cell.accessoryView = landscapeSwitch;
				cell.textLabel.text = @"Allow Landscape:";
				break;
                
			case 2:
				cell.accessoryView = youtubeSwitch;
				cell.textLabel.text = @"Embed YouTube:";
				break;
                
            case 3:
				cell.accessoryView = lolTagsSwitch;
				cell.textLabel.text = @"Enable [lol] Tags:";
				break;
                
			case 4:
				cell.accessoryView = modToolsSwitch;
				cell.textLabel.text = @"Enable Mod Tools:";
				break;
                
			case 5:
				cell.accessoryView = saveSearchesSwitch;
				cell.textLabel.text = @"Save Searches:";
				break;
                
            case 6:
				cell.accessoryView = safariSwitch;
				cell.textLabel.text = @"Use Safari:";
				break;
                
			case 7:
				cell.accessoryView = chromeSwitch;
				cell.textLabel.text = @"Use Chrome:";
				break;
				
//			case 1:
//				cell.accessoryView = darkModeSwitch;
//				cell.textLabel.text = @"Dark Mode:";
//				break;
                
//			case 3:
//				cell.accessoryView = pushMessagesSwitch;
//				cell.textLabel.text = @"Push Messages:";
//				break;
		}
	}
	
	// Post category toggles
	if (indexPath.section == 3) {
        UIView *categoryColor = [[UIView alloc] initWithFrame:CGRectMake(18, 9, 4, 28)];
		[cell addSubview:categoryColor];
		
		switch (indexPath.row) {
			case 0:
				cell.accessoryView = interestingSwitch;
				cell.textLabel.text = @"  Interesting:";
				categoryColor.backgroundColor = [Post colorForPostCategory:@"informative"];
				break;
                
			case 1:
				cell.accessoryView = offtopicSwitch;
				cell.textLabel.text = @"  Off Topic:";
				categoryColor.backgroundColor = [Post colorForPostCategory:@"offtopic"];
				break;
                
			case 2:
				cell.accessoryView = politicsSwitch;
				cell.textLabel.text = @"  Politics / Religion:";
				categoryColor.backgroundColor = [Post colorForPostCategory:@"political"];
				break;
				
			case 3:
				cell.accessoryView = randomSwitch;
				cell.textLabel.text = @"  Stupid:";
				categoryColor.backgroundColor = [Post colorForPostCategory:@"stupid"];
				break;
                
			case 4:
				cell.accessoryView = nwsSwitch;
				cell.textLabel.text = @"  NWS:";
				categoryColor.backgroundColor = [Post colorForPostCategory:@"nws"];
				break;
		}
	}
    
    if (indexPath.section == 4) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        switch (indexPath.row) {
			case 0:
                [button setFrame:CGRectMake(0, 0, 50, 30)];
                [button setTitle:@"View" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor lcBlueColor] forState:UIControlStateNormal];

                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];

                button.layer.cornerRadius = 5;
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor lcBlueColor].CGColor;
                
                [button addTarget:self action:@selector(openCredits) forControlEvents:UIControlEventTouchUpInside];
                
                cell.accessoryView = button;
                cell.textLabel.text = @"Credits:";
                
                break;
			case 1:
                [button setFrame:CGRectMake(0, 0, 50, 30)];
                [button setTitle:@"View" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor lcBlueColor] forState:UIControlStateNormal];
                
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                
                button.layer.cornerRadius = 5;
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor lcBlueColor].CGColor;
                
                [button addTarget:self action:@selector(openLicenses) forControlEvents:UIControlEventTouchUpInside];
                
                cell.accessoryView = button;
                cell.textLabel.text = @"Licenses:";
                
                break;
			case 2:
                [button setFrame:CGRectMake(0, 0, 50, 30)];
                [button setTitle:@"View" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor lcBlueColor] forState:UIControlStateNormal];
                
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
                
                button.layer.cornerRadius = 5;
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor lcBlueColor].CGColor;
                
                [button addTarget:self action:@selector(openDonate) forControlEvents:UIControlEventTouchUpInside];
                
                cell.accessoryView = button;
                cell.textLabel.text = @"Donate:";
                
                break;
        }
    }

	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

#pragma mark UIPickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    serverField.text = apiServerAddresses[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return apiServerNames.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *title = apiServerNames[row];
    
    // dumb hack to change the font color within a picker view
    // create an attributed string and set it in the label after getting a reference to the label for this row
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.attributedText = attributedTitle;
    }
    return label;
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    tableView.delegate = nil;
}

@end
