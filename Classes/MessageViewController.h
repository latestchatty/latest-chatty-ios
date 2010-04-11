//
//  MessageViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "StringTemplate.h"
#import "BrowserViewController.h"

@interface MessageViewController : UIViewController <UIWebViewDelegate> {
  Message *message;
  
  IBOutlet UIWebView *webView;
}

@property (retain) Message *message;

- (id)initWithMesage:(Message *)aMessage;

@end
