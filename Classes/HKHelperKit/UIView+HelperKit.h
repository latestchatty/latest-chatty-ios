//
//  UIView+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 2/25/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGRect+HelperKit.h"


@interface UIView (HelperKit)

#pragma mark Convenience Initializers

// Initialize an autoreleased view with a frame of CGRectZero
+ (id)view;

// Initialize an autoreleased view with a specified frame
+ (id)viewWithFrame:(CGRect)frame;


#pragma mark Frame Manipulation

// These 6 properties allow you to easily set individual components of a
// views frame without assigning them to a local variable first.
@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGFloat frameX;
@property (nonatomic, assign) CGFloat frameY;

@property (nonatomic, assign) CGSize frameSize;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;

// Center this view in it's superview
- (void)centerInSuperview;

// Center this view in it's superview only along a specific axis
- (void)centerInSuperviewHorizontally:(BOOL)horizontal vertically:(BOOL)vertical;

// Alter this views frame by pushing each edge inward by a specific amount
- (void)padFrameWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

// Alter this views frame by moving it by an amount
- (void)tranlateFrame:(CGPoint)distance;


#pragma mark Animation

// Animates a view fade in.  These methods will not set the starting alpha for
// you, so do that first or you may not see anything change.
- (void)animateFadeIn;
- (void)animateFadeOut;
- (void)animateToOpaque:(BOOL)toOpaque duration:(CGFloat)duration;


@end
