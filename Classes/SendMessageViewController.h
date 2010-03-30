//
//  SendMessageViewController.h
//  LatestChatty2
//
//  Created by Chris Syversen on 2/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface SendMessageViewController : UIViewController {
	IBOutlet UITextField *recipient;
	IBOutlet UITextField *subject;
	IBOutlet UITextView *body;
}

@property (retain) UITextField *recipient;
@property (retain) UITextField *subject;
@property (retain) UITextView *body;

- (void)setupReply:(Message*)message;
- (IBAction)send;

@end
