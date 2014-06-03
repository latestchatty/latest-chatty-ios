//
//  ComposeViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009. All rights reserved.
//

#import "ComposeViewController.h"

@implementation ComposeViewController

@synthesize storyId, post;

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
    [submitPostButton setTitleTextAttributes:[NSDictionary blueTextAttributesDictionary]
                                    forState:UIControlStateNormal];
    [submitPostButton setTitleTextAttributes:[NSDictionary blueHighlightTextAttributesDictionary]
                                    forState:UIControlStateDisabled];
	self.navigationItem.rightBarButtonItem = submitPostButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
	
    UITapGestureRecognizer *previewTapRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(previewLabelTap:)];
    [previewTapRecognizer setNumberOfTapsRequired:1];
    [parentPostPreview addGestureRecognizer:previewTapRecognizer];

    composeLabel.text = @"Compose:";
    parentPostAuthor.text = @"";
    parentPostPreview.text = @"New Post";
	if (post) {
        composeLabel.text = @"Reply to:";
        parentPostAuthor.text = post.author;
        parentPostPreview.text = post.preview;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postContentBecomeFirstResponder:) name:@"PostContentBecomeFirstResponder"
                                               object:nil];
    
    // Append inner tag view to hidden tag view container
    [tagView addSubview:innerTagView];
    [self sizeTagViewScrollView];

    // Add a style item to the text selection menu
    UIMenuController *menu = [UIMenuController sharedMenuController];
    menu.menuItems = [NSArray arrayWithObject:[[UIMenuItem alloc] initWithTitle:@"Tag" action:@selector(styleSelection)]];
    
//    [postContent becomeFirstResponder];
    postContent.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
    
    // iOS7
    self.navigationController.navigationBar.translucent = NO;
    
    // top separation bar
    UIView *topStroke = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1)];
    [topStroke setBackgroundColor:[UIColor lcTopStrokeColor]];
    [topStroke setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:topStroke];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] isPresent] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] isPresent]) {
        [UIAlertView showSimpleAlertWithTitle:@"Not Logged In"
                                      message:@"Enter your username and password in Settings."];
        
        [postContent becomeFirstResponder];
        [postContent resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [postContent becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeDisappeared" object:self];
}

- (void)styleSelection {
    // Snag the selection and current content.
    selection = postContent.selectedRange;
    [self showTagButtons];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	// Noob help alert
	if (buttonIndex == 1) {
		if ([alertView.title isEqualToString:@"Important!"]) {
            NSURLRequest *rulesPageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.shacknews.com/extras/guidelines.x"]];
			BrowserViewController *controller = [[BrowserViewController alloc] initWithRequest:rulesPageRequest];
			[[self navigationController] pushViewController:controller animated:YES];
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
        ReviewThreadViewController *reviewController = [[ReviewThreadViewController alloc] initWithPost:self.post];
        
        reviewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        reviewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:reviewController animated:YES completion:nil];
    }
}

- (void)postContentBecomeFirstResponder:(NSObject*)sender {
    [postContent becomeFirstResponder];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [LatestChatty2AppDelegate supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [LatestChatty2AppDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // resize the scroll view on rotation
    [self sizeTagViewScrollView];
}

- (void)sizeTagViewScrollView {
    // loop over the scroll view's subviews to total up their height and offset for the scroll view's content height
    CGFloat scrollViewHeight = 0.0f;
    for (UIView *view in innerTagScrollView.subviews){
        if (scrollViewHeight < view.frame.origin.y + view.frame.size.height)
            scrollViewHeight = view.frame.origin.y + view.frame.size.height;
    }
    [innerTagScrollView setContentSize:CGSizeMake(innerTagScrollView.frameWidth, scrollViewHeight)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSUInteger length = textView.text.length - range.length + text.length;
//    NSLog(@"length: %lu", (unsigned long)length);
    if (length >= 5) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return YES;
}

#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note {
    if (!keyboardShowing) {
        NSDictionary *userInfo = [note userInfo];
        CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIInterfaceOrientation orientation = self.interfaceOrientation;
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect newFrame = CGRectMake(0, imageButton.frameHeight, postContent.frameWidth, self.view.frameHeight - imageButton.frameHeight - kbSize.width);
                postContent.frame = newFrame;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect newFrame = CGRectMake(0, imageButton.frameHeight, postContent.frameWidth, self.view.frameHeight - imageButton.frameHeight - kbSize.height);
                postContent.frame = newFrame;
            }];
        }
    }
    keyboardShowing = YES;
}

- (void)keyboardDidHide:(NSNotification *)note {
    if (keyboardShowing) {
        NSDictionary *userInfo = [note userInfo];
        CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIInterfaceOrientation orientation = self.interfaceOrientation;
        
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect newFrame = CGRectMake(0, imageButton.frameHeight, postContent.frameWidth, self.view.frameHeight - imageButton.frameHeight + kbSize.width);
                postContent.frame = newFrame;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect newFrame = CGRectMake(0, imageButton.frameHeight, postContent.frameWidth, self.view.frameHeight - imageButton.frameHeight + kbSize.height);
                postContent.frame = newFrame;
            }];
        }
    }
    keyboardShowing = NO;
}

#pragma mark Image Handling

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [viewController setNeedsStatusBarAppearanceUpdate];
}

- (IBAction)showImagePicker {
    [postContent resignFirstResponder];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *dialog = [[UIActionSheet alloc] initWithTitle:@"Upload Image"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Library", nil];
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
		
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.sourceType = sourceType;
        imagePicker.navigationBar.barStyle = UIBarStyleBlack;
        
        if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
            popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            popoverController.delegate = self;
            [popoverController presentPopoverFromRect:imageButton.frame
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
        } else {
            [self presentViewController:imagePicker animated:YES completion:nil];
		}
	}
}

- (UIProgressView*)showActivityIndicator:(BOOL)progressViewType {
    [[LatestChatty2AppDelegate delegate] setNetworkActivityIndicatorVisible:YES];
    
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
        uploadBar.progress = 0;
		progressBar = uploadBar;
	}
	
	return progressBar;
}

- (void)hideActivityIndicator {
	[activityView removeFromSuperview];
	[spinner stopAnimating];
    [[LatestChatty2AppDelegate delegate] setNetworkActivityIndicatorVisible:NO];
}

- (void)image:(Image*)image sendComplete:(NSString*)url {
	postContent.text = [postContent.text stringByAppendingString:url];
	[self hideActivityIndicator];
	[postContent becomeFirstResponder];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)image:(Image*)image sendFailure:(NSString*)message {
    [UIAlertView showSimpleAlertWithTitle:@"Upload Failed"
                                  message:@"There was an error uploading your photo. Be sure you have set a valid ChattyPics.com username and password in Settings."];
	[self hideActivityIndicator];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)anImage
                  editingInfo:(NSDictionary *)editingInfo
{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
	[postContent resignFirstResponder];
	Image *image = [[Image alloc] initWithImage:anImage];
	image.delegate = self;
	
	UIProgressView* progressBar = [self showActivityIndicator:YES];
    BOOL picsResize = [[NSUserDefaults standardUserDefaults] boolForKey:@"picsResize"];
    float picsQuality = [[NSUserDefaults standardUserDefaults] floatForKey:@"picsQuality"];
    
    if (picsResize) {
//        [image autoRotate:800 scale:YES];
        [image autoRotate:1600 scale:YES];
    } else {
        [image autoRotate:anImage.size.width scale:NO];
    }

    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
                           progressBar, @"progressBar",
                           [NSNumber numberWithFloat:picsQuality], @"qualityAmount",
                           nil];
    [image performSelectorInBackground:@selector(uploadAndReturnImageUrlWithDictionary:) withObject:args];
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [popoverController dismissPopoverAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [popoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController*)pc {
    if (popoverController == pc) {
        popoverController = nil;
    }
}

#pragma mark Tagging

- (void)showTagButtons {
	CGRect frame = self.view.frame;
	frame.origin = CGPointZero;
	innerTagView.frame = frame;
    
    tagView.hidden = NO;
    tagView.alpha = 0.0;
    tagView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.35 animations:^(void) {
        tagView.alpha = 1.0;
        tagView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
	[postContent resignFirstResponder];
}


- (IBAction)tag:(id)sender {
	NSString *tag = [tagLookup objectForKey:[(UIButton *)sender currentTitle]];
    
    NSMutableString *result = [postContent.text mutableCopy];
    
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
	
    [self closeTagView];
    [postContent setSelectedRange:NSMakeRange(selection.location + prefix.length, selection.length)];
}

- (IBAction)closeTagView {
    // Close tag view
    [UIView animateWithDuration:0.35
                     animations:^(void) {
                         tagView.alpha = 0.0;
                         tagView.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     }
                     completion:^(BOOL finished) {
                         tagView.hidden = YES;
                     }];
    
    // Reactivate the text view with the text still selected.
	[postContent becomeFirstResponder];
	[postContent setSelectedRange:NSMakeRange(selection.location, selection.length)];
}

#pragma mark Actions

- (void)postSuccess {
    ModelListViewController *controller;
    
    // new root post success in iPad = refresh chatty controller
    if (post.modelId == 0 && [[LatestChatty2AppDelegate delegate] isPadDevice]) {
        controller = (ModelListViewController *)[[[LatestChatty2AppDelegate delegate] navigationController] topViewController];
    } else {
        // always send refesh msg to previous controller after success on iPhone
        controller = (ModelListViewController *)self.navigationController.backViewController;
    }
    [controller refresh:self];
    
	[self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeDisappeared" object:self];
	[self hideActivityIndicator];
}

- (void)postFailure {
	//self.navigationController.view.userInteractionEnabled = YES;
	[self hideActivityIndicator];
}

- (void)makePost {
    @autoreleasepool {
		//self.navigationController.view.userInteractionEnabled = NO;
    
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
	}
}

- (void)sendPost {
    [postContent becomeFirstResponder];
    [postContent resignFirstResponder];
    
    postingWarningAlertView = YES;
    [UIAlertView showWithTitle:@"Post"
                       message:@"Submit this post?"
                      delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"Send", nil];
}

#pragma mark Cleanup

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    // Remove special style item from text selection menu
    [UIMenuController sharedMenuController].menuItems = nil;
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
