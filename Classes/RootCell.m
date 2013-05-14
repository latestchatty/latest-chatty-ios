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
  
  self.textLabel.font = [UIFont boldSystemFontOfSize:24];
  self.textLabel.textColor = [UIColor whiteColor];
  self.textLabel.shadowColor = [UIColor blackColor];
  self.textLabel.shadowOffset = CGSizeMake(0, -1);
  
  UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
//  backgroundView.image = [[UIImage imageNamed:@"CellBackground.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
  backgroundView.contentMode = UIViewContentModeScaleToFill;
  backgroundView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.backgroundView = backgroundView;
  [backgroundView release];
  
  self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
  
  return self;
}

- (void)layoutSubviews {
  titleLabel.text = self.title;
  
  if ([self.title isEqualToString:@"LatestChatty"])
    iconImage.image = [UIImage imageNamed:@"LatestChatIcon.48.png"];
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
