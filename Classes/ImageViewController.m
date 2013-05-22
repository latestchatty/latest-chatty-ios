//
//  ImageViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/12/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "ImageViewController.h"
#import "BrowserViewController.h"


@implementation ImageViewController

@synthesize url, scrollView, imageView, loadingIndicator;
@synthesize imageDownloader, imageData;

+ (id)controllerWithURL:(NSURL*)url {
    return [[[self alloc] initWithURL:url] autorelease];
}

- (id)initWithURL:(NSURL*)_url {
    if (self = [self initWithNib]) {
        self.url = _url;
        self.title = @"Image";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.imageDownloader = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return YES;
    return NO;
}

- (void)dealloc {
    self.url = nil;
    self.scrollView = nil;
    self.imageView = nil;
    self.loadingIndicator = nil;
    
    [imageDownloader cancel];
    self.imageDownloader = nil;
    self.imageData = nil;
    
    [super dealloc];
}


- (void)doneLoadingImageData {
    [loadingIndicator stopAnimating];
    
    UIImage *image = [UIImage imageWithData:imageData];
    imageView.image = image;
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGFloat ratioX = scrollView.frame.size.width  / imageView.frame.size.width;
    CGFloat ratioY = scrollView.frame.size.height / imageView.frame.size.height;
    
    CGSize contentSize = image.size;
    if (contentSize.width > contentSize.height) contentSize.height = contentSize.width;
    if (contentSize.height > contentSize.width) contentSize.width = contentSize.height;
    
    scrollView.contentSize = contentSize;
    scrollView.minimumZoomScale = ratioX < ratioY ? ratioX : ratioY;
    scrollView.maximumZoomScale = 1.0;
    scrollView.zoomScale = scrollView.minimumZoomScale;
    
    [imageView centerInSuperview];
    imageView.alpha = 0.0;
    [imageView animateFadeIn];
}

# pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([(NSHTTPURLResponse*)response statusCode] != 200 || [response expectedContentLength] > 1000000) {
        [imageDownloader cancel];
        UINavigationController *navController = self.navigationController;
        [[self retain] autorelease];
        
        [navController popViewControllerAnimated:NO];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        BrowserViewController *browser = [[[BrowserViewController alloc] initWithRequest:request] autorelease];
        [navController pushViewController:browser animated:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!imageData) self.imageData = [NSMutableData data];
    [imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self doneLoadingImageData];
    self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

# pragma UIScrollViewDelegate (Zooming)

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    NSLog(@"done zooming");
}

@end
