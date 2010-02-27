//
//  UINavigationController+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 2/23/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UINavigationController+HelperKit.h"


@implementation UINavigationController (HelperKit)

+ (UINavigationController*)controllerWithRootController:(UIViewController*)controller {
    return [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
}

- (UIViewController*)backViewController {
    UIViewController *result = nil;
    NSUInteger count = [self.viewControllers count];
    if (count > 1) {
        result = [self.viewControllers objectAtIndex:count-2];
    }
    
    return result;
}

@end
