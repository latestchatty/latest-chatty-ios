//
//  UIImageView+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 2/26/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UIImageView+HelperKit.h"


@implementation UIImageView (HelperKit)

+ (UIImageView*)viewWithImage:(UIImage*)image {
    return [[[self alloc] initWithImage:image] autorelease];
}

@end
