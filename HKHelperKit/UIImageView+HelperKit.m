//
//  UIImageView+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 2/26/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UIImageView+HelperKit.h"


@implementation UIImageView (HelperKit)

+ (id)viewWithImage:(UIImage*)image {
    return [[[self alloc] initWithImage:image] autorelease];
}

+ (id)viewWithImageNamed:(NSString*)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [self viewWithImage:image];
}

+ (id)viewWithImageURL:(NSURL*)imageURL {
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    return [UIImageView viewWithImage:image];
}

+ (id)viewWithImageURLString:(NSString*)imageURLString {
    return [self viewWithImageURL:[NSURL URLWithString:imageURLString]];
}

@end
