//
//  UIView+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 2/25/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (HelperKit)

#pragma mark Convenience Initializers
+ (UIView*)view;
+ (UIView*)viewWithFrame:(CGRect)frame;

#pragma mark Positioning
- (void)center;
- (void)centerHorizontally:(BOOL)horizontal vertically:(BOOL)vertical;



@end
