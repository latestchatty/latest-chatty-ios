//
//  StoryViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StoryViewController.h"


@implementation StoryViewController

@synthesize story;

- (id)initWithStory:(Story *)aStory {
  [self initWithNibName:@"StoryViewController" bundle:nil];
  
  self.story = aStory;
  self.title = aStory.title;
  
  UIBarButtonItem *chattyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ChatIcon.24.png"]
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(loadChatty)];
	self.navigationItem.rightBarButtonItem = chattyButton;
  [chattyButton release];
  
  return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  NSString *baseUrlString = [NSString stringWithFormat:@"http://shacknews.com/onearticle.x/%i", story.modelId];
  [content loadHTMLString:story.body baseURL:[NSURL URLWithString:baseUrlString]];
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

- (void)loadChatty {
  ChattyViewController *viewController = [[ChattyViewController alloc] initWithStory:story];
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

- (void)dealloc {
  [story release];
  [super dealloc];
}


@end
