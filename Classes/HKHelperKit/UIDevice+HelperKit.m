//
//  UIDevice+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 3/25/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UIDevice+HelperKit.h"


@implementation UIDevice (HelperKit)

- (NSString*)screenTypeString {
    NSString *deviceName = [UIDevice currentDevice].model;
    deviceName = [deviceName stringByReplacingOccurrencesOfString:@" Simulator" withString:@""];
    if ([deviceName isEqualToString:@"iPod Touch"]) {
        deviceName = @"iPhone";
    }
    
    return deviceName;
}

@end
