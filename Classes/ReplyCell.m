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
  preview.text = post.preview;
  CGFloat indentation = 10 + post.depth * INDENDATION;
  preview.frame = CGRectMake(indentation, 0, self.contentView.frame.size.width - indentation, [ReplyCell cellHeight]);
  
  [super layoutSubviews];
}

- (void)dealloc {
  self.post = nil;
  [super dealloc];
}


@end
