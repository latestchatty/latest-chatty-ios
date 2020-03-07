//
//  Imgur.m
//  LatestChatty2
//
//  Created by Boarder2 on 3/7/2020.
//

#import "Imgur.h"

@implementation Imgur

@synthesize image, delegate;

- (id)initWithImage:(UIImage *)anImage {
	if (!(self = [super init])) return nil;
	self.image = anImage;
	return self;
}

- (NSData *)compressJpeg:(CGFloat)quality {
	return UIImageJPEGRepresentation(image, quality);
}

- (void)informDelegateOnMainThreadWithURL:(NSString*)url {
	if (url) {
        [delegate image:self sendComplete:url];
    } else {
        [delegate image:self sendFailure:@"stub"];
    }
}

- (void)uploadAndReturnImageUrlWithDictionary:(NSDictionary*)args {
    // Use the AFNetworking to login and stream image data
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

	NSData *imageData = [self compressJpeg:[args[@"qualityAmount"] floatValue]];
	NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
			multipartFormRequestWithMethod:@"POST"
								 URLString:@"https://api.imgur.com/3/image"
								parameters:nil
				 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
					 [formData appendPartWithFileData:imageData name:@"image" fileName:@"iPhoneUpload.jpg" mimeType:@"image/jpeg"];
				 } error:nil];
	[request addValue:@"Client-ID REPLACEME" forHTTPHeaderField:@"Authorization"];

	NSURLSessionUploadTask *uploadTask;
	uploadTask = [manager uploadTaskWithStreamedRequest:request
			progress:^(NSProgress *uploadProgress) {
				// This is not called back on the main queue.
				// You are responsible for dispatching to the main queue for UI updates
				dispatch_async(dispatch_get_main_queue(), ^{
					//Update the progress view
					UIProgressView *progressView = args[@"progressBar"];
					[progressView setProgress:(float) uploadProgress.fractionCompleted animated:YES];
				});
			}
			completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
				if (error) {
					// Pass nil to selector so that it handles the error
					[self performSelectorOnMainThread:@selector(informDelegateOnMainThreadWithURL:) withObject:nil waitUntilDone:YES];

					//NSLog(@"Error %@ ",error);
				} else {
					// Process response

					if([responseObject isKindOfClass:[NSDictionary class]]) {
						NSDictionary *res = responseObject;
						if((BOOL)[res valueForKey:@"success"] == YES) {
							NSDictionary *resData = [res valueForKey:@"data"];
							// Pass imageURL back to selector as success
							[self performSelectorOnMainThread:@selector(informDelegateOnMainThreadWithURL:) withObject:[resData valueForKey:@"link"] waitUntilDone:YES];
							return;
						}
					}
					[self performSelectorOnMainThread:@selector(informDelegateOnMainThreadWithURL:) withObject:nil waitUntilDone:YES];
				}


			}];
	[uploadTask resume];

	imageData = nil;
	request = nil;
}

#pragma mark Image Processor

// Code from: http://discussions.apple.com/thread.jspa?messageID=7949889
- (void)autoRotate:(NSUInteger)maxDimension scale:(BOOL)shouldScale {
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (shouldScale && (width > maxDimension || height > maxDimension)) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = maxDimension;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = maxDimension;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	self.image = imageCopy;
}


@end
