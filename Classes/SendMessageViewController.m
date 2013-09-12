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
    
    scrollView.contentSize = CGSizeMake(scrollView.frameWidth, (self.recipient.frameHeight*2)+5);
    
	UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(sendMessage)];
    [sendButton setTitleTextAttributes:[NSDictionary blueTextAttributesDictionary] forState:UIControlStateNormal];
	self.navigationItem.rightBarButtonItem = sendButton;
	[sendButton release];

    [self.recipient setText:self.recipientString];
    [self.subject setText:self.subjectString];
    [self.body setText:self.bodyString];
    if (self.bodyString) {
        [self setupReply];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeAppeared" object:self];
    
    // iOS7
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (void)viewWillAppear:(BOOL)animated {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    CGFloat screenWidth = screenSize.width;
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        UIInterfaceOrientation orientation = self.interfaceOrientation;
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [body setFrame:CGRectMake(0, 43, screenHeight, 63)];
        } else {
            if ( screenHeight > 480 ) {
                [body setFrame:CGRectMake(0, 68, screenWidth, 220)];
            }
            else {
                [body setFrame:CGRectMake(0, 68, screenWidth, 133)];
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeDisappeared" object:self];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.bodyString) {
        [self.body becomeFirstResponder];
    } else if (self.recipientString) {
        [self.subject becomeFirstResponder];
    } else {
        [self.recipient becomeFirstResponder];
    }
}

//Patch-E: implemented fix for text view being underneath the keyboard in landscape, sets coords/dimensions when in portrait or landscape on non-pad devices. Used didRotate instead of willRotate, ends up causing a minor flash when the view resizes, but it is minimal.
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
        
        if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation)) {
            //if rotating from landscapeLeft to landscapeRight or vice versa, don't change postContent's frame
            if (body.frame.size.width > 320) {
                return;
            }
            
            //iPhone portrait activated, handle Retina 4" & 3.5" accordingly
            if ( screenHeight > 480 ) {
                [body setFrame:CGRectMake(0, 68, screenWidth, 220)];
            }
            else {
                [body setFrame:CGRectMake(0, 68, screenWidth, 133)];
            }
        } else {
            //iPhone landscape activated
            [body setFrame:CGRectMake(0, 43, screenHeight, 63)];
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frameWidth, (self.recipient.frameHeight*2)+5);
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
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
    body.text = [NSString stringWithFormat:@"On %@ %@ wrote:\n\n%@", [Message formatDate:message.date], message.from, message.body];
    body.text = [NSString stringWithFormat:@"\n\n--------------------\n\n%@", [body.text stringByReplacingOccurrencesOfRegex:@"<.*?>" withString:@""]];
    
    recipient.text = message.from;
    subject.text = [NSString stringWithFormat:@"Re: %@", message.subject];
    
    body.selectedRange = NSRangeFromString(@"0");
}

- (void)sendSuccess {
    [UIAlertView showSimpleAlertWithTitle:@"Message Sent!" message:nil];
    
	self.navigationController.view.userInteractionEnabled = YES;
    
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
        ModelListViewController *lastController = (ModelListViewController *)self.navigationController.backViewController;
        if (lastController.class == [MessagesViewController class]) {
            [lastController refresh:self];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
	[self hideActivtyIndicator];
}

- (void)sendFailure {
	self.navigationController.view.userInteractionEnabled = YES;
	[self hideActivtyIndicator];
}

- (void)makeMessage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    self.navigationController.view.userInteractionEnabled = NO;
    
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
    [pool release];
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

- (void)hideActivtyIndicator {
	[activityView removeFromSuperview];
	[spinner stopAnimating];
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.message = nil;
    self.recipientString = nil;
    self.subjectString = nil;
    self.bodyString = nil;
    self.recipient = nil;
    self.subject = nil;
    self.body = nil;

    [scrollView release];
    [activityView release];
	[spinner release];
    
    [super dealloc];
}

@end
