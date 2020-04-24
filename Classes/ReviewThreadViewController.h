//
//  ReviewThreadViewController.h
//  LatestChatty2
//
//  Created by Patrick Crager on 5/2/13.
//

#import "Post.h"

@interface ReviewThreadViewController : UIViewController <WKNavigationDelegate, WKUIDelegate> {
    Post *rootPost;

    IBOutlet UIView *postViewContainer;
    IBOutlet WKWebView *postView;
    IBOutlet UIBarButtonItem *doneButton;
}

@property (strong) Post *rootPost;

- (id)initWithPost:(Post *)aPost;

- (IBAction)dismiss;

@end
