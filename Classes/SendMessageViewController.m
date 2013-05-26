//
//  SendMessageViewController.m
//  LatestChatty2
//
//  Created by Chris Syversen on 2/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SendMessageViewController.h"
#import "Message.h"
#import "NoContentController.h"
#import "LatestChatty2AppDelegate.h"

@implementation SendMessageViewController

@synthesize body, recipient, subject;

- (id)initWithNib {
    self = [super initWithNib];
    self.title = @"Compose";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollView.contentSize = CGSizeMake(scrollView.frameWidth, (self.recipient.frameHeight*2)+5);
    
//	UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
//                                                                   style:UIBarButtonItemStyleDone
//                                                                  target:self
//                                                                  action:@selector(sendMessage)];
//	self.navigationItem.rightBarButtonItem = sendButton;
//    [sendButton release];
    
	UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(sendMessage)];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],UITextAttributeTextColor,
                                [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5],UITextAttributeTextShadowColor,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                UITextAttributeTextShadowOffset,
                                nil];
    [sendButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
	self.navigationItem.rightBarButtonItem = sendButton;
	[sendButton release];
    
    [self.recipient becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeAppeared" object:self];
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
    // allow landscape setting on
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) {
        if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
            // iPad can rotate to any interface
            return UIInterfaceOrientationMaskAll;
        } else {
            // iPhone can rotate to any interface except portrait upside down
            return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
        }
    } else {
        if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
            // iPad can rotate to any portrait interface
            return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
        } else {
            // iPhone can rotate to only regular portrait
            return UIInterfaceOrientationMaskPortrait;
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // never allow portrait upside down for iPhone
    if (![[LatestChatty2AppDelegate delegate] isPadDevice] && interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    }
    
    // allow landscape setting is on, allow rotation
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) {
        return YES;
    } else {
        // allow landscape setting is off, allow rotation if the orientation isn't landscape
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation))return NO;
        return YES;
    }
}

- (void)viewDidUnload {
    [scrollView release];
    scrollView = nil;
}

#pragma mark Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"fired");
    if (textField == recipient) {
        [subject becomeFirstResponder];
    } else if (textField == subject) {
        [body becomeFirstResponder];
    }
    return NO;
}

#pragma mark Setup and Message Send

- (void)setupReply:(Message*)message {
//    body.text = [message.body stringByReplacingOccurrencesOfRegex:@"<br.*?>" withString:@"\n"];
    body.text = [NSString stringWithFormat:@"On %@ %@ wrote:\n\n%@", [Message formatDate:message.date], message.from, message.body];
    body.text = [NSString stringWithFormat:@"\n\n--------------------\n\n%@", [body.text stringByReplacingOccurrencesOfRegex:@"<.*?>" withString:@""]];
    
    recipient.text = message.from;
    subject.text = [NSString stringWithFormat:@"Re: %@", message.subject];
    
    [body becomeFirstResponder];
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
    
    //Patch-E: see [ComposeViewController makePost] for explanation, same GCD blocks used there
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
    self.body = nil;
    self.recipient = nil;
    self.subject = nil;
    
    [activityView release];
	[spinner release];
    [scrollView release];
    
    [super dealloc];
}

@end
