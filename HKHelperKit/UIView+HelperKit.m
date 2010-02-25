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

+ (UIView*)view {
    return [self viewWithFrame:CGRectZero];
}

+ (UIView*)viewWithFrame:(CGRect)frame {
    return [[[UIView alloc] initWithFrame:frame] autorelease];
}


#pragma mark Positioning

- (void)center {
    [self centerHorizontally:YES vertically:YES];
}

- (void)centerHorizontally:(BOOL)horizontal vertically:(BOOL)vertical {
    CGRect viewFrame = self.superview.frame;
	CGRect selfFrame = self.frame;
	
	if (horizontal) selfFrame.origin.x = round(viewFrame.size.width/2  - selfFrame.size.width/2);
    if (vertical)   selfFrame.origin.y = round(viewFrame.size.height/2 - selfFrame.size.height/2);
    
	self.frame = selfFrame;
}


@end
