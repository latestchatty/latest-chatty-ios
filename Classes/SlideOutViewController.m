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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if(UIInterfaceOrientationIsLandscape([self interfaceOrientation]))
		self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1024, 748);
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
	
	if(self.isCollapsed)
	{
		[sliderBar setFrame:CGRectMake(0, 0, 5, availableSize.height)];
		[tabButton setFrame:CGRectMake(5, 295, 25, 132)];	
		[navigationController.view setFrame:CGRectMake(-245, 0, 245, availableSize.height)];
		[contentNavigationController.view setFrame:CGRectMake(5, 0, availableSize.width-5, availableSize.height)];
		return;
	}
	
	[sliderBar setFrame:CGRectMake(245, 0, 5, availableSize.height)];
	[tabButton setFrame:CGRectMake(250, 295, 25, 132)];		
	[navigationController.view setFrame:CGRectMake(0, 0, 245, availableSize.height)];	
	[contentNavigationController.view setFrame:CGRectMake(245, 0, availableSize.width-245, availableSize.height)];
	
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
	
	[self.view bringSubviewToFront:sliderBar];
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
