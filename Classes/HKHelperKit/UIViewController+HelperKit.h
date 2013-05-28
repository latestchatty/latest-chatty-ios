//
//  UIViewController+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 2/23/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface UIViewController (HelperKit)

#pragma mark Initializers

// Creates controller with a nib named same as the class: "FooController" would load "FooController.xib"
// This method will also look for for xib's with a specific naming convention based on device screen size
// and orientation.  For example, in iPhone (or iPod Touch) in portrait will look for xibs inthe following
// order:
// 
//  * MyController.iPhone.Portrait.xib
//  * MyController.iPhone.xib
//  * MYController.xib
//
// The first one that it finds will be loaded for the controllers view.  In the xib filename, the general
// format is:
//
//   <ControllerClassName>.<ScreenType>.<Orientation>.xib
//
// Supported screen types are currently "iPhone" and "iPad".
// Supported orientations are currently "Portrait" and "Landscape"
+ (id)controllerWithNib; 

+ (id)controller;
+ (id)controllerWithNibName:(NSString*)nibName;
+ (id)controllerWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle;

- (id)initWithNibName:(NSString *)nibName;
- (id)initWithNib; // Instance version of the controllerWithNib method

#pragma mark Animation Helpers

// Moves in the controller from the bottom of the screen like a modal presentation
- (void)slideUp;

// Moves out the controller from the bottom of the screen like a modal dismissal
- (void)slideDown;

// Moves out the controller from the right of the screen like a navigation push
- (void)slideIn;

// Moves out the controller through the right of the screen like a navigation pop
- (void)slideOut;

// Perform a custom animation type on this controllers view.
// - "transition" is one of kCATransitionFade, kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal
// - "direction"  is one of kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom
- (void)animateWithType:(NSString*)transition direction:(NSString*)direction;

@end
