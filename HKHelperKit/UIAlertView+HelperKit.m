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
                                           otherButtonTitles:otherButtonTitles, nil] autorelease];
    
    // Add a button for each string after the first in the otherButtonTitles nil terminated list
    va_list args;
    va_start(args, otherButtonTitles);
    {
        NSString *buttonTitle = nil;
        while (buttonTitle = va_arg(args, NSString*)) {
            [alert addButtonWithTitle:buttonTitle];
        }        
    }
    va_end(args);
    
    
    [alert show];
}

@end
