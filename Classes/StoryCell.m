//
//  StoryCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StoryCell.h"


@implementation StoryCell

@synthesize story;

+ (CGFloat)cellHeight {
  return 80.0;
}

- (id)init {
  self = [super initWithNibName:@"StoryCell" bundle:nil];
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  title.text        = story.title;
  modelId.text      = [NSString stringWithFormat:@"%i", story.modelId];
  commentCount.text = [NSString stringWithFormat:@"%i", story.commentCount];
}

- (void)dealloc {
  [story release];
  [super dealloc];
}


@end
