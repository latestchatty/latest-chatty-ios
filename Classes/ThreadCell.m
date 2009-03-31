//
//  ThreadCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ThreadCell.h"

static NSMutableDictionary *colorMapping;

@implementation ThreadCell

@synthesize storyId;
@synthesize rootPost;

+ (void)initialize {
  colorMapping = [[NSMutableDictionary alloc] init];
  [colorMapping setObject:[UIColor clearColor]                                       forKey:@"ontopic"];
  [colorMapping setObject:[UIColor colorWithRed:0.02 green:0.65 blue:0.83 alpha:1.0] forKey:@"informative"];
  [colorMapping setObject:[UIColor colorWithWhite:0.6 alpha:1.0]                     forKey:@"offtopic"];
  [colorMapping setObject:[UIColor colorWithRed:0.29 green:0.52 blue:0.31 alpha:1.0] forKey:@"stupid"];
  [colorMapping setObject:[UIColor colorWithRed:0.95 green:0.69 blue:0.0  alpha:1.0] forKey:@"political"];
  [colorMapping setObject:[UIColor redColor]                                         forKey:@"nws"];
}

+ (CGFloat)cellHeight {
  return 65.0;
}

- (id)init {
  self = [super initWithNibName:@"ThreadCell" bundle:nil];
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Set text labels
  author.text       = rootPost.author;
  preview.text      = rootPost.preview;
  date.text         = [Post formatDate:rootPost.date];
  replyCount.text = [NSString stringWithFormat:@"%i", rootPost.replyCount];
  
  // Set background to a light color if the user is the root poaster
  UIImageView *background = (UIImageView *)self.backgroundView;
  if ([rootPost.author isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]]) {
    author.font = [UIFont boldSystemFontOfSize:12.0];
    background.image = [UIImage imageNamed:@"CellBackgroundLight.png"];
  } else {
    author.font = [UIFont systemFontOfSize:12.0];
    background.image = [UIImage imageNamed:@"CellBackground.png"];
  }
  
  // Set side color stripe for the post category
  NSLog(rootPost.category);
  categoryStripe.backgroundColor = [colorMapping objectForKey:rootPost.category];
}

- (void)dealloc {
  self.rootPost = nil;
  [super dealloc];
}


@end
