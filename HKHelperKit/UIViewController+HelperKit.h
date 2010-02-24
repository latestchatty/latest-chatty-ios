//
//  UIViewController+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 2/23/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (HelperKit)

#pragma mark Initializers

+ (UIViewController*)controller;
+ (UIViewController*)controllerWithNibName:(NSString*)nibName;
+ (UIViewController*)controllerWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle;

- (id)initWithNibName:(NSString *)nibName;

@end
