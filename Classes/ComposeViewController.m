//
//  ComposeViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ComposeViewController.h"


@implementation ComposeViewController

@synthesize storyId;
@synthesize post;

- (id)initWithStoryId:(NSInteger)aStoryId post:(Post *)aPost {
	[super initWithNibName:@"ComposeViewController" bundle:nil];
	
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
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hideOrientationWarning"] != YES && !activityView) {
        [UIAlertView showWithTitle:@"Important!"
                           message:@"This app is just one portal to a much larger community. If you are new here, tap \"Rules\" to read up on what to do and what not to do. Improper conduct may lead to unpleasant experiences and getting banned by community moderators.\n\n Lastly, use the text formatting tags sparingly. Please."
                          delegate:self
                 cancelButtonTitle:@"OK"
                 otherButtonTitles:@"Rules", @"Hide", nil];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	// Adjust index for missing "OK" in landscape view.
	if ([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait) buttonIndex++;
	
	// Noob help alert
	if (buttonIndex == 1) {
		if (postingWarningAlertView) {
			[self showActivityIndicator:NO];
			[postContent resignFirstResponder];
            [self performSelectorInBackground:@selector(makePost) withObject:nil];
		} else {
			NSURLRequest *rulesPageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.shacknews.com/extras/guidelines.x"]];
			BrowserViewController *controller = [[BrowserViewController alloc] initWithRequest:rulesPageRequest];
			[[self navigationController] pushViewController:controller animated:YES];
			[controller release];
		}
	} else if (buttonIndex == 2) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hideOrientationWarning"];
	}
}


- (IBAction)showTagButtons {
	[postContent resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"landscape"]) return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark Image Handling
- (IBAction)showImagePicker {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *dialog = [[UIActionSheet alloc] initWithTitle:@"Insert Image"
															delegate:self
												   cancelButtonTitle:@"Cancel"
											  destructiveButtonTitle:nil
												   otherButtonTitles:@"Camera", @"Library", nil];
		dialog.actionSheetStyle = UIBarStyleBlackOpaque;
		dialog.destructiveButtonIndex = -1;
		[dialog showInView:self.view];
		[dialog release];
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
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	}
}

- (UIProgressView*)showActivityIndicator:(BOOL)progressViewType;
{
	//UIWindow* activeView = self.navigationController.view;
	//CGRect frame = activeWindow.frame;
	/*CGRect frame = self.view.frame;
	 frame.origin = CGPointZero;
	 
	 UIProgressView* progressBar = nil;
	 
	 if( activityView ) [activityView removeFromSuperview];
	 activityView = [[UIView alloc] initWithFrame:frame];
	 activityView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
	 
	 UILabel* message = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
	 message.backgroundColor = [UIColor clearColor];
	 message.textColor = [UIColor whiteColor];
	 message.font = [UIFont boldSystemFontOfSize:18];
	 
	 UIView* animatedView = nil;
	 
	 if( !progressViewType ){
	 UIActivityIndicatorView* spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	 message.text = @"Posting comment...";
	 spinner.tag = 1;
	 [spinner startAnimating];
	 animatedView = spinner;
	 }
	 else{
	 progressBar = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar] autorelease];
	 message.text = @"Uploading image...";
	 [progressBar sizeToFit];
	 frame = progressBar.frame;
	 frame.size.width = 200;
	 progressBar.frame = frame;
	 
	 animatedView = progressBar;
	 }
	 
	 [message sizeToFit];
	 
	 frame = [animatedView centerInView:self.view];
	 frame.origin.y+=15;
	 animatedView.frame = frame;
	 
	 frame = [message centerInView:self.view];
	 frame.origin.y-=15;
	 message.frame = frame;
	 
	 [self.view addSubview:activityView];
	 [activityView addSubview:message];
	 [activityView addSubview:animatedView];
	 [activityView release];
	 */
	CGRect frame = self.view.frame;
	frame.origin = CGPointZero;
	activityView.frame = frame;
	UIProgressView* progressBar = nil;
	[self.view addSubview:activityView];
	if( !progressViewType ){
		activityText.text = @"Posting comment...";
		spinner.hidden = NO;
		[spinner startAnimating];
		uploadBar.hidden = YES; 
	}
	else{
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
	//UIActivityIndicatorView* actView = (UIActivityIndicatorView*)[activityView viewWithTag:1];
	//if( actView ) [actView stopAnimating];
	//[activityView removeFromSuperview];
	//activityView = nil;
}

- (void)image:(Image*)image sendComplete:(NSString*)url
{
	postContent.text = [postContent.text stringByAppendingString:url];
	[image release];
	[self hideActivtyIndicator];
	[postContent becomeFirstResponder];
}

- (void)image:(Image*)image sendFailure:(NSString*)message
{
    [UIAlertView showSimpleAlertWithTitle:@"Upload Failed"
                                  message:@"Sorry but there was an error uploading your photo"
                              buttonTitle:@"Oopsie"];
	[image release];
	[self hideActivtyIndicator];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)anImage editingInfo:(NSDictionary *)editingInfo {
	[self.navigationController dismissModalViewControllerAnimated:YES];
	[postContent resignFirstResponder];
	Image *image = [[Image alloc] initWithImage:anImage];
	image.delegate = self;
	
	UIProgressView* progressBar = [self showActivityIndicator:YES];	
	[image autoRotateAndScale:800];
    [image performSelectorInBackground:@selector(uploadAndReturnImageUrlWithProgressView:) withObject:progressBar];
}

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
