//
//  Imgur.h
//  LatestChatty2
//
//  Created by Boarder2 on 3/7/2020.
//

#import "Model.h"

#import "NSStringAdditions.h"

@class Imgur;

@protocol ImgurSendingDelegate
- (void)image:(Imgur*)image sendComplete:(NSString*)url;
- (void)image:(Imgur*)image sendFailure:(NSString*)message;
@end


@interface Imgur : NSObject {
	UIImage *image;
	NSObject<ImgurSendingDelegate>* __weak delegate;
}
@property (weak,nonatomic) NSObject<ImgurSendingDelegate>* delegate;
@property (strong) UIImage *image;

- (id)initWithImage:(UIImage *)anImage;
- (void)autoRotate:(NSUInteger)maxDimension scale:(BOOL)shouldScale;
//- (void)autoRotateAndScale:(NSUInteger)maxDimension;
- (NSData *)compressJpeg:(CGFloat)quality;
//- (NSString *)base64String;
- (void)uploadAndReturnImageUrlWithDictionary:(NSDictionary*)args;

@end
