//
//  UIImage+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 2/17/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HelperKit) <NSCoding>

#pragma mark NSCoding Support
- (id)initWithCoder:(NSCoder*)decoder;
- (void)encodeWithCoder:(NSCoder*)encoder;

#pragma mark Image Manipulation

// Returns a new UIImage resized to the provided size, ignoring aspect ratio
- (UIImage*)imageByResizing:(CGSize)newSize;

@end
