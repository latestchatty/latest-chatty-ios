//
//  ThreadCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ThreadCell.h"


@implementation ThreadCell

@synthesize storyId;
@synthesize rootPost;

+ (CGFloat)cellHeight {
  return 65.0;
}

- (id)init {
  self = [super initWithNibName:@"ThreadCell" bundle:nil];
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  author.text       = rootPost.author;
  preview.text      = rootPost.preview;
  date.text         = [Post formatDate:rootPost.date];
  replyCount.text = [NSString stringWithFormat:@"%i", rootPost.replyCount];
  
  UIImageView *background = (UIImageView *)self.backgroundView;
  
  NSLog(@"%@ == %@", rootPost.author, [[NSUserDefaults standardUserDefaults] objectForKey:@"username"]);
  
  if ([rootPost.author isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]) {
    author.font = [UIFont boldSystemFontOfSize:12.0];
    background.image = [UIImage imageNamed:@"CellBackgroundLight.png"];
  } else {
    author.font = [UIFont systemFontOfSize:12.0];
    background.image = [UIImage imageNamed:@"CellBackground.png"];
  }
}

- (void)dealloc {
  self.rootPost = nil;
  [super dealloc];
}


@end
