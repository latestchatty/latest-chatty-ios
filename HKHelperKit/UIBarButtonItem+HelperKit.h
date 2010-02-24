//
//  UIBarButtonItem+Custom.h
//  Timeless Reminders
//
//  Created by Alex Wayne on 2/2/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBarButtonItem (HelperKit)

#pragma mark Initializers

// Create an actionless system item based UIBarButtonItem
+ (UIBarButtonItem*)itemWithSystemType:(UIBarButtonSystemItem)itemType;

// Create a system item based UIBarButtonItem that is bounds to an action and target
+ (UIBarButtonItem*)itemWithSystemType:(UIBarButtonSystemItem)itemType target:(id)target action:(SEL)action;

// Create a text based UIBarButtonItem
+ (UIBarButtonItem*)itemWithTitle:(NSString*)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

// Create an image based UIBarButtonItem
+ (UIBarButtonItem*)itemWithImage:(UIImage*)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

// Create a flexible space UIBarButtonItem
+ (UIBarButtonItem*)flexibleSpace;

// Create a fixed space UIBarButtonItem of the specified width in pixels
+ (UIBarButtonItem*)fixedSpace:(CGFloat)width;

@end
