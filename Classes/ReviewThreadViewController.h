//
//  ReviewThreadViewController.h
//  LatestChatty2
//
//  Created by Patrick Crager on 5/2/13.
//

#import <UIKit/UIKit.h>
//#import "ModelListViewController.h"
#import "Post.h"

@interface ReviewThreadViewController : UIViewController <UIWebViewDelegate> {
    Post *rootPost;

    IBOutlet UIView *postViewContainer;
    IBOutlet UIWebView *postView;
}

@property (retain) Post *rootPost;

- (id)initWithPost:(Post *)aPost;

@end