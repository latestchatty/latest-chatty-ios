//
//  SendMessageViewController.m
//  LatestChatty2
//
//  Created by Chris Syversen on 2/2/10.
//  Copyright 2010. All rights reserved.
//

#import "SendMessageViewController.h"

#import "Message.h"
#import "NoContentController.h"

@implementation SendMessageViewController

@synthesize body, recipient, subject, message;

- (id)initWithNib {
    self = [super initWithNib];
    self.title = @"Compose";
    return self;
}

- (id)initWithRecipient:(NSString *)aRecipient {
    self = [self initWithNib];
    
    self.recipientString = aRecipient;
    
    return self;
}

- (id)initWithMessage:(Message *)aMessage {
    self = [self initWithNib];
    
    self.message = aMessage;
    self.recipientString = aMessage.from;
    self.subjectString = aMessage.subject;
    self.bodyString = aMessage.body;
    
    return self;
}

- (id)initWithReportBody:(NSString *)aBody {
    self = [self initWithNib];
    
    self.title = @"Report";
    self.recipientString = @"Duke Nuked";
    self.subjectString = @"Reporting Author of Post";
    self.bodyString = aBody;
    self.reportMessage = YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(sendMessage)];
    [sendButton setTitleTextAttributes:[NSDictionary blueTextAttributesDictionary] forState:UIControlStateNormal];
    [sendButton setTitleTextAttributes:[NSDictionary blueHighlightTextAttributesDictionary] forState:UIControlStateDisabled];
	self.navigationItem.rightBarButtonItem = sendButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.recipient.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"To" attributes:@{NSForegroundColorAttributeName: [UIColor lcDarkGrayTextColor]}];
    self.subject.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Subject" attributes:@{NSForegroundColorAttributeName: [UIColor lcDarkGrayTextColor]}];

    [self.recipient setText:self.recipientString];
    [self.subject setText:self.subjectString];
    [self.body setText:self.bodyString];
    if (self.bodyString) {
        if (!self.reportMessage) {
            [self setupReply];
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeAppeared" object:self];
    
    self.body.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
    
    // top separation bar
    UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.bodyString) {
        [self.body becomeFirstResponder];
    } else if (self.recipientString) {
        [self.subject becomeFirstResponder];
    } else {
        [self.recipient becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeDisappeared" object:self];
}

- (UIViewController *)showingViewController {
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        return [LatestChatty2AppDelegate delegate].slideOutViewController;
    } else {
        return self;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger length = textField.text.length - range.length + string.length;
    
    if (textField.tag == 0) {
        if (body.text.length > 0 && subject.text.length > 0 && length > 0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
    
    if (textField.tag == 1) {
        if (body.text.length > 0 && recipient.text.length > 0 && length > 0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger length = textView.text.length - range.length + text.length;
    if (recipient.text.length > 0 && subject.text.length > 0 && length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return YES;
}

#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary* info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    body.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    body.scrollIndicatorInsets = body.contentInset;
}

- (void)keyboardDidHide:(NSNotification *)note {
    body.contentInset = UIEdgeInsetsZero;
    body.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == recipient) {
        [subject becomeFirstResponder];
    } else if (textField == subject) {
        [body becomeFirstResponder];
    }
    return NO;
}

#pragma mark Setup and Message Send

- (void)setupReply {
//    body.text = [message.body stringByReplacingOccurrencesOfRegex:@"<br.*?>" withString:@"\n"];
    body.text = [NSString stringWithFormat:@"On %@ %@ wrote:\n\n%@", [Message formatDate:message.date withAllowShortFormat:NO], message.from, message.body];
    body.text = [NSString stringWithFormat:@"\n\n--------------------\n\n%@", [body.text stringByReplacingOccurrencesOfRegex:@"<.*?>" withString:@""]];
    
    recipient.text = message.from;
    subject.text = [NSString stringWithFormat:@"Re: %@", message.subject];
    
    body.selectedRange = NSRangeFromString(@"0");
}

- (void)sendSuccess {
    [UIAlertView showSimpleAlertWithTitle:@"Message Sent!"
                                  message:nil];
    
	//self.navigationController.view.userInteractionEnabled = YES;
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [self.recipient setText:@""];
        [self.subject setText:@""];
        [self.body setText:@""];
        
        ModelListViewController *lastController = (ModelListViewController *)self.navigationController.backViewController;
        if (lastController.class == [MessageViewController class]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeDisappeared" object:self];            
        }
    } else {
//        ModelListViewController *lastController = (ModelListViewController *)self.navigationController.backViewController;
//        if (lastController.class == [MessagesViewController class]) {
//            [lastController refresh:self];
//        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
	[self hideActivityIndicator];
}

- (void)sendFailure {
	//self.navigationController.view.userInteractionEnabled = YES;
	[self hideActivityIndicator];
}

- (void)makeMessage {
    BOOL success = [Message createWithTo:self->recipient.text subject:self->subject.text body:self->body.text];
    if (success) {
        [self performSelectorOnMainThread:@selector(sendSuccess) withObject:nil waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(sendFailure) withObject:nil waitUntilDone:NO];
    }
}

- (void)sendMessage {
    [body resignFirstResponder];

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Message"
                                          message:@"Send this message?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [[self showingViewController].presentedViewController dismissViewControllerAnimated:NO completion:nil];
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Send"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self showActivityIndicator];
                                   [self performSelector:@selector(makeMessage) withObject:nil afterDelay:0.25];
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [[self showingViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)showActivityIndicator {
	CGRect frame = self.view.frame;
	frame.origin = CGPointZero;
	activityView.frame = frame;

	[self.view addSubview:activityView];
    spinner.hidden = NO;
    [spinner startAnimating];
}

- (void)hideActivityIndicator {
	[activityView removeFromSuperview];
	[spinner stopAnimating];
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
