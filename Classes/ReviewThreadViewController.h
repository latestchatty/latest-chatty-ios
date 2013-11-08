//
//  ReviewThreadViewController.h
//  LatestChatty2
//
//  Created by Patrick Crager on 5/2/13.
//

#import "Post.h"

@interface ReviewThreadViewController : UIViewController <UIWebViewDelegate> {
    Post *rootPost;

    IBOutlet UIView *postViewContainer;
    IBOutlet UIWebView *postView;
    IBOutlet UIBarButtonItem *doneButton;
}

@property (strong) Post *rootPost;

- (id)initWithPost:(Post *)aPost;

- (IBAction)dismiss;

@end