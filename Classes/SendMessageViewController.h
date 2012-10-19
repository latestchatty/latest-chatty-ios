//
//  SendMessageViewController.h
//  LatestChatty2
//
//  Created by Chris Syversen on 2/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface SendMessageViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *recipient;
	IBOutlet UITextField *subject;
	IBOutlet UITextView *body;
    IBOutlet UIScrollView *scrollView;
}

@property (retain, nonatomic) UITextField *recipient;
@property (retain, nonatomic) UITextField *subject;
@property (retain, nonatomic) UITextView *body;

- (void)setupReply:(Message*)message;
- (IBAction)send;

@end
