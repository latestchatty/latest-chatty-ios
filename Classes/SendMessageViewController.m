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

    [self.recipient setText:self.recipientString];
    [self.subject setText:self.subjectString];
    [self.body setText:self.bodyString];
    if (self.bodyString) {
        [self setupReply];
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
    
    // iOS7
    self.navigationController.navigationBar.translucent = NO;
    
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    scrollView.contentSize = CGSizeMake(scrollView.frameWidth, (self.recipient.frameHeight*2)+5);
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger length = textField.text.length - range.length + string.length;
    
    if (textField.tag == 0) {
        NSLog(@"length: %lu", (unsigned long)length);
        if (body.text.length > 0 && subject.text.length > 0 && length > 0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        } else {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
    
    if (textField.tag == 1) {
        NSLog(@"length: %lu", (unsigned long)length);
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
    NSLog(@"length: %lu", (unsigned long)length);
    if (recipient.text.length > 0 && subject.text.length > 0 && length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return YES;
}

#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [UIView animateWithDuration:0.25 animations:^{
            body.frameHeight = body.frameHeight - kbSize.width;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            body.frameHeight = body.frameHeight - kbSize.height;
        }];
    }
//    NSLog(@"frameHeight: %f", body.frameHeight);
//    NSLog(@"frameWidth: %f", body.frameWidth);
//    NSLog(@"frameX: %f", body.frameX);
//    NSLog(@"frameY: %f", body.frameY);
}

- (void)keyboardDidHide:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation orientation = self.interfaceOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [UIView animateWithDuration:0.25 animations:^{
            body.frameHeight = body.frameHeight + kbSize.width;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            body.frameHeight = body.frameHeight + kbSize.height;
        }];
    }
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
    @autoreleasepool {
        //self.navigationController.view.userInteractionEnabled = NO;
        
        // See [ComposeViewController makePost] for explanation, same GCD blocks used there
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL success = [Message createWithTo:recipient.text subject:subject.text body:body.text];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [self performSelectorOnMainThread:@selector(sendSuccess) withObject:nil waitUntilDone:NO];
                } else {
                    [self performSelectorOnMainThread:@selector(sendFailure) withObject:nil waitUntilDone:NO];
                }
            });
        });

        postingWarningAlertView = NO;
    }
}

- (void)sendMessage {
    [body becomeFirstResponder];
    [body resignFirstResponder];
    
    postingWarningAlertView = YES;
    [UIAlertView showWithTitle:@"Message"
                       message:@"Send this message?"
                      delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"Send", nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
        [self showActivityIndicator];
        [body resignFirstResponder];
        [self performSelectorInBackground:@selector(makeMessage) withObject:nil];
	}
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
