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

@interface ComposeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIActionSheetDelegate> {
  NSInteger storyId;
  Post *post;
  
  NSDictionary *tagLookup;
	
	BOOL postingWarningAlertView;
  
  IBOutlet UILabel *parentPostPreview;
  IBOutlet UITextView *postContent;
}

@property (assign) NSInteger storyId;
@property (retain) Post *post;

- (id)initWithStoryId:(NSInteger)aStoryId post:(Post *)aPost;
- (void)makePost;
- (UIProgressView*)showSpinnerWithProgressbar;

- (IBAction)showTagButtons;
- (IBAction)showImagePicker;
- (IBAction)tag:(id)sender;

- (IBAction)sendPost;

@end
