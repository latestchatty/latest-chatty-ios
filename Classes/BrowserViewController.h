//
//  BrowserViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BrowserViewController : UIViewController <UIWebViewDelegate> {
  NSMutableURLRequest *initialRequest;
  IBOutlet UIWebView *webView;
}

- (id)initWithRequest:(NSURLRequest *)request;

- (IBAction)dragonDrop;
- (IBAction)openInSafari;

@end
