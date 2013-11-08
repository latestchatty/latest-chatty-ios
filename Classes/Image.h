//
//  Image.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/28/09.
//  Copyright 2009. All rights reserved.
//

#import "Model.h"

#import "NSStringAdditions.h"

@class Image;

@protocol ImageSendingDelegate
- (void)image:(Image*)image sendComplete:(NSString*)url;
- (void)image:(Image*)image sendFailure:(NSString*)message;
@end


@interface Image : NSObject {
	UIImage *image;
	NSObject<ImageSendingDelegate>* __weak delegate;
}
@property (weak,nonatomic) NSObject<ImageSendingDelegate>* delegate;
@property (strong) UIImage *image;

- (id)initWithImage:(UIImage *)anImage;
- (void)autoRotate:(NSUInteger)maxDimension scale:(BOOL)shouldScale;
//- (void)autoRotateAndScale:(NSUInteger)maxDimension;
- (NSData *)compressJpeg:(CGFloat)quality;
//- (NSString *)base64String;
- (void)uploadAndReturnImageUrlWithDictionary:(NSDictionary*)args;

@end
