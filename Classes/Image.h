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

@class Image;
@protocol ImageSendingDelegate
- (void)image:(Image*)image sendComplete:(NSString*)url;
- (void)image:(Image*)image sendFailure:(NSString*)message;
@end


@interface Image : NSObject {
	UIImage *image;
	NSObject<ImageSendingDelegate>* delegate;
}
@property (assign,nonatomic) NSObject<ImageSendingDelegate>* delegate;
@property (retain) UIImage *image;

- (id)initWithImage:(UIImage *)anImage;
- (void)autoRotateAndScale:(NSUInteger)maxDimension;
- (NSData *)compressJpeg:(CGFloat)quality;
- (NSString *)base64String;
- (NSString *)uploadAndReturnImageUrlWithProgressView:(UIProgressView*)progressView;

@end
