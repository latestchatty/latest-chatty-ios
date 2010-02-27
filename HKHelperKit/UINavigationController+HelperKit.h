//
//  UINavigationController+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 2/23/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (HelperKit)

@property (nonatomic, readonly, retain) UIViewController *backViewController;

+ (UINavigationController*)controllerWithRootController:(UIViewController*)controller;

@end
