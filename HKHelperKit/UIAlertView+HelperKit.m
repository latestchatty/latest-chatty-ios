//
//  UIAlertView+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 2/23/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UIAlertView+HelperKit.h"


@implementation UIAlertView (HelperKit)

+ (void)showSimpleAlertWithTitle:(NSString*)title message:(NSString*)message {
    [self showSimpleAlertWithTitle:title message:message buttonTitle:@"OK"];
}

+ (void)showSimpleAlertWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
             delegate:(id)delegate
    cancelButtonTitle:(NSString *)cancelButtonTitle
    otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:delegate
                                           cancelButtonTitle:cancelButtonTitle
                                           otherButtonTitles:otherButtonTitles] autorelease];
    [alert show];
}

@end
