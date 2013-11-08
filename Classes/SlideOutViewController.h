//
//  SlideOutViewController.h
//  LatestChatty2
//
//  Created by Kyle Eli on 4/8/10.
//  Copyright 2010. All rights reserved.
//

#import "ThreadViewController.h"

@interface SlideOutViewController : UIViewController {

	BOOL isCollapsed;
	BOOL collapsedToCompose;

	UINavigationController *navigationController;
	UINavigationController *contentNavigationController;
		
	IBOutlet UIButton *tabButton;
	IBOutlet UIImageView *divider;
}

@property (nonatomic) BOOL isCollapsed;

- (IBAction)tabTouched;

- (void)addNavigationController:(UINavigationController *)navigation contentNavigationController:(UINavigationController *)content;

- (CGSize)availableSizeForOrientation:(UIInterfaceOrientation)orientation;

@end
