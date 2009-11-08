//
//  Image.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

#import "NSStringAdditions.h"
#import "StringAdditions.h"

@interface Image : NSObject {
  UIImage *image;
}

@property (retain) UIImage *image;

- (id)initWithImage:(UIImage *)anImage;
- (void)autoRotateAndScale:(NSUInteger)maxDimension;
- (NSData *)compressJpeg:(CGFloat)quality;
- (NSString *)base64String;
- (NSString *)uploadAndReturnImageUrlWithProgressView:(UIProgressView*)progressView;

@end
