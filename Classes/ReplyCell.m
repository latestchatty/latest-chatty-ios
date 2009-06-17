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
  
  // Set the cell text
  preview.text = post.preview;
  
  // Set the indentation depth
  CGFloat indentation = 3 + post.depth * INDENDATION;
  preview.frame = CGRectMake(indentation, 0, self.contentView.frame.size.width - indentation, [ReplyCell cellHeight]);
  
  // Choose a text color based on time level of the post
  if (post.timeLevel >= 4) {
    grayBullet.alpha = 0.2;
  } else {
    grayBullet.alpha = 1.0 - (0.2 * post.timeLevel);
  }
  
  // Set latest to bold
  if (post.timeLevel == 0) {
    preview.font = [UIFont boldSystemFontOfSize:14];
  } else {
    preview.font = [UIFont systemFontOfSize:14];
  }
  
  // Only show blue bullet if this is my post.
  CGRect bulletFrame = CGRectMake(indentation - 15, 7, 10, 10);
  blueBullet.frame = bulletFrame;
  grayBullet.frame = bulletFrame;
  if ([post.author isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]) {
    blueBullet.hidden = (post.depth == 0);
    grayBullet.hidden = YES;
  } else {
    blueBullet.hidden = YES;
    grayBullet.hidden = (post.depth == 0);
  }
  
  // Set category stripe
  categoryStripe.backgroundColor = [post categoryColor];
  categoryStripe.frame = CGRectMake(indentation - 3, categoryStripe.frame.origin.y, categoryStripe.frame.size.width, categoryStripe.frame.size.height);
}

- (void)dealloc {
  self.post = nil;
  [super dealloc];
}


@end
