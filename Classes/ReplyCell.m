//
//  ReplyCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ReplyCell.h"

#define INDENDATION 15.0

@implementation ReplyCell

@synthesize post;

+ (CGFloat)cellHeight {
  return 24.0;
}

- (id)init {
  self = [super initWithNibName:@"ReplyCell" bundle:nil];
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  preview.text = post.preview;
  CGFloat indentation = 10 + post.depth * INDENDATION;
  preview.frame = CGRectMake(indentation, 0, self.contentView.frame.size.width - indentation, [ReplyCell cellHeight]);
  
  
  // Choose a text color based on time level of the post
  if (post.timeLevel > 10) {
    preview.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
  } else {
    preview.textColor = [UIColor colorWithWhite:1.0 alpha:(1 - (CGFloat)post.timeLevel / 10.0) * 0.5 + 0.5];
  }
}

- (void)dealloc {
  self.post = nil;
  [super dealloc];
}


@end
