//
//  ComposeViewController.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Post.h"
#import "Image.h"
#import "ModelListViewController.h"
#import "BrowserViewController.h"

//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
@interface ComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIActionSheetDelegate, ImageSendingDelegate, UIPopoverControllerDelegate> {
//#else
//	@interface ComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIActionSheetDelegate, ImageSendingDelegate> {
//#endif
	NSInteger storyId;
	Post *post;
	
	NSDictionary *tagLookup;
	
	BOOL postingWarningAlertView;
	
	IBOutlet UILabel *parentPostPreview;
	IBOutlet UITextView *postContent;
    IBOutlet UIView *tagView;
	
	IBOutlet UIView* activityView;
	IBOutlet UILabel* activityText;
	IBOutlet UIActivityIndicatorView* spinner;
	IBOutlet UIProgressView* uploadBar;
    
    IBOutlet UIButton *imageButton;
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200		
    UIPopoverController *popoverController;
//#endif		
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
