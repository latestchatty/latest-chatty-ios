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

- (id)initWithNib {
    self = [super initWithNib];
	if (self) {
        self.title = @"Settings";
        
        usernameField = [[self generateTextFieldWithKey:@"username"] retain];
        usernameField.placeholder = @"Enter Username";
        usernameField.returnKeyType = UIReturnKeyNext;
        usernameField.keyboardType = UIKeyboardTypeEmailAddress;
        usernameField.textColor = [UIColor colorWithRed:243.0/255.0 green:231.0/255.0 blue:181.0/255.0 alpha:1.0];
        
        passwordField = [[self generateTextFieldWithKey:@"password"] retain];
        passwordField.placeholder = @"Enter Password";
        passwordField.secureTextEntry = YES;
        passwordField.returnKeyType = UIReturnKeyDone;
        
        serverField = [[self generateTextFieldWithKey:@"server"] retain];
        serverField.placeholder = @"shackapi.stonedonkey.com";
        serverField.returnKeyType = UIReturnKeyDone;
        serverField.keyboardType = UIKeyboardTypeURL;
        
        picsUsernameField = [[self generateTextFieldWithKey:@"picsUsername"] retain];
        picsUsernameField.placeholder = @"Enter Username";
        picsUsernameField.returnKeyType = UIReturnKeyNext;
        picsUsernameField.keyboardType = UIKeyboardTypeEmailAddress;
        picsUsernameField.textColor = [UIColor colorWithRed:243.0/255.0 green:231.0/255.0 blue:181.0/255.0 alpha:1.0];
        
        picsPasswordField = [[self generateTextFieldWithKey:@"picsPassword"] retain];
        picsPasswordField.placeholder = @"Enter Password";
        picsPasswordField.secureTextEntry = YES;
        picsPasswordField.returnKeyType = UIReturnKeyDone;
        
        landscapeSwitch  = [[self generateSwitchWithKey:@"landscape"] retain];
        picsResizeSwitch   = [[self generateSwitchWithKey:@"picsResize"] retain];
        picsQualitySlider  = [[self generateSliderWithKey:@"picsQuality"] retain];
        youtubeSwitch      = [[self generateSwitchWithKey:@"embedYoutube"] retain];
        chromeSwitch       = [[self generateSwitchWithKey:@"useChrome"] retain];
        safariSwitch       = [[self generateSwitchWithKey:@"useSafari"] retain];
        pushMessagesSwitch = [[self generateSwitchWithKey:@"push.messages"] retain];
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

- (id)initWithStateDictionary:(NSDictionary *)dictionary {
	return [self init];
}

- (NSDictionary *)stateDictionary {
	return [NSDictionary dictionaryWithObject:@"Settings" forKey:@"type"];
}

- (UITextField *)generateTextFieldWithKey:(NSString *)key {
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 170, 20)];

	textField.returnKeyType = UIReturnKeyNext;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.delegate = self;
	textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    textField.textColor = [UIColor whiteColor];
    textField.keyboardAppearance = UIKeyboardAppearanceAlert;
	
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

-(void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:usernameField.text      forKey:@"username"];
	[defaults setObject:passwordField.text      forKey:@"password"];
    [defaults setObject:picsUsernameField.text  forKey:@"picsUsername"];
    [defaults setObject:picsPasswordField.text  forKey:@"picsPassword"];
	[defaults setBool:landscapeSwitch.on        forKey:@"landscape"];
    [defaults setBool:picsResizeSwitch.on       forKey:@"picsResize"];
    [defaults setFloat:picsQualitySlider.value  forKey:@"picsQuality"];
	[defaults setBool:youtubeSwitch.on          forKey:@"embedYoutube"];
    [defaults setBool:safariSwitch.on           forKey:@"useSafari"];
    [defaults setBool:chromeSwitch .on          forKey:@"useChrome"];
	[defaults setBool:pushMessagesSwitch.on     forKey:@"push.messages"];
    [defaults setBool:modToolsSwitch.on         forKey:@"modTools"];
	
	if (pushMessagesSwitch.on) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    } else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
    
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
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)save {
    [self saveSettings];
    
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [serverField resignFirstResponder];
    [picsUsernameField resignFirstResponder];
    [picsPasswordField resignFirstResponder];
    
    [UIAlertView showSimpleAlertWithTitle:@"Settings"
                                  message:@"Saved!"];
    
    [self.viewDeckController toggleLeftView];   
}

- (void)resignAndToggle {
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [serverField resignFirstResponder];
    [picsUsernameField resignFirstResponder];
    [picsPasswordField resignFirstResponder];
    
    [self.viewDeckController toggleLeftView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],UITextAttributeTextColor,
                                [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5],UITextAttributeTextShadowColor,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                UITextAttributeTextShadowOffset,
                                nil];
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuIcon.24.png"]
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignAndToggle)];
        self.navigationItem.leftBarButtonItem = menuButton;
        [menuButton release];
        
        UIBarButtonItem *saveDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                           style:UIBarButtonItemStyleDone
                                                                          target:self
                                                                          action:@selector(save)];

        [saveDoneButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = saveDoneButton;

        [saveDoneButton release];
    } else {
        [saveButton setTitleTextAttributes:attributes forState:UIControlStateNormal];   
    }
    
    [tableView setSeparatorColor:[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:43.0/255.0 alpha:1.0]];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundView:[[[UIView alloc] init] autorelease]];
    [tableView setBackgroundColor:[UIColor clearColor]];
    
    // iOS 6 allows more built-in customization of switch/slider than iOS 5
    // They won't look the same without subclassing UISwitch, do we care?
    UIColor *blueColor = [UIColor colorWithRed:6.0/255.0 green:109.0/255.0 blue:200.0/255.0 alpha:1.0];
    UIColor *darkGrayColor = [UIColor colorWithRed:66.0/255.0 green:67.0/255.0 blue:70.0/255.0 alpha:1.0];
    UIColor *darkerGrayColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:43.0/255.0 alpha:1.0];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        [[UISwitch appearance] setTintColor:darkerGrayColor];
        [[UISlider appearance] setThumbTintColor:darkGrayColor];
    }
    [[UISwitch appearance] setOnTintColor:blueColor];
    [[UISlider appearance] setMinimumTrackTintColor:blueColor];
    [[UISlider appearance] setMaximumTrackTintColor:darkGrayColor];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

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

#pragma mark Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
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
			return 5;
			break;
			
		case 3:
			return 5;
			break;
			
		default:
			return 0;
			break;
	}
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Shacknews.com Account";
			break;
        
        case 1:
            return @"ChattyPics.com Account";
            break;
			
		case 2:
			return @"Preferences";
			break;
			
		case 3:
			return @"Post Categories";
			break;
			
		default:
			return 0;
			break;
	}
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Generate a custom view with a label for each section
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 44)];
    
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [titleLabel setText:[self titleForHeaderInSection:section]];
    [titleLabel setTextColor:[UIColor colorWithRed:121.0/255.0 green:122.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [titleLabel setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [titleLabel setShadowOffset:CGSizeMake(0, -1.0)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];

    [titleView addSubview:titleLabel];
    
    return titleView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    [cell setBackgroundColor:[UIColor colorWithRed:47.0/255.0 green:48.0/255.0 blue:51.0/255.0 alpha:1.0]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.textLabel setTextColor:[UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:173.0/255.0 alpha:1.0]];
    [cell.textLabel setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [cell.textLabel setShadowOffset:CGSizeMake(0, -1.0)];
    
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
				cell.accessoryView = landscapeSwitch;
				cell.textLabel.text = @"Allow Landscape:";
				break;
                
			case 1:
				cell.accessoryView = youtubeSwitch;
				cell.textLabel.text = @"Embed YouTube:";
				break;
                
            case 2:
				cell.accessoryView = safariSwitch;
				cell.textLabel.text = @"Use Safari:";
				break;
                
			case 3:
				cell.accessoryView = chromeSwitch;
				cell.textLabel.text = @"Use Chrome:";
				break;
				
//			case 3:
//				cell.accessoryView = pushMessagesSwitch;
//				cell.textLabel.text = @"Push Messages:";
//				break;
            
			case 4:
				cell.accessoryView = modToolsSwitch;
				cell.textLabel.text = @"Mod Tools:";
				break;
		}
	}
	
	// Post category toggles
	if (indexPath.section == 3) {
		UIView *categoryColor = [[[UIView alloc] initWithFrame:CGRectMake(18, 9, 6, 28)] autorelease];
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

	return [cell autorelease];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)dealloc {
	[usernameField release];
	[passwordField release];
	[serverField release];
    
    [picsUsernameField release];
    [picsPasswordField release];
    [picsResizeSwitch release];
    [picsQualitySlider release];
	
	[landscapeSwitch release];
    [safariSwitch release];
	[youtubeSwitch release];
	[chromeSwitch release];
	[pushMessagesSwitch release];
	
	[interestingSwitch release];
	[offtopicSwitch release];
	[randomSwitch release];
	[politicsSwitch release];
	[nwsSwitch release];
	
    [saveButton release];
	[super dealloc];
}

@end
