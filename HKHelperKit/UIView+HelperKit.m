//
//  UIView+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 2/25/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UIView+HelperKit.h"


@implementation UIView (HelperKit)

#pragma mark Convenience Initializers

+ (id)view {
    return [self viewWithFrame:CGRectZero];
}

+ (id)viewWithFrame:(CGRect)frame {
    return [[[UIView alloc] initWithFrame:frame] autorelease];
}


#pragma mark Frame Manipulation

- (void)centerInSuperview {
    [self centerInSuperviewHorizontally:YES vertically:YES];
}

- (void)centerInSuperviewHorizontally:(BOOL)horizontal vertically:(BOOL)vertical {
	self.frame = CGRectCenterInRect(self.frame, self.superview.frame, horizontal, vertical);
}

- (void)padFrameWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {
    self.frame = CGRectWithPadding(self.frame, top, right, bottom, left);
}

- (void)tranlateFrameByX:(CGFloat)x y:(CGFloat)y {
    self.frame = CGRectWithTranslation(self.frame, x, y);
}


#pragma mark Animation

- (void)animateFadeIn {
    [self animateToOpaque:YES duration:0.25];
}

- (void)animateFadeOut {
    [self animateToOpaque:NO duration:0.25];
}

- (void)animateToOpaque:(BOOL)toOpaque duration:(CGFloat)duration {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    self.alpha = toOpaque ? 1.0 : 0.0;
    [UIView commitAnimations];    
}


@end
