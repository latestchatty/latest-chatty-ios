//
//  ComposeViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ComposeViewController.h"
#import "LatestChatty2AppDelegate.h"

@implementation ComposeViewController

@synthesize storyId;
@synthesize post;

- (id)initWithStoryId:(NSInteger)aStoryId post:(Post *)aPost {
	self = [super initWithNib];
	
	self.storyId = aStoryId;
	self.post = aPost;
	self.title = @"Compose";
	
	tagLookup = [[NSDictionary alloc] initWithObjectsAndKeys:
				 @"r{}r", @"Red",
				 @"g{}g", @"Green",
				 @"b{}b", @"Blue",
				 @"y{}y", @"Yellow",
				 @"e[]e", @"Olive",
				 @"l[]l", @"Lime",
				 @"n[]n", @"Orange",
				 @"p[]p", @"Pink",
				 @"/[]/", @"Italic",
				 @"b[]b", @"Bold",
				 @"q[]q", @"Quote",
				 @"s[]s", @"Small",
				 @"_[]_", @"Underline",
				 @"-[]-", @"Strike",
				 @"o[]o", @"Spoiler",
				 @"/{{}}/", @"Code",
				 nil];
	
	activityView = nil;
	return self;
}

- (void)viewDidLoad {
	UIBarButtonItem *submitPostButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(sendPost)];
	self.navigationItem.rightBarButtonItem = submitPostButton;
	[submitPostButton release];
	
    UITapGestureRecognizer *previewTapRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(previewLabelTap:)];
    [previewTapRecognizer setNumberOfTapsRequired:1];
    [parentPostPreview addGestureRecognizer:previewTapRecognizer];
    [previewTapRecognizer release];
    
	if (post) parentPostPreview.text = post.preview;
	[postContent becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postContentBecomeFirstResponder:) name:@"PostContentBecomeFirstResponder" object:nil];
    
    
    // Add a style item to the text selection menu
    UIMenuController *menu = [UIMenuController sharedMenuController];
    menu.menuItems = [NSArray arrayWithObject:[[[UIMenuItem alloc] initWithTitle:@"Style" action:@selector(styleSelection)] autorelease]];
}

- (void)styleSelection {
    // Snag the selection and current content.
    selection = postContent.selectedRange;
    [self showTagButtons];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isPresent] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] isPresent]) {
        [UIAlertView showSimpleAlertWithTitle:@"Not Logged In" message:@"Please head back to the main menu and tap \"Settings\" to set your Shacknews.com username and password"];
        
        [postContent becomeFirstResponder];
        [postContent resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
	else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hideOrientationWarning"] != YES && !activityView) {
        [UIAlertView showWithTitle:@"Important!"
                           message:@"This app is just one portal to a much larger community. If you are new here, tap \"Rules\" to read up on what to do and what not to do. Improper conduct may lead to unpleasant experiences and getting banned by community moderators.\n\n Lastly, use the text formatting tags sparingly. Please."
                          delegate:self
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:@"Rules", @"Hide", nil];
	}
}

//Patch-E: implemented fix for text view being underneath the keyboard when view appears in landscape on iPhone. Also for iPhone, resizing postContent text view and the parent view containing all shack tag buttons before the view appears based on Retina 4" or non-Retina 4" screen.
- (void)viewWillAppear:(BOOL)animated {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    CGFloat screenWidth = screenSize.width;
    
    NSUInteger availableSpacePortrait = screenHeight - 64;
    NSUInteger availableSpaceLandscape = screenWidth - 64;
    
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        UIInterfaceOrientation orientation = self.interfaceOrientation;
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [postContent setFrame:CGRectMake(0, 43, screenHeight, 62)];
            [tagView setFrame:CGRectMake(0, postContent.frameY + postContent.frameHeight, screenHeight, availableSpaceLandscape-(postContent.frameY + postContent.frameHeight))];
        } else {
            if ( screenHeight > 480 ) {
                [postContent setFrame:CGRectMake(0, 72, screenWidth, 214)];
            }
            else {
                [postContent setFrame:CGRectMake(0, 62, screenWidth, 136)];
            }
            [tagView setFrame:CGRectMake(0, postContent.frameY + postContent.frameHeight, screenWidth, availableSpacePortrait-(postContent.frameY + postContent.frameHeight))];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeDisappeared" object:self];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	// Noob help alert
	if (buttonIndex == 1) {
		if ([alertView.title isEqualToString:@"Important!"]) {
            NSURLRequest *rulesPageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.shacknews.com/extras/guidelines.x"]];
			BrowserViewController *controller = [[BrowserViewController alloc] initWithRequest:rulesPageRequest];
			[[self navigationController] pushViewController:controller animated:YES];
			[controller release];            
		} else {
            [self showActivityIndicator:NO];
			[postContent resignFirstResponder];
            [self performSelectorInBackground:@selector(makePost) withObject:nil];
		}
	} else if (buttonIndex == 2) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hideOrientationWarning"];
	}
}

- (void)previewLabelTap:(UITapGestureRecognizer *)recognizer {
    if (self.post) {
        ReviewThreadViewController *reviewController = [[[ReviewThreadViewController alloc] initWithPost:self.post] autorelease];
        
        reviewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        reviewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:reviewController animated:YES completion:nil];
    }
}

- (void)postContentBecomeFirstResponder:(NSObject*)sender {
    [postContent becomeFirstResponder];
    selection = NSMakeRange(NSNotFound, 0);
}

- (IBAction)showTagButtons {
	[postContent resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return YES;
    return YES;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

//Patch-E: implemented fix for text view being underneath the keyboard in landscape, sets coords/dimensions when in portrait or landscape on non-pad devices. Used didRotate instead of willRotate, ends up causing a minor flash when the view resizes, but it is minimal.
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
    
        //screen height/width - 64 for the status and navigation bars (20 and 44 respectively)
        NSUInteger availableSpacePortrait = screenHeight - 64;
        NSUInteger availableSpaceLandscape = screenWidth - 64;
        
        if (UIInterfaceOrientationIsLandscape(fromInterfaceOrientation)) {
            //if rotating from landscapeLeft to landscapeRight or vice versa, don't change postContent's frame
            if (postContent.frame.size.width > 320) {
                return;
            }
            
            //iPhone portrait activated, handle Retina 4" & 3.5" accordingly
            if ( screenHeight > 480 ) {
                [postContent setFrame:CGRectMake(0, 72, screenWidth, 214)];
            }
            else {
                [postContent setFrame:CGRectMake(0, 62, screenWidth, 136)];
            }
            [tagView setFrame:CGRectMake(0, postContent.frameY + postContent.frameHeight, screenWidth, availableSpacePortrait-(postContent.frameY + postContent.frameHeight))];
        } else {
            //iPhone landscape activated
            [postContent setFrame:CGRectMake(0, 43, screenHeight, 62)];
            [tagView setFrame:CGRectMake(0, postContent.frameY + postContent.frameHeight, screenHeight, availableSpaceLandscape-(postContent.frameY + postContent.frameHeight))];
        }
    }
}

#pragma mark Image Handling

- (IBAction)showImagePicker {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *dialog = [[[UIActionSheet alloc] initWithTitle:@"Insert Image"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Library", nil] autorelease];
        [dialog setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		dialog.destructiveButtonIndex = -1;
        [dialog showInView:self.view];
	} else {
		[self actionSheet:nil clickedButtonAtIndex:1];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != 2) {
		UIImagePickerControllerSourceType sourceType;
		if (buttonIndex == 0) sourceType = UIImagePickerControllerSourceTypeCamera;
		if (buttonIndex == 1) sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		
		UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
		imagePicker.delegate = self;
		imagePicker.sourceType = sourceType;
        
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
        if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
            popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            popoverController.delegate = self;
            [popoverController presentPopoverFromRect:imageButton.frame
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
        } else {
            [self presentModalViewController:imagePicker animated:YES];			
		}
//#endif
	}
}

- (UIProgressView*)showActivityIndicator:(BOOL)progressViewType {
	CGRect frame = self.view.frame;
	frame.origin = CGPointZero;
	activityView.frame = frame;
	
    UIProgressView* progressBar = nil;
	
    [self.view addSubview:activityView];
	
    if (!progressViewType) {
		activityText.text = @"Posting comment...";
		spinner.hidden = NO;
		[spinner startAnimating];
		uploadBar.hidden = YES; 
	} else {
		activityText.text = @"Uploading image...";
		spinner.hidden = YES;
		uploadBar.hidden = NO;
		progressBar = uploadBar;
	}
	
	return progressBar;
}

- (void)hideActivtyIndicator {
	[activityView removeFromSuperview];
	[spinner stopAnimating];
}

- (void)image:(Image*)image sendComplete:(NSString*)url {
	postContent.text = [postContent.text stringByAppendingString:url];
	[self hideActivtyIndicator];
	[postContent becomeFirstResponder];
}

- (void)image:(Image*)image sendFailure:(NSString*)message {
    [UIAlertView showSimpleAlertWithTitle:@"Upload Failed"
                                  message:@"Sorry but there was an error uploading your photo. Be sure you have set a valid ChattyPics.com username and password."
                              buttonTitle:@"Oopsie"];
	[self hideActivtyIndicator];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)anImage
                  editingInfo:(NSDictionary *)editingInfo
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
	[postContent resignFirstResponder];
	Image *image = [[[Image alloc] initWithImage:anImage] autorelease];
	image.delegate = self;
	
	UIProgressView* progressBar = [self showActivityIndicator:YES];
    BOOL picsResize = [[NSUserDefaults standardUserDefaults] boolForKey:@"picsResize"];
    float picsQuality = [[NSUserDefaults standardUserDefaults] floatForKey:@"picsQuality"];
    
    if (picsResize) {
        [image autoRotate:800 scale:YES];
    } else {
        [image autoRotate:anImage.size.width scale:NO];
    }

    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                           progressBar, @"progressBar",
                           [NSNumber numberWithFloat:picsQuality], @"qualityAmount",
                           nil];
    [image performSelectorInBackground:@selector(uploadAndReturnImageUrlWithDictionary:) withObject:args];
    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [popoverController dismissPopoverAnimated:YES];
    }
//#endif
}

//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
- (void)popoverControllerDidDismissPopover:(UIPopoverController*)pc {
    if (popoverController == pc) {
        [popoverController release];
        popoverController = nil;
    }
}
//#endif

#pragma mark Tagging

- (IBAction)tag:(id)sender {
	NSString *tag = [tagLookup objectForKey:[(UIButton *)sender currentTitle]];
    
    NSMutableString *result = [[postContent.text mutableCopy] autorelease];
    
    // No selection, just slap the tag on the end.
    if (selection.location == NSNotFound) {
        selection = NSMakeRange(result.length, 0);
    }
    
    // Calculate prefix and suffix of the tag.
    NSString *prefix = [tag substringToIndex:tag.length/2];
    NSString *suffix = [tag substringFromIndex:tag.length/2];
    
    // Insert the tag around the selected text.
    [result insertString:prefix atIndex:selection.location];
    [result insertString:suffix atIndex:selection.location + selection.length + prefix.length];
    
    // Update the post content
	postContent.text = result;
	
    // Reactivate the text view with the text still selected.
	[postContent becomeFirstResponder];
	[postContent setSelectedRange:NSMakeRange(selection.location + prefix.length, selection.length)];
}

#pragma mark Actions

- (void)postSuccess {
	self.navigationController.view.userInteractionEnabled = YES;
	ModelListViewController *lastController = (ModelListViewController *)self.navigationController.backViewController;
	[lastController refresh:self];
	[self.navigationController popViewControllerAnimated:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeDisappeared" object:self];
	[self hideActivtyIndicator];
}

- (void)postFailure {
	self.navigationController.view.userInteractionEnabled = YES;
//    [UIAlertView showSimpleAlertWithTitle:@"Post Failure"
//                                  message:@"There seems to have been an issue making the post. Try again!"
//                              buttonTitle:@"Bummer"];
	[self hideActivtyIndicator];
}

- (void)makePost {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	self.navigationController.view.userInteractionEnabled = NO;
    
    //Patch-E: wrapped existing code in GCD blocks to avoid UIKit on background thread issues that were causing status/nav bar flashing and the console warning:
    //"Obtaining the web lock from a thread other than the main thread or the web thread. UIKit should not be called from a secondary thread."
    //[Post createWithBody:parentId:storyId:] was the culprit causing the UIKit on background thread issue
    //this started happening in iOS 6
    //same change made to [SendMessageViewController makeMessage:]
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL success = [Post createWithBody:postContent.text parentId:post.modelId storyId:storyId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self performSelectorOnMainThread:@selector(postSuccess) withObject:nil waitUntilDone:NO];
            } else {
                [self performSelectorOnMainThread:@selector(postFailure) withObject:nil waitUntilDone:NO];
            }
        });
    });
    
	postingWarningAlertView = NO;
	[pool release];
}

- (IBAction)sendPost {
    [postContent becomeFirstResponder];
    [postContent resignFirstResponder];
    
    postingWarningAlertView = YES;
    [UIAlertView showWithTitle:@"Post"
                       message:@"Submit this post?"
                      delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"Send", nil];
}

- (void)dealloc {
    NSLog(@"ComposeViewController dealloc");
    
    // Remove special style item from text selection menu
    [UIMenuController sharedMenuController].menuItems = nil;
    
	[parentPostPreview release];
	[postContent release];
    [tagView release];
	
	[activityView release];
	[activityText release];
	[spinner release];
	[uploadBar release];
	
	[tagLookup release];
	self.post = nil;
	[super dealloc];
}

@end
