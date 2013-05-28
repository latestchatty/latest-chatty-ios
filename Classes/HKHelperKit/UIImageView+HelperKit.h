//
//  UIImageView+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 2/26/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImageView (HelperKit)

+ (id)viewWithImage:(UIImage*)image;
+ (id)viewWithImageNamed:(NSString*)imageName;
+ (id)viewWithImageURL:(NSURL*)imageURL;
+ (id)viewWithImageURLString:(NSString*)imageURLString;

@end
