//
//  ComposeViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKHelperKit.h"

#import "Post.h"
#import "Image.h"
#import "ModelListViewController.h"
#import "BrowserViewController.h"
#import "UIView+Additions.h"

@interface ComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIActionSheetDelegate, ImageSendingDelegate> {
	NSInteger storyId;
	Post *post;
	
	NSDictionary *tagLookup;
	
	BOOL postingWarningAlertView;
	
	IBOutlet UILabel *parentPostPreview;
	IBOutlet UITextView *postContent;
	
	IBOutlet UIView* activityView;
	IBOutlet UILabel* activityText;
	IBOutlet UIActivityIndicatorView* spinner;
	IBOutlet UIProgressView* uploadBar;
}

@property (assign) NSInteger storyId;
@property (retain) Post *post;

- (id)initWithStoryId:(NSInteger)aStoryId post:(Post *)aPost;
- (void)makePost;
- (UIProgressView*)showActivityIndicator:(BOOL)progressViewType;

- (IBAction)showTagButtons;
- (IBAction)showImagePicker;
- (IBAction)tag:(id)sender;

- (IBAction)sendPost;

@end
