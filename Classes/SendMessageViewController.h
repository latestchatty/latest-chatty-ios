//
//  SendMessageViewController.h
//  LatestChatty2
//
//  Created by Chris Syversen on 2/2/10.
//  Copyright 2010. All rights reserved.
//

#import "Message.h"

@interface SendMessageViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *recipient;
	IBOutlet UITextField *subject;
	IBOutlet UITextView *body;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *activityView;
    IBOutlet UIActivityIndicatorView *spinner;
    BOOL postingWarningAlertView;
}

@property (retain, nonatomic) Message *message;
@property (retain, nonatomic) NSString *recipientString;
@property (retain, nonatomic) NSString *subjectString;
@property (retain, nonatomic) NSString *bodyString;
@property (retain, nonatomic) UITextField *recipient;
@property (retain, nonatomic) UITextField *subject;
@property (retain, nonatomic) UITextView *body;

- (void)showActivityIndicator;
- (void)setupReply;
- (void)makeMessage;
- (void)sendMessage;

- (id)initWithRecipient:(NSString *)aRecipient;
- (id)initWithMessage:(Message *)aMessage;

@end
