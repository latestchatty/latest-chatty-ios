//
//  RootCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RootCell.h"


@implementation RootCell

@synthesize title;

+ (CGFloat)cellHeight {
  return 68;
}


- (id)init {
  self = [super initWithNibName:@"RootCell" bundle:nil];
  return self;
}

- (void)layoutSubviews {
  titleLabel.text = self.title;
  
  if ([self.title isEqualToString:@"Latest Chatty"])
    iconImage.image = [UIImage imageNamed:@"ChatIcon.48.png"];
  else if ([self.title hasPrefix:@"Messages"])
    iconImage.image = [UIImage imageNamed:@"MessagesIcon.48.png"];
  else
    iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Icon.48.png", self.title]];
}

- (void)dealloc {
  [title release];
  [super dealloc];
}


@end
