//
//  SettingsViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController {
  IBOutlet UITextField *usernameField;
  IBOutlet UITextField *passwordField;
}

- (IBAction)dismiss:(id)sender;

@end
