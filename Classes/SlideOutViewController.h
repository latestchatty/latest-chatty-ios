//
//  SlideOutViewController.h
//  LatestChatty2
//
//  Created by Kyle Eli on 4/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreadViewController.h"

@interface SlideOutViewController : UIViewController {

	BOOL isCollapsed;	

	UINavigationController *navigationController;
	UINavigationController *contentNavigationController;
		
	IBOutlet UIButton *tabButton;
	IBOutlet UIImageView *sliderBar;
}

@property (nonatomic) BOOL isCollapsed;

- (IBAction)tabTouched;

- (void)addNavigationController:(UINavigationController *)navigation contentNavigationController:(UINavigationController *)content;

@end
