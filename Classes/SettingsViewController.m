//
//  SettingsViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009. All rights reserved.
//

#import "SettingsViewController.h"
#import "RegexKitLite.h"

@implementation SettingsViewController

- (id)initWithNib {
    self = [super initWithNib];
	if (self) {
        self.title = @"Settings";
        
        usernameField = [[self generateTextFieldWithKey:@"username"] retain];
        usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Username" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        usernameField.returnKeyType = UIReturnKeyNext;
        usernameField.keyboardType = UIKeyboardTypeEmailAddress;
        usernameField.textColor = [UIColor lcAuthorColor];
        
        passwordField = [[self generateTextFieldWithKey:@"password"] retain];
        passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Password" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        passwordField.secureTextEntry = YES;
        passwordField.returnKeyType = UIReturnKeyDone;
        
        serverField = [[self generateTextFieldWithKey:@"server"] retain];
        serverField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"shackapi.stonedonkey.com" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        serverField.returnKeyType = UIReturnKeyDone;
        serverField.keyboardType = UIKeyboardTypeURL;
        
        picsUsernameField = [[self generateTextFieldWithKey:@"picsUsername"] retain];
        picsUsernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Username" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        picsUsernameField.returnKeyType = UIReturnKeyNext;
        picsUsernameField.keyboardType = UIKeyboardTypeEmailAddress;
        picsUsernameField.textColor = [UIColor lcAuthorColor];
        
        picsPasswordField = [[self generateTextFieldWithKey:@"picsPassword"] retain];
        picsPasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Password" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
        picsPasswordField.secureTextEntry = YES;
        picsPasswordField.returnKeyType = UIReturnKeyDone;

        darkModeSwitch     = [[self generateSwitchWithKey:@"darkMode"] retain];
        collapseSwitch     = [[self generateSwitchWithKey:@"collapse"] retain];
        landscapeSwitch    = [[self generateSwitchWithKey:@"landscape"] retain];
        picsResizeSwitch   = [[self generateSwitchWithKey:@"picsResize"] retain];
        picsQualitySlider  = [[self generateSliderWithKey:@"picsQuality"] retain];
        youtubeSwitch      = [[self generateSwitchWithKey:@"embedYoutube"] retain];
        chromeSwitch       = [[self generateSwitchWithKey:@"useChrome"] retain];
        safariSwitch       = [[self generateSwitchWithKey:@"useSafari"] retain];
//        pushMessagesSwitch = [[self generateSwitchWithKey:@"push.messages"] retain];
        modToolsSwitch     = [[self generateSwitchWithKey:@"modTools"] retain];
        
        interestingSwitch  = [[self generateSwitchWithKey:@"postCategory.informative"] retain];
        offtopicSwitch     = [[self generateSwitchWithKey:@"postCategory.offtopic"] retain];
        randomSwitch       = [[self generateSwitchWithKey:@"postCategory.stupid"] retain];
        politicsSwitch     = [[self generateSwitchWithKey:@"postCategory.political"] retain];
        nwsSwitch          = [[self generateSwitchWithKey:@"postCategory.nws"] retain];

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
        [menuButton release];
    }
    
    [saveButton setTitleTextAttributes:[NSDictionary blueTextAttributesDictionary] forState:UIControlStateNormal];
    
    [tableView setSeparatorColor:[UIColor lcGroupedSeparatorColor]];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundView:[[[UIView alloc] init] autorelease]];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setContentInset:UIEdgeInsetsMake(64.0, 0, 0, 0)];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [usernameField resignFirstResponder];
//    [passwordField resignFirstResponder];
//    [serverField resignFirstResponder];
//    [picsUsernameField resignFirstResponder];
//    [picsPasswordField resignFirstResponder];
    [self.view endEditing:YES];
}

- (UITextField *)generateTextFieldWithKey:(NSString *)key {
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 21)];

	textField.returnKeyType = UIReturnKeyNext;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.delegate = self;
	textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    textField.textColor = [UIColor whiteColor];
    textField.keyboardAppearance = UIKeyboardAppearanceAlert;
    textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
	
	return [textField autorelease];
}

- (UISwitch *)generateSwitchWithKey:(NSString *)key {
	UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
	toggle.on = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
	return [toggle autorelease];
}

- (UISlider *)generateSliderWithKey:(NSString *)key {
	UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 155, 20)];
    slider.value = [[NSUserDefaults standardUserDefaults] floatForKey:key];
    slider.continuous = YES;
    slider.minimumValue = 0.10f;
    slider.minimumValue = 0.10f;
    
	return [slider autorelease];
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

#pragma mark Actions

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
        [alertView release];
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
	[defaults setBool:darkModeSwitch.on         forKey:@"darkMode"];
	[defaults setBool:collapseSwitch.on         forKey:@"collapse"];
	[defaults setBool:landscapeSwitch.on        forKey:@"landscape"];
    [defaults setBool:picsResizeSwitch.on       forKey:@"picsResize"];
    [defaults setFloat:picsQualitySlider.value  forKey:@"picsQuality"];
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
    
	NSString *serverAddress = serverField.text;
	serverAddress = [serverAddress stringByReplacingOccurrencesOfRegex:@"^http://" withString:@""];
	serverAddress = [serverAddress stringByReplacingOccurrencesOfRegex:@"/$" withString:@""];
	[defaults setObject:serverAddress forKey:@"server"];
	
	[defaults setBool:interestingSwitch.on forKey:@"postCategory.informative"];
	[defaults setBool:offtopicSwitch.on    forKey:@"postCategory.offtopic"];
	[defaults setBool:randomSwitch.on      forKey:@"postCategory.stupid"];
	[defaults setBool:politicsSwitch.on    forKey:@"postCategory.political"];
	[defaults setBool:nwsSwitch.on         forKey:@"postCategory.nws"];
	
	[defaults synchronize];
}

- (IBAction)dismiss:(id)sender {
    [self saveSettings];
	
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)save {
    [self saveSettings];
    
//    [usernameField resignFirstResponder];
//    [passwordField resignFirstResponder];
//    [serverField resignFirstResponder];
//    [picsUsernameField resignFirstResponder];
//    [picsPasswordField resignFirstResponder];
    [self.view endEditing:YES];
    
    [UIAlertView showSimpleAlertWithTitle:@"Settings"
                                  message:@"Saved!"];
    
    [self.viewDeckController toggleLeftView];
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 3;
			break;
        case 1:
            return 4;
            break;
			
		case 2:
			return 7;
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
    
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [titleLabel setText:[self titleForHeaderInSection:section]];
    [titleLabel setTextColor:[UIColor lcGroupedTitleColor]];
//    [titleLabel setShadowColor:[UIColor lcTextShadowColor]];
//    [titleLabel setShadowOffset:CGSizeMake(0, -1.0)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];

    [titleView addSubview:titleLabel];
    
    return titleView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [cell setBackgroundColor:[UIColor lcGroupedCellColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.textLabel setTextColor:[UIColor lcGroupedCellLabelColor]];
    [cell.textLabel setShadowColor:[UIColor lcTextShadowColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0, -1.0)];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    
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
				cell.accessoryView = picsResizeSwitch;
				cell.textLabel.text = @"Scale Uploads:";
				break;
                
            case 3:
				cell.accessoryView = picsQualitySlider;
				cell.textLabel.text = [NSString stringWithFormat:@"Quality: %d%%", (int)(picsQualitySlider.value*100)];
                picsQualityLabel = cell.textLabel;
				break;
        }
    }
	
	// Preference toggles
	if (indexPath.section == 2) {
		switch (indexPath.row) {
			case 0:
				cell.accessoryView = darkModeSwitch;
				cell.textLabel.text = @"Dark Mode:";
				break;
			
            case 1:
				cell.accessoryView = collapseSwitch;
				cell.textLabel.text = @"Allow Collapse:";
				break;
			
            case 2:
				cell.accessoryView = landscapeSwitch;
				cell.textLabel.text = @"Allow Landscape:";
				break;
                
			case 3:
				cell.accessoryView = youtubeSwitch;
				cell.textLabel.text = @"Embed YouTube:";
				break;
                
            case 4:
				cell.accessoryView = safariSwitch;
				cell.textLabel.text = @"Use Safari:";
				break;
                
			case 5:
				cell.accessoryView = chromeSwitch;
				cell.textLabel.text = @"Use Chrome:";
				break;
				
//			case 3:
//				cell.accessoryView = pushMessagesSwitch;
//				cell.textLabel.text = @"Push Messages:";
//				break;
            
			case 6:
				cell.accessoryView = modToolsSwitch;
				cell.textLabel.text = @"Mod Tools:";
				break;
		}
	}
	
	// Post category toggles
	if (indexPath.section == 3) {
        CGFloat categoryXOffset;
        if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
            categoryXOffset = 36;
        } else {
            categoryXOffset = 18;
        }
        UIView *categoryColor = [[[UIView alloc] initWithFrame:CGRectMake(categoryXOffset, 9, 4, 28)] autorelease];
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
				cell.accessoryView = randomSwitch;
				cell.textLabel.text = @"  Stupid:";
				categoryColor.backgroundColor = [Post colorForPostCategory:@"stupid"];
				break;
				
			case 3:
				cell.accessoryView = politicsSwitch;
				cell.textLabel.text = @"  Politics / Religion:";
				categoryColor.backgroundColor = [Post colorForPostCategory:@"political"];
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
                [button setTitleColor:[UIColor lcIOS7BlueColor] forState:UIControlStateNormal];

                [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
                
                [button addTarget:self action:@selector(openCredits) forControlEvents:UIControlEventTouchUpInside];
                
                cell.accessoryView = button;
                cell.textLabel.text = @"Credits:";
                
                break;
			case 1:
                [button setFrame:CGRectMake(0, 0, 50, 30)];
                [button setTitle:@"View" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor lcIOS7BlueColor] forState:UIControlStateNormal];
                
                [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
                
                [button addTarget:self action:@selector(openLicenses) forControlEvents:UIControlEventTouchUpInside];
                
                cell.accessoryView = button;
                cell.textLabel.text = @"Licenses:";
                
                break;
        }
    }

	return [cell autorelease];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
	[usernameField release];
	[passwordField release];
	[serverField release];
    
    [picsUsernameField release];
    [picsPasswordField release];
    [picsResizeSwitch release];
    [picsQualitySlider release];
	
    [darkModeSwitch release];
    [collapseSwitch release];
	[landscapeSwitch release];
	[youtubeSwitch release];
    [safariSwitch release];
	[chromeSwitch release];
	[pushMessagesSwitch release];
    [modToolsSwitch release];
	
	[interestingSwitch release];
	[offtopicSwitch release];
	[randomSwitch release];
	[politicsSwitch release];
	[nwsSwitch release];
	
    [saveButton release];
    
//    [tableView release];
    
	[super dealloc];
}

@end
