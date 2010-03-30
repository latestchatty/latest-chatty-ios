//
//  ImageViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/12/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageViewController : UIViewController <UIScrollViewDelegate> {
    NSURL *url;
    UIScrollView *scrollView;
    UIImageView *imageView;
    UIActivityIndicatorView *loadingIndicator;
    
    NSURLConnection *imageDownloader;
    NSMutableData *imageData;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic, retain) NSURLConnection *imageDownloader;
@property (nonatomic, retain) NSMutableData *imageData;

+ (id)controllerWithURL:(NSURL*)url;
- (id)initWithURL:(NSURL*)url;

- (void)doneLoadingImageData;

@end
