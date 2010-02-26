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
+ (UIView*)view;

// Initialize an autoreleased view with a specified frame
+ (UIView*)viewWithFrame:(CGRect)frame;


#pragma mark Frame Manipulation

// Center this view in it's superview
- (void)centerInSuperview;

// Center this view in it's superview only along a specific axis
- (void)centerInSuperviewHorizontally:(BOOL)horizontal vertically:(BOOL)vertical;

// Alter this views frame by pushing each edge inward by a specific amount
- (void)padFrameWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

// Alter this views frame by moving it by an amount
- (void)tranlateFrameByX:(CGFloat)x y:(CGFloat)y;


@end
