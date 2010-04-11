    //
//  SlideOutViewController.m
//  LatestChatty2
//
//  Created by Kyle Eli on 4/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SlideOutViewController.h"


@implementation SlideOutViewController

@synthesize isCollapsed;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)searchLoaded:(NSObject *)sender
{
	if(isCollapsed) return;
	[self tabTouched];
}

- (void)composeAppeared:(NSObject *)sender
{
	if(isCollapsed)
	{
		collapsedToCompose = NO;
		return;
	}
	
	collapsedToCompose = YES;
	[self tabTouched];
}

- (void)composeDisappeared:(NSObject *)sender
{
	if(!collapsedToCompose) return;
	collapsedToCompose = NO;	
	[self tabTouched];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if(UIInterfaceOrientationIsLandscape([self interfaceOrientation]))
		self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1024, 748);
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(composeAppeared:) name:@"ComposeAppeared" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(composeDisappeared:) name:@"ComposeDisappeared" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchLoaded:) name:@"SearchLoaded" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (CGSize)availableSizeForOrientation:(UIInterfaceOrientation)orientation;
{		
	if(UIInterfaceOrientationIsLandscape(orientation))
		return CGSizeMake(1024, 748);
	return CGSizeMake(768, 1004);
}


- (void)updateViewsForOrientation:(UIInterfaceOrientation) orientation
{
	CGSize availableSize = [self availableSizeForOrientation:orientation];	
	CGFloat trayWidth = UIInterfaceOrientationIsLandscape(orientation) ? 320 : 240;
	
	if(self.isCollapsed)
	{
		[tabButton setFrame:CGRectMake(0, 0, 25, availableSize.height)];	
		[navigationController.view setFrame:CGRectMake(-trayWidth, 0, trayWidth, availableSize.height)];
		[contentNavigationController.view setFrame:CGRectMake(25, 0, availableSize.width-25, availableSize.height)];
		return;
	}
	
	[tabButton setFrame:CGRectMake(trayWidth, 0, 25, availableSize.height)];		
	[navigationController.view setFrame:CGRectMake(0, 0, trayWidth, availableSize.height)];	
	[contentNavigationController.view setFrame:CGRectMake(trayWidth+25, 0, availableSize.width-(trayWidth+25), availableSize.height)];
	
	return;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self updateViewsForOrientation:toInterfaceOrientation];
	[navigationController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[contentNavigationController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];	
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[navigationController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[contentNavigationController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


- (void)addNavigationController:(UINavigationController *)navigation contentNavigationController:(UINavigationController *)content;
{
	navigationController = [navigation retain];
	contentNavigationController = [content retain];
	
	[self.view addSubview:navigationController.view];
	[self.view addSubview:contentNavigationController.view];
	
	[self.view bringSubviewToFront:tabButton];
	
	[self updateViewsForOrientation:[self interfaceOrientation]];
}


- (void)updateContentLayoutIfNecessary
{
	if(![contentNavigationController.topViewController isKindOfClass:[ThreadViewController class]])
		return;
	
	ThreadViewController *threadViewController = (ThreadViewController *)contentNavigationController.topViewController;
	[threadViewController resetLayout];
}


- (IBAction)tabTouched
{
	self.isCollapsed = !self.isCollapsed;

	[UIView beginAnimations:@"slideView" context:nil];
	[self updateViewsForOrientation:[self interfaceOrientation]];
	[self updateContentLayoutIfNecessary];	
	[UIView commitAnimations];	
}
@end
