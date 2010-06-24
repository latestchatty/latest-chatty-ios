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
	UIBarButtonItem *submitPostButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit Post" style:UIBarButtonItemStyleDone target:self action:@selector(sendPost)];
	self.navigationItem.rightBarButtonItem = submitPostButton;
	[submitPostButton release];
	
	
	if (post) parentPostPreview.text = post.preview;
	[postContent becomeFirstResponder];
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


- (IBAction)showTagButtons {
	[postContent resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return YES;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}



#pragma mark Image Handling
- (IBAction)showImagePicker {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *dialog = [[[UIActionSheet alloc] initWithTitle:@"Insert Image"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Library", nil] autorelease];
		dialog.actionSheetStyle = UIBarStyleBlackOpaque;
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
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
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
#endif
	}
}

- (UIProgressView*)showActivityIndicator:(BOOL)progressViewType;
{
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

- (void)hideActivtyIndicator
{
	[activityView removeFromSuperview];
	[spinner stopAnimating];
}

- (void)image:(Image*)image sendComplete:(NSString*)url
{
	postContent.text = [postContent.text stringByAppendingString:url];
	[self hideActivtyIndicator];
	[postContent becomeFirstResponder];
}

- (void)image:(Image*)image sendFailure:(NSString*)message
{
    [UIAlertView showSimpleAlertWithTitle:@"Upload Failed"
                                  message:@"Sorry but there was an error uploading your photo.  Be sure you have set a valid Shacknews.com username and password."
                              buttonTitle:@"Oopsie"];
	[self hideActivtyIndicator];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)anImage editingInfo:(NSDictionary *)editingInfo {
	[self.navigationController dismissModalViewControllerAnimated:YES];
	[postContent resignFirstResponder];
	Image *image = [[[Image alloc] initWithImage:anImage] autorelease];
	image.delegate = self;
	
	UIProgressView* progressBar = [self showActivityIndicator:YES];	
	[image autoRotateAndScale:800];
    [image performSelectorInBackground:@selector(uploadAndReturnImageUrlWithProgressView:) withObject:progressBar];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if ([[LatestChatty2AppDelegate delegate] isPadDevice]) {
        [popoverController dismissPopoverAnimated:YES];
    }
#endif
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
- (void)popoverControllerDidDismissPopover:(UIPopoverController*)pc {
    if (popoverController == pc) {
        [popoverController release];
        popoverController = nil;
    }
}
#endif

#pragma mark Tagging
- (IBAction)tag:(id)sender {
	NSString *tag = [tagLookup objectForKey:[(UIButton *)sender currentTitle]];
	postContent.text = [postContent.text stringByAppendingString:tag];
	
	NSUInteger textLength = [[postContent text] length];
	NSUInteger tagLength  = [tag length];
	[postContent becomeFirstResponder];
	[postContent setSelectedRange:NSMakeRange(textLength - tagLength/2, 0)];
}

#pragma mark Actions

- (void)postSuccess
{
	self.navigationController.view.userInteractionEnabled = YES;
	ModelListViewController *lastController = (ModelListViewController *)self.navigationController.backViewController;
	[lastController refresh:self];
	[self.navigationController popViewControllerAnimated:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ComposeDisappeared" object:self];
	[self hideActivtyIndicator];
}

- (void)postFailure
{
	self.navigationController.view.userInteractionEnabled = YES;
    [UIAlertView showSimpleAlertWithTitle:@"Post Failure"
                                  message:@"There seems to have been an issue making the post. Try again!"
                              buttonTitle:@"Bummer"];
	[self hideActivtyIndicator];
}

- (void)makePost 
{
    [postContent resignFirstResponder];
    
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	self.navigationController.view.userInteractionEnabled = NO;
	if ([Post createWithBody:postContent.text parentId:post.modelId storyId:storyId]) {
		[self performSelectorOnMainThread:@selector(postSuccess) withObject:nil waitUntilDone:NO];
	} else {
		[self performSelectorOnMainThread:@selector(postFailure) withObject:nil waitUntilDone:NO];
	}
	postingWarningAlertView = NO;
	[pool release];
}

- (IBAction)sendPost {
    postingWarningAlertView = YES;
    [UIAlertView showWithTitle:@"Post?"
                       message:@"Submit this post?"
                      delegate:self
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@"Send", nil];
}

- (void)dealloc {
	[parentPostPreview release];
	[postContent release];
	
	[activityView release];
	[activityText release];
	[spinner release];
	[uploadBar release];
	
	[tagLookup release];
	self.post = nil;
	[super dealloc];
}


@end
