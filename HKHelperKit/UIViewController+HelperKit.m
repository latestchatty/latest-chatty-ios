//
//  UIViewController+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 2/23/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UIViewController+HelperKit.h"


@implementation UIViewController (HelperKit)

#pragma mark Initializers

+ (UIViewController*)controller {
    return [UIViewController controllerWithNibName:nil bundle:nil];
}

+ (UIViewController*)controllerWithNibName:(NSString*)nibNameOrNil {
    return [UIViewController controllerWithNibName:nibNameOrNil bundle:nil];
}

+ (UIViewController*)controllerWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)bundle {
    return [[[UIViewController alloc] initWithNibName:nibNameOrNil bundle:bundle] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil {
    return [self initWithNibName:nibNameOrNil bundle:nil];
}

@end
