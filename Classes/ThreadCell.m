//
//  ThreadCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ThreadCell.h"


@implementation ThreadCell

@synthesize story;
@synthesize rootPost;

+ (CGFloat)cellHeight {
  return 100.0;
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
}

- (void)dealloc {
  [story release];
  [super dealloc];
}


@end
