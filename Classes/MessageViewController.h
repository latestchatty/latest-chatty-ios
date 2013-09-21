//
//  MessageViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/15/09.
//  Copyright 2009. All rights reserved.
//

#import "Message.h"
#import "StringTemplate.h"
#import "BrowserViewController.h"

@interface MessageViewController : UIViewController <UIWebViewDelegate> {
    Message *message;
    IBOutlet UIWebView *webView;
}

@property (strong) Message *message;

- (id)initWithMesage:(Message *)aMessage;

@end
