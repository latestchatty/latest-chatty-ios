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
  
  return self;
}

- (void)viewDidLoad {
  UIBarButtonItem *submitPostButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit Post" style:UIBarButtonItemStyleDone target:self action:@selector(sendPost)];
  self.navigationItem.rightBarButtonItem = submitPostButton;
  [submitPostButton release];
  
  
  if (post) parentPostPreview.text = post.preview;
  [postContent becomeFirstResponder];
}

- (IBAction)showTagButtons {
  [postContent resignFirstResponder];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)anImage editingInfo:(NSDictionary *)editingInfo {
  [self.navigationController dismissModalViewControllerAnimated:YES];
  Image *image = [[Image alloc] initWithImage:anImage];
  NSString *imageURL = [image uploadAndReturnImageUrl];
  [image release];
  
  if (imageURL) {
    postContent.text = [postContent.text stringByAppendingString:imageURL];
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failed"
                                                    message:@"Sorry but there was an error uploading your photo"
                                                   delegate:nil
                                          cancelButtonTitle:@"Oopsie"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
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

- (IBAction)sendPost {
  NSUInteger parentId = 0;
  if (post) parentId = post.modelId;
  
  if ([Post createWithBody:postContent.text parentId:post.modelId storyId:storyId]) {
    NSArray *controllers = [self.navigationController viewControllers];
    ModelListViewController *lastController = [controllers objectAtIndex:[controllers count] - 2];
    [lastController refresh:nil];
    [self.navigationController popViewControllerAnimated:YES];    
  } else {
    NSLog(@"Failure!");
  }
}


- (void)dealloc {
  [tagLookup release];
  self.post = nil;
  [super dealloc];
}


@end
