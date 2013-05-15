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

@interface ComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIActionSheetDelegate, ImageSendingDelegate, UIPopoverControllerDelegate> {
    NSInteger storyId;
	Post *post;
	
	NSDictionary *tagLookup;
	
	BOOL postingWarningAlertView;
	
    IBOutlet UILabel *composeLabel;
    IBOutlet UILabel *parentPostAuthor;
	IBOutlet UILabel *parentPostPreview;
	IBOutlet UITextView *postContent;
    IBOutlet UIView *tagView;
    IBOutlet UIView *innerTagView;
	
	IBOutlet UIView* activityView;
	IBOutlet UILabel* activityText;
	IBOutlet UIActivityIndicatorView* spinner;
	IBOutlet UIProgressView* uploadBar;
    
    IBOutlet UIButton *imageButton;
    
    NSRange selection;
    
    UIPopoverController *popoverController;
}

@property (assign) NSInteger storyId;
@property (retain) Post *post;

- (id)initWithStoryId:(NSInteger)aStoryId post:(Post *)aPost;
- (void)makePost;
- (UIProgressView*)showActivityIndicator:(BOOL)progressViewType;

- (IBAction)showImagePicker;
- (IBAction)tag:(id)sender;

- (void)sendPost;

@end
