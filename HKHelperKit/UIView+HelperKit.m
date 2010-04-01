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
    return [[[self alloc] initWithFrame:frame] autorelease];
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

- (void)tranlateFrame:(CGPoint)distance {
    self.frame = CGRectWithTranslation(self.frame, distance.x, distance.y);
}

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
    CGRect newFrame = self.frame;
    newFrame.origin = newOrigin;
    self.frame = newFrame;
}

- (CGFloat)frameX {
    return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
    CGRect newFrame = self.frame;
    newFrame.origin.x = newX;
    self.frame = newFrame;
}

- (CGFloat)frameY {
    return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
    CGRect newFrame = self.frame;
    newFrame.origin.y = newY;
    self.frame = newFrame;
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
    CGRect newFrame = self.frame;
    newFrame.size = newSize;
    self.frame = newFrame;
}

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
    CGRect newFrame = self.frame;
    newFrame.size.width = newWidth;
    self.frame = newFrame;
}

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
    CGRect newFrame = self.frame;
    newFrame.size.height = newHeight;
    self.frame = newFrame;
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
