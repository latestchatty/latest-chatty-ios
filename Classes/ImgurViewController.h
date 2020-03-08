//
//  ImgurViewController.h
//  LatestChatty2
//
//  Created by Boarder2 on 3/8/2020.
//
#import <WebKit/WebKit.h>

@interface ImgurViewController : UIViewController <UIGestureRecognizerDelegate> {
    NSURLRequest *request;

    WKWebView *webView;
}

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) IBOutlet WKWebView *webView;

- (id)initWithRequest:(NSURLRequest *)request;
@end
