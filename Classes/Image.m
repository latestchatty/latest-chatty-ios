//
//  Image.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/28/09.
//  Copyright 2009. All rights reserved.
//

#import "Image.h"

static NSString *kChattyPicsBaseUrl = @"http://chattypics.com";

@implementation Image

@synthesize image, delegate;

- (id)initWithImage:(UIImage *)anImage {
	if (!(self = [super init])) return nil;
	self.image = anImage;
	return self;
}

- (NSData *)compressJpeg:(CGFloat)quality {
	return UIImageJPEGRepresentation(image, quality);
}

//- (NSString *)base64String {
//	NSData *imageData = [self compressJpeg:0.7];
//	return [[NSString base64StringFromData:imageData length:[imageData length]] stringByEscapingURL];
//}

- (void)informDelegateOnMainThreadWithURL:(NSString*)url {
	if (url) {
        [delegate image:self sendComplete:url];
    } else {
        [delegate image:self sendFailure:@"stub"];
    }
}

- (void)uploadAndReturnImageUrlWithDictionary:(NSDictionary*)args {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *picsUsername = [[defaults stringForKey:@"picsUsername"] stringByEscapingURL];
    NSString *picsPassword = [[defaults stringForKey:@"picsPassword"] stringByEscapingURL];
    NSDictionary *picsParams =
        @{@"user_name": picsUsername,
          @"user_password": picsPassword};
    
    // Use the AFNetworking to login and stream image data
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@/users.php?act=login_go", kChattyPicsBaseUrl]
      parameters:picsParams
        progress:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             // Upon successful login (or failed login!), upload the image data
             //NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             //NSLog(@"Request Successful, response '%@'", responseStr);
             
             NSData *imageData = [self compressJpeg:[[args objectForKey:@"qualityAmount"] floatValue]];
             NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                multipartFormRequestWithMethod:@"POST"
                                     URLString:[NSString stringWithFormat:@"%@/upload.php", kChattyPicsBaseUrl]
                                    parameters:nil
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         [formData appendPartWithFileData:imageData name:@"userfile[]" fileName:@"iPhoneUpload.jpg" mimeType:@"image/jpeg"];
             } error:nil];
             
             NSURLSessionUploadTask *uploadTask;
             uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                        progress:^(NSProgress *uploadProgress) {
                               // This is not called back on the main queue.
                               // You are responsible for dispatching to the main queue for UI updates
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   //Update the progress view
                                   UIProgressView *progressView = [args objectForKey:@"progressBar"];
                                   [progressView setProgress:uploadProgress.fractionCompleted animated:YES];
                               });
                           }
                           completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                               if (error) {
                                   // Pass nil to selector so that it handles the error
                                   [self performSelectorOnMainThread:@selector(informDelegateOnMainThreadWithURL:) withObject:nil waitUntilDone:YES];
                                    //NSLog(@"Error %@ ",error);
                               } else {
                                   // Process response
                                   // regex will fail if there's a second underscore anywhere in the URL, but that shouldn't happen...
                                   NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                   NSString *regEx = @"http://chattypics\\.com/files/iPhoneUpload_[^_]+\\.jpg";
                                   NSString *imageURL = [NSString stringWithFormat:@"%@ ", [responseStr stringByMatching:regEx]];
                                   
                                   // Pass imageURL back to selector as success
                                   [self performSelectorOnMainThread:@selector(informDelegateOnMainThreadWithURL:) withObject:imageURL waitUntilDone:YES];
                               }
                               

                           }];
             [uploadTask resume];
             
             imageData = nil;
             request = nil;
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             // This just catches if we don't get a response from chattypics at all in general, not if they weren't successful in logging in.
             // We currently aren't telling the user if they couldn't log in successfully
             // Would need to parse the response for successful login indication in the login success block
             
             // Pass nil to selector so that it handles the error
             [self performSelectorOnMainThread:@selector(informDelegateOnMainThreadWithURL:) withObject:nil waitUntilDone:YES];
             //NSLog(@"Error %@ ",error);
         }];
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
