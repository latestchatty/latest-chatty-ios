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

+ (id)controller;
+ (id)controllerWithNib; // Creates controller with a nib named same as the class: "FooController" would load "FooController.xib"
+ (id)controllerWithNibName:(NSString*)nibName;
+ (id)controllerWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle;

- (id)initWithNibName:(NSString *)nibName;
- (id)initWithNib; // Instance version of the controllerWithNib method

#pragma mark Animation Helpers

// Moves in the controller from the bottom of the screen like a modal presentation
- (void)slideUp;

// Moves out the controller from the bottom of the screen like a modal dismissal
- (void)SlideDown;

// Moves out the controller from the right of the screen like a navigation push
- (void)slideIn;

// Moves out the controller through the right of the screen like a navigation pop
- (void)slideOut;

// Perform a custom animation type on this controllers view.
// - "transition" is one of kCATransitionFade, kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal
// - "direction"  is one of kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom
- (void)animateWithType:(NSString*)transition direction:(NSString*)direction;

@end
