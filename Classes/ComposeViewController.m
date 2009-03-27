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
  if (self = [super initWithNibName:@"ComposeViewController" bundle:nil]) {
    self.storyId = aStoryId;
    self.post = aPost;
  }
  return self;
}

- (void)viewDidLoad {
  if (post) parentPostPreview.text = post.preview;
  
  [postContent becomeFirstResponder];
}

- (IBAction)showTagButtons {
  [postContent resignFirstResponder];
}

- (IBAction)showImagePicker {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Implemented"
                                                  message:@"Stay tuned"
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];
}

- (IBAction)tag:(id)sender {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Implemented"
                                                  message:@"Stay tuned"
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];
}

- (IBAction)dismiss {
  [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendPost {
  NSUInteger parentId = 0;
  if (post) parentId = post.modelId;
  
  if ([Post createWithBody:postContent.text parentId:post.modelId storyId:storyId]) {
    [self.navigationController dismissModalViewControllerAnimated:YES];
  } else {
    NSLog(@"Failure!");
  }
}


- (void)dealloc {
  self.post = nil;
  [super dealloc];
}


@end
