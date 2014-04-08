//
//  SendMessageViewController.h
//  LatestChatty2
//
//  Created by Chris Syversen on 2/2/10.
//  Copyright 2010. All rights reserved.
//

#import "Message.h"

@interface SendMessageViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate> {
	IBOutlet UITextField *recipient;
	IBOutlet UITextField *subject;
	IBOutlet UITextView *body;
    
//    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *activityView;
    IBOutlet UIActivityIndicatorView *spinner;
    
    BOOL postingWarningAlertView;
}

@property (strong, nonatomic) Message *message;
@property (strong, nonatomic) NSString *recipientString;
@property (strong, nonatomic) NSString *subjectString;
@property (strong, nonatomic) NSString *bodyString;
@property (strong, nonatomic) UITextField *recipient;
@property (strong, nonatomic) UITextField *subject;
@property (strong, nonatomic) UITextView *body;

- (void)showActivityIndicator;
- (void)setupReply;
- (void)makeMessage;
- (void)sendMessage;

- (id)initWithRecipient:(NSString *)aRecipient;
- (id)initWithMessage:(Message *)aMessage;

@end
