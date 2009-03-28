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
  NSString *tag = [tagLookup objectForKey:[(UIButton *)sender currentTitle]];
  postContent.text = [postContent.text stringByAppendingString:tag];
  
  NSUInteger textLength = [[postContent text] length];
  NSUInteger tagLength  = [tag length];
  [postContent becomeFirstResponder];
  [postContent setSelectedRange:NSMakeRange(textLength - tagLength/2, 0)];
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
  [tagLookup release];
  self.post = nil;
  [super dealloc];
}


@end
