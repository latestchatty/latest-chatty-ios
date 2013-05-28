//
//  UIBarButtonItem+Custom.m
//  Timeless Reminders
//
//  Created by Alex Wayne on 2/2/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UIBarButtonItem+HelperKit.h"


@implementation UIBarButtonItem (HelperKit)

#pragma mark Initializers

+ (UIBarButtonItem*)itemWithSystemType:(UIBarButtonSystemItem)itemType {
    return [self itemWithSystemType:itemType target:nil action:nil];
}

+ (UIBarButtonItem*)itemWithSystemType:(UIBarButtonSystemItem)itemType target:(id)target action:(SEL)action  {
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:itemType target:target action:action] autorelease];
}

+ (UIBarButtonItem*)itemWithTitle:(NSString*)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    return [[[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action] autorelease];
}

+ (UIBarButtonItem*)itemWithImage:(UIImage*)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    return [[[UIBarButtonItem alloc] initWithImage:image style:style target:target action:action] autorelease];
}

+ (UIBarButtonItem*)flexibleSpace {
    return [self itemWithSystemType:UIBarButtonSystemItemFlexibleSpace];
}

+ (UIBarButtonItem*)fixedSpace:(CGFloat)width {
    UIBarButtonItem *space = [self itemWithSystemType:UIBarButtonSystemItemFixedSpace];
    space.width = width;
    return space;
}

@end
