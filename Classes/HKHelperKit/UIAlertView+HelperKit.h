//
//  UIAlertView+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 2/23/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIAlertView (HelperKit)

+ (void)showSimpleAlertWithTitle:(NSString*)title message:(NSString*)message;
+ (void)showSimpleAlertWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle;

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             delegate:(id)delegate
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
