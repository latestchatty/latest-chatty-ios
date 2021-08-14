//
//  SettingsViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009. All rights reserved.
//

#import "SettingsViewController.h"
#import "LCBrowserType.h"
#import "MBProgressHUD.h"

static NSString *kWoggleBaseUrl = @"http://www.woggle.net/lcappnotification";
static NSString *kWoggleKeywordsUrl = @"https://www.woggle.net/notifications";
static NSString *kCreditsUrl = @"http://mccrager.com/latestchatty/credits";
static NSString *kLicensesUrl = @"http://mccrager.com/latestchatty/licenses";
static NSString *kGuidelinesUrl = @"https://www.shacknews.com/guidelines";

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
        
        serverPicker = [self generatePickerViewWithTag:0];

        orderByPostDateSwitch = [self generateSwitchWithKey:@"orderByPostDate"];
        saveSearchesSwitch = [self generateSwitchWithKey:@"saveSearches"];
        swipeBackSwitch    = [self generateSwitchWithKey:@"swipeBack"];
        collapseSwitch     = [self generateSwitchWithKey:@"collapse"];
        lolTagsSwitch      = [self generateSwitchWithKey:@"lolTags"];
        picsResizeSwitch   = [self generateSwitchWithKey:@"picsResize"];
        picsQualitySlider  = [self generateSliderWithKey:@"picsQuality"];
        youTubeSwitch      = [self generateSwitchWithKey:@"useYouTube"];
        browserPrefPicker  = [self generatePickerViewWithTag:1];
        modToolsSwitch     = [self generateSwitchWithKey:@"modTools"];
        
        pushMessagesSwitch = [self generateSwitchWithKey:@"pushMessages"];
        pushMessagesSwitch.enabled = [[[NSUserDefaults standardUserDefaults] valueForKey:@"username"] length] > 0;
        [pushMessagesSwitch addTarget:self action:@selector(handleSwitchState:) forControlEvents:UIControlEventValueChanged];
        vanityPrefSwitch  = [self generateSwitch];
        vanityPrefSwitch.enabled = NO;
        repliesPrefSwitch = [self generateSwitch];
        repliesPrefSwitch.enabled = NO;
        
        interestingSwitch  = [self generateSwitchWithKey:@"postCategory.informative"];
        offtopicSwitch     = [self generateSwitchWithKey:@"postCategory.offtopic"];
        randomSwitch       = [self generateSwitchWithKey:@"postCategory.stupid"];
        politicsSwitch     = [self generateSwitchWithKey:@"postCategory.political"];
        nwsSwitch          = [self generateSwitchWithKey:@"postCategory.nws"];

        [picsQualitySlider addTarget:self action:@selector(handlePicsQualitySlider:) forControlEvents:UIControlEventValueChanged];
        [youTubeSwitch addTarget:self action:@selector(handleYouTubeSwitch) forControlEvents:UIControlEventValueChanged];
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
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu-Button-List.png"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self.viewDeckController
                                                                      action:@selector(toggleLeftView)];
        self.navigationItem.leftBarButtonItem = menuButton;
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(saveSettings)];
        [saveButton setTitleTextAttributes:[NSDictionary blueTextAttributesDictionary] forState:UIControlStateNormal];
        [saveButton setTitleTextAttributes:[NSDictionary blueHighlightTextAttributesDictionary] forState:UIControlStateDisabled];
        
        self.navigationItem.rightBarButtonItem = saveButton;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *shackUserName = [defaults valueForKey:@"username"];
    BOOL pushEnabled = [defaults boolForKey:@"pushMessages"];
    
    // get their current woggle notification prefs
    if ([shackUserName length] > 0 && pushEnabled) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager GET:[NSString stringWithFormat:@"%@/getuser.php", kWoggleBaseUrl]
          parameters:@{@"user": shackUserName}
            progress:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                  
                  // update switches with results of pref fetch
                  BOOL vanity = YES;
                  BOOL replies = YES;
                  if ([responseObject objectForKey:@"get_vanity"]) {
                      vanity = [responseObject boolForKey:@"get_vanity"];
                  }
                  if ([responseObject objectForKey:@"get_replies"]) {
                      replies = [responseObject boolForKey:@"get_replies"];
                  }

                self->vanityPrefSwitch.on = vanity;
                self->vanityPrefSwitch.enabled = YES;
                self->repliesPrefSwitch.on = replies;
                self->repliesPrefSwitch.enabled = YES;
            }
            failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog( @"getuser fail: %@", error );
            }];
    }
    
    [saveButton setTitleTextAttributes:[NSDictionary blueTextAttributesDictionary] forState:UIControlStateNormal];
    [cancelButton setTitleTextAttributes:[NSDictionary cancelTextAttributesDictionary] forState:UIControlStateNormal];
    
    [tableView setSeparatorColor:[UIColor lcGroupedSeparatorColor]];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundView:[[UIView alloc] init]];
    [tableView setBackgroundColor:[UIColor clearColor]];
    
    // top separation bar
    UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, tableView.frameY, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
    
    // scroll indicator coloring
    [tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    // two possible api servers are hardcoded into the app along with a manual entry possibility
    apiServerNames = @[@"Manual",
                       @"WinChatty"];
    apiServerAddresses = @[@"",
                           @"winchatty.com/chatty"];
    
    // get the user's saved api server address
    NSString *userServer = [defaults objectForKey:@"serverApi"];
    NSUInteger serverIndex = [apiServerAddresses indexOfObject:userServer];
    // if manually entered API, default the picker to the zero slot (manual)
    // otherwise, set the picker to the server saved in the "serverApi" user default
    if (serverIndex == NSNotFound) serverIndex = 0;
    [serverPicker selectRow:serverIndex inComponent:0 animated:NO];
    [serverPicker reloadComponent:0];
    
    // available browser types vary based on availability of apps & iOS version
    browserTypes = [[NSMutableArray alloc] init];
    browserTypesValues = [[NSMutableArray alloc] init];
    // everyone gets web view
    [browserTypes addObject:@"Web View"];
    [browserTypesValues addObject:[NSNumber numberWithInteger:LCBrowserTypeWebView]];
    // only iOS 9+ can use safari view
    if ([self canOpenSafariView]) {
        [browserTypes addObject:@"Safari View"];
        [browserTypesValues addObject:[NSNumber numberWithInteger:LCBrowserTypeSafariView]];
    }
    // everyone gets safari app
    [browserTypes addObject:@"Safari App"];
    [browserTypesValues addObject:[NSNumber numberWithInteger:LCBrowserTypeSafariApp]];
    //only users with chrome installed
    if ([self canOpenChromeApp]) {
        [browserTypes addObject:@"Chrome App"];
        [browserTypesValues addObject:[NSNumber numberWithInteger:LCBrowserTypeChromeApp]];
    }
    
    // get the user's browser preference
    NSNumber *browserPref = [NSNumber numberWithInteger:[defaults integerForKey:@"browserPref"]];
    NSUInteger browserPrefIndex = [browserTypesValues indexOfObject:browserPref];
    // if the user's browser preference is no longer available on device, default back to web view
    if (browserPrefIndex == NSNotFound) browserPrefIndex = 0;
    [browserPrefPicker selectRow:browserPrefIndex inComponent:0 animated:NO];
    [browserPrefPicker reloadComponent:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWogglePrefs:) name:@"UpdateWogglePrefs" object:nil];
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

- (UISwitch *)generateSwitch {
    UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
    toggle.on = NO;
    
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

- (UIPickerView *)generatePickerViewWithTag:(NSUInteger)tag {
    CGFloat frameWidth;
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        frameWidth = 220;
    } else {
        frameWidth = 170;
    }
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, 88)];
    
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    picker.clipsToBounds = YES;
    picker.tintColor = [UIColor darkGrayColor];
    picker.tag = tag;
    
    return picker;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == usernameField) {
		[passwordField becomeFirstResponder];
        
        pushMessagesSwitch.enabled = [usernameField.text length] > 0;
	} else if (textField == passwordField) {
		[passwordField resignFirstResponder];
	} else if (textField == serverField) {
		[serverField resignFirstResponder];
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

-(BOOL)canOpenChromeApp {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]];
}

-(BOOL)canOpenSafariView {
    return NSClassFromString(@"SFSafariViewController") != nil;
}

-(void)handleYouTubeSwitch {
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"youtube://"]]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"YouTube"
                                                            message:@"App not found on device, install it first to use this option."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [youTubeSwitch setOn:NO animated:YES];
        [alertView show];
    }
}

-(void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (pushMessagesSwitch.on && [usernameField.text length] > 0) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *adduserParameters =
        @{@"action": @"add",
          @"type": @"user",
          @"user": usernameField.text,
          @"getvanity": vanityPrefSwitch.on ? @"1" : @"0",
          @"getreplies": repliesPrefSwitch.on ? @"1" : @"0"};
        NSLog(@"calling adduser w/ parameters: %@", adduserParameters);
        [manager GET:[NSString stringWithFormat:@"%@/change.php", kWoggleBaseUrl]
          parameters:adduserParameters
            progress:nil
             success:nil
             failure:^(NSURLSessionDataTask *task, NSError *error) {
                 NSLog( @"adduser fail: %@", error );
             }];
    }
    
	[defaults setObject:usernameField.text      forKey:@"username"];
	[defaults setObject:passwordField.text      forKey:@"password"];
	[defaults setBool:orderByPostDateSwitch.on  forKey:@"orderByPostDate"];
    [defaults setBool:saveSearchesSwitch.on     forKey:@"saveSearches"];
    [defaults setBool:swipeBackSwitch.on        forKey:@"swipeBack"];
	[defaults setBool:collapseSwitch.on         forKey:@"collapse"];
	[defaults setBool:lolTagsSwitch.on          forKey:@"lolTags"];
    [defaults setBool:picsResizeSwitch.on       forKey:@"picsResize"];
    
    NSNumber *picsQuality = [NSNumber numberWithFloat:picsQualitySlider.value];
    [defaults setObject:picsQuality             forKey:@"picsQuality"];
    
	[defaults setBool:youTubeSwitch.on          forKey:@"useYouTube"];
    [defaults setInteger:[browserTypesValues[[browserPrefPicker selectedRowInComponent:0]] integerValue] forKey:@"browserPref"];
    [defaults setBool:modToolsSwitch.on         forKey:@"modTools"];
    
	NSString *serverApi = serverField.text;
	serverApi = [serverApi stringByReplacingOccurrencesOfRegex:@"^http://" withString:@""];
	serverApi = [serverApi stringByReplacingOccurrencesOfRegex:@"/$" withString:@""];
	[defaults setObject:serverApi forKey:@"serverApi"];
	
    [defaults setBool:pushMessagesSwitch.on     forKey:@"pushMessages"];
    
	[defaults setBool:interestingSwitch.on forKey:@"postCategory.informative"];
	[defaults setBool:offtopicSwitch.on    forKey:@"postCategory.offtopic"];
	[defaults setBool:randomSwitch.on      forKey:@"postCategory.stupid"];
	[defaults setBool:politicsSwitch.on    forKey:@"postCategory.political"];
	[defaults setBool:nwsSwitch.on         forKey:@"postCategory.nws"];
	
	[defaults synchronize];
    
    // settings stored in iCloud should be mapped here
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
	[store setObject:usernameField.text      forKey:@"username"];
	[store setObject:passwordField.text      forKey:@"password"];
	[store setBool:orderByPostDateSwitch.on  forKey:@"orderByPostDate"];
    [store setBool:saveSearchesSwitch.on     forKey:@"saveSearches"];
    [store setBool:swipeBackSwitch.on        forKey:@"swipeBack"];
	[store setBool:collapseSwitch.on         forKey:@"collapse"];
	[store setBool:lolTagsSwitch.on          forKey:@"lolTags"];
    [store setBool:picsResizeSwitch.on       forKey:@"picsResize"];
    [store setObject:picsQuality             forKey:@"picsQuality"];
	[store setBool:youTubeSwitch.on          forKey:@"useYouTube"];
    [store setBool:modToolsSwitch.on         forKey:@"modTools"];
	[store setObject:serverApi               forKey:@"serverApi"];
	[store setBool:interestingSwitch.on      forKey:@"postCategory.informative"];
	[store setBool:offtopicSwitch.on         forKey:@"postCategory.offtopic"];
	[store setBool:randomSwitch.on           forKey:@"postCategory.stupid"];
	[store setBool:politicsSwitch.on         forKey:@"postCategory.political"];
	[store setBool:nwsSwitch.on              forKey:@"postCategory.nws"];
    
    [store synchronize];
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        //show pin HUD message
        NSTimeInterval theTimeInterval = 0.75;
        MBProgressHUD *hud =
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow]
                                 animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.label.text = @"Saved!";
        hud.bezelView.color = [UIColor lcGroupedCellColor];
        [hud hideAnimated:YES afterDelay:theTimeInterval];
        
        [[self.navigationController viewDeckController] openLeftView];
    }
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismiss:(id)sender {
    [self saveSettings];
	
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handlePasswordTap:(UITapGestureRecognizer *)recognizer {
    BOOL current = [passwordField isSecureTextEntry];
    [passwordField setSecureTextEntry:!current];
}

- (void)openCredits {
    NSString *urlString = kCreditsUrl;
    [self openURL:[NSURL URLWithString:urlString]];
}

- (void)openLicenses {
    NSString *urlString = kLicensesUrl;
    [self openURL:[NSURL URLWithString:urlString]];
}

- (void)openGuidelines {
    NSString *urlString = kGuidelinesUrl;
    [self openURL:[NSURL URLWithString:urlString]];
}

- (void)openKeywords {
    NSString *urlString = kWoggleKeywordsUrl;
    [self openURL:[NSURL URLWithString:urlString]];
}

- (void)openURL:(NSURL *)url {
    [self safariViewControllerForURL:url];
}

#pragma mark Web View methods

- (void)safariViewControllerForURL:(NSURL *)url {
    SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
    [svc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [svc setModalPresentationStyle:UIModalPresentationFormSheet];
    [svc setDelegate:self];
    [svc setPreferredBarTintColor:[UIColor lcBarTintColor]];
    [svc setPreferredControlTintColor:[UIColor whiteColor]];
    [svc setModalPresentationCapturesStatusBarAppearance:YES];
    
    [self presentViewController:svc animated:YES completion:nil];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
            // account info section
			return 4;
			break;
            
        case 1:
            // photo upload section
            return 2;
            break;
			
		case 2:
            // preferences section
            if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                return 7;
            } else {
                return 8;
            }
			break;
			
        case 3:
            // notifications section
            return 4;
            break;
            
		case 4:
            // post categories section
			return 5;
			break;
            
        case 5:
            // about section
            return 3;
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
            return @"IMGUR UPLOAD";
            break;
			
		case 2:
			return @"PREFERENCES";
			break;

        case 3:
            return @"NOTIFICATIONS";
            break;
            
		case 4:
			return @"POST CATEGORIES";
			break;
        
        case 5:
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UITapGestureRecognizer *passwordTap;
    
    [cell setBackgroundColor:[UIColor lcGroupedCellColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setClipsToBounds: YES];
    
    [cell.textLabel setTextColor:[UIColor lcGroupedCellLabelColor]];
    [cell.textLabel setShadowColor:[UIColor lcTextShadowColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0, -1.0)];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
	// username/password/server text entry fields
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				cell.accessoryView = usernameField;
				cell.textLabel.text = @"Username:";
				break;
				
			case 1:
				cell.accessoryView = passwordField;
                cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Password:"
                                                                         attributes:underlineAttribute];
                
                passwordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePasswordTap:)];
                passwordTap.delegate = self;
                [cell addGestureRecognizer:passwordTap];
                
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
				cell.accessoryView = picsQualitySlider;
				cell.textLabel.text = [NSString stringWithFormat:@"Quality: %d%%", (int)(picsQualitySlider.value*100)];
                picsQualityLabel = cell.textLabel;
				break;
                
            case 1:
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
                cell.accessoryView = browserPrefPicker;
                cell.textLabel.text = @"Browser Preference:";
                break;
                
            case 2:
				cell.accessoryView = lolTagsSwitch;
				cell.textLabel.text = @"Enable [lol] Tags:";
				break;
                
			case 3:
				cell.accessoryView = modToolsSwitch;
				cell.textLabel.text = @"Enable Mod Tools:";
				break;
                
            case 4:
                cell.accessoryView = orderByPostDateSwitch;
                cell.textLabel.text = @"Scroll Replies By Date:";
                break;
                
			case 5:
				cell.accessoryView = saveSearchesSwitch;
				cell.textLabel.text = @"Save Searches:";
				break;
                
            case 6:
                if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
                    cell.accessoryView = youTubeSwitch;
                    cell.textLabel.text = @"Use YouTube:";
                } else {
                    cell.accessoryView = swipeBackSwitch;
                    cell.textLabel.text = @"Swipe To Go Back:";
                }
                break;
                
            case 7:
                cell.accessoryView = youTubeSwitch;
                cell.textLabel.text = @"Use YouTube:";
                break;
		}
	}

    // Push notification controls
    if (indexPath.section == 3) {
        UIButton *button = [self buttonForManage];
        
        switch (indexPath.row) {
            case 0:
                cell.accessoryView = pushMessagesSwitch;
                cell.textLabel.text = @"Push Messages:";
                break;
                
            case 1:
                cell.accessoryView = vanityPrefSwitch;
                cell.textLabel.text = @"Vanity:";
                break;
                
            case 2:
                cell.accessoryView = repliesPrefSwitch;
                cell.textLabel.text = @"Replies:";
                break;
                
            case 3:
                [button addTarget:self action:@selector(openKeywords) forControlEvents:UIControlEventTouchUpInside];
                
                cell.accessoryView = button;
                cell.textLabel.text = @"Keywords:";
                break;
        }
    }
    
	// Post category toggles
	if (indexPath.section == 4) {
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
    
    if (indexPath.section == 5) {
        UIButton *button = [self buttonForView];
        
        switch (indexPath.row) {
			case 0:
                [button addTarget:self action:@selector(openCredits) forControlEvents:UIControlEventTouchUpInside];
                
                cell.accessoryView = button;
                cell.textLabel.text = @"Credits:";
                break;
                
			case 1:
                [button addTarget:self action:@selector(openLicenses) forControlEvents:UIControlEventTouchUpInside];
                
                cell.accessoryView = button;
                cell.textLabel.text = @"Licenses:";
                break;
                
            case 2:
                [button addTarget:self action:@selector(openGuidelines) forControlEvents:UIControlEventTouchUpInside];
                
                cell.accessoryView = button;
                cell.textLabel.text = @"Guidelines:";
                break;
        }
    }

	return cell;
}

-(UIButton *)buttonForView {
    return [self buttonForSettingsWithString:@"View"];
}

-(UIButton *)buttonForManage {
    return [self buttonForSettingsWithString:@"Manage"];
}

-(UIButton *)buttonForSettingsWithString:(NSString *)string {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button setFrame:CGRectMake(0, 0, 80, 30)];
    [button setTitle:string forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lcBlueColor] forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor lcBlueColor].CGColor;
    
    return button;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

#pragma mark UIPickerView delegate methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // handle the picker view(s) appropriately
    if (pickerView.tag == 0) {
        serverField.text = apiServerAddresses[row];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // handle the picker view(s) appropriately
    if (pickerView.tag == 0) {
        return apiServerNames.count;
    } else if (pickerView.tag == 1) {
        return browserTypes.count;
    }
    
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *title;
    
    // handle the picker view(s) appropriately
    if (pickerView.tag == 0) {
        title = apiServerNames[row];
    } else if (pickerView.tag == 1) {
        title = browserTypes[row];
    } else {
        title = @"";
    }
    
    // dumb hack to change the font color within a picker view
    // create an attributed string and set it in the label after getting a reference to the label for this row
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.attributedText = attributedTitle;
        label.textAlignment = NSTextAlignmentCenter;
    }
    return label;
}

#pragma mark Notification Support 

- (void)handleSwitchState:(UISwitch *)aSwitch {
    if (aSwitch == pushMessagesSwitch) {
        if ([usernameField.text length] <= 0) {
            [UIAlertView showSimpleAlertWithTitle:@"Not Logged In"
                                          message:@"Enter a username and password to enable push notifications."];
            return;
        }
        
        if (pushMessagesSwitch.on) {
            // Add registration for remote notifications
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            // unregister, disable vanity/replies switches
            [[LatestChatty2AppDelegate delegate] pushUnregistration];
            
            vanityPrefSwitch.on = NO;
            vanityPrefSwitch.enabled = NO;
            repliesPrefSwitch.on = NO;
            repliesPrefSwitch.enabled = NO;
        }
    }
}

- (void)updateWogglePrefs:(NSNotification*)notification {
    BOOL vanity = [notification.object boolForKey:@"vanity"];
    BOOL replies = [notification.object boolForKey:@"replies"];
    
    vanityPrefSwitch.on = vanity;
    vanityPrefSwitch.enabled = YES;
    repliesPrefSwitch.on = replies;
    repliesPrefSwitch.enabled = YES;
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    tableView.delegate = nil;
}

@end
