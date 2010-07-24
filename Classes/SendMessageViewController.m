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

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    body.font = [UIFont systemFontOfSize:12];
    
	UIBarButtonItem *sendButton = [UIBarButtonItem itemWithTitle:@"Send Message" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
	self.navigationItem.rightBarButtonItem = sendButton;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction)send {
	Message *message = [[[Message alloc] init] autorelease];
    message.to = recipient.text;
    message.subject = subject.text;
    message.body = body.text;
	[message send];
	
    [UIAlertView showSimpleAlertWithTitle:@"Message Sent!" message:nil];
    
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIViewController *viewController = [NoContentController controllerWithNib];
        [LatestChatty2AppDelegate delegate].contentNavigationController.viewControllers = [NSArray arrayWithObject:viewController];
    }
}

- (void)setupReply:(Message*)message {
    body.text = [message.body stringByReplacingOccurrencesOfRegex:@"<br.*?>" withString:@"\n"];
    body.text = [NSString stringWithFormat:@"\n\n\n--------------------\n\n/[%@]/", [body.text stringByReplacingOccurrencesOfRegex:@"<.*?>" withString:@""]];
    
    recipient.text = message.from;
    subject.text = [NSString stringWithFormat:@"RE: %@", message.subject];
    
    [body becomeFirstResponder];
    body.selectedRange = NSRangeFromString(@"0");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return YES;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc {
    [super dealloc];
}


@end
