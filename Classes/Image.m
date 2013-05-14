//
//  Image.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Image.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@implementation Image

@synthesize image, delegate;

- (id)initWithImage:(UIImage *)anImage {
	[super init];
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
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	// Clean and resize image -- this cannot be done on a thread
	//[self autoRotateAndScale:800];
	
	// Setup raw image data
	//NSString *imageBase64Data = [self base64String];
	
	// Request setup
	//NSString *urlString = [Model urlStringWithPath:@"/images"];
    
    NSString *urlString = @"http://chattypics.com/upload.php";
    NSString *loginString = @"http://chattypics.com/users.php?act=login_go";
    
    ASIFormDataRequest *loginRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:loginString]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *picsUsername = [[defaults stringForKey:@"picsUsername"] stringByEscapingURL];
    NSString *picsPassword = [[defaults stringForKey:@"picsPassword"] stringByEscapingURL];

    [loginRequest setPostValue:picsUsername forKey:@"user_name"];
    [loginRequest setPostValue:picsPassword forKey:@"user_password"];
    
    [loginRequest start];
    
    NSString *loginResponseString = [loginRequest responseString];
    
    // Should we even bother the notifying user if they couldn't login?
    // The only benefits of logging in are the increased filelimits (doesn't really matter
    // as we heavily compress the image) and saving to the user's gallery...
    if ([loginResponseString containsString:@"Logged In"]) {
        NSLog(@"Logged into ChattyPics");
    }

	//NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	//ASIHTTPRequest* request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
//    NSLog(@"qualityAmount: %f", [[args objectForKey:@"qualityAmount"] floatValue]);
    [request setData:[self compressJpeg:[[args objectForKey:@"qualityAmount"] floatValue]] withFileName:@"iPhoneUpload.jpg" andContentType:@"image/jpeg" forKey:@"userfile[]"];
    
    //[request setRequestMethod:@"POST"];
	[request setUploadProgressDelegate:[args objectForKey:@"progressView"]];
	//[request setHTTPMethod:@"POST"];
	
	// Create the post body
	/*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [[defaults stringForKey:@"username"] stringByEscapingURL];
	NSString *password = [[defaults stringForKey:@"password"] stringByEscapingURL];
	NSString *postBody = [NSString stringWithFormat:@"username=%@&password=%@&filename=iPhoneUpload.jpg&image=%@", username, password, imageBase64Data];
	[request appendPostData:[postBody dataUsingEncoding:NSASCIIStringEncoding]];*/
	//[request setHTTPBody:[postBody dataUsingEncoding:NSASCIIStringEncoding]];
	
	// Send the request
	//NSHTTPURLResponse *response;
	//NSError *error;
	[request start];
	
	NSString *responseString = [request responseString];
	// Cleanup the request
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	// Process response
	//NSString *responseString = [NSString stringWithData:responseData];
	//NSDictionary *responseDictionary = [responseString JSONValue];
    
    // regex will fail if there's a second underscore anywhere in the URL, but that shouldn't happen...
    NSString *regEx = @"http://chattypics\\.com/files/iPhoneUpload_[^_]+\\.jpg";
    NSString *imageURL = [responseString stringByMatching:regEx];

	// Check for success
	//NSString *imageURL = [responseDictionary objectForKey:@"success"];
	[self performSelectorOnMainThread:@selector(informDelegateOnMainThreadWithURL:) withObject:imageURL waitUntilDone:YES];
	//[self informDelegateOnMainThread:imageURL];
    
	[pool drain];
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

- (void)dealloc {
    self.image = nil;
    [super dealloc];
}

@end
