//
//  UIImage+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 2/17/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UIImage+HelperKit.h"

@implementation UIImage (HelperKit)

#pragma mark NSCoding Support

- (id)initWithCoder:(NSCoder*)decoder {
    NSData *data = [decoder decodeObjectForKey:@"HKUIImageNSCodingDataKey"];
    return [self initWithData:data];
}

- (void)encodeWithCoder:(NSCoder*)encoder {
    NSData *data = UIImagePNGRepresentation(self);
    [encoder encodeObject:data forKey:@"HKUIImageNSCodingDataKey"];
}


#pragma mark Image Manipulation

- (UIImage*)imageByResizing:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
