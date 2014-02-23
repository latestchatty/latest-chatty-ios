//
//  RootCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009. All rights reserved.
//

#import "RootCell.h"
#import "CustomBadge.h"

@implementation RootCell

@synthesize title, iconImage, badge;

- (id)init {
    self = [super initWithNibName:@"RootCell" bundle:nil];
  
    self.backgroundColor = [UIColor clearColor];
    
    self.textLabel.font = [UIFont boldSystemFontOfSize:24];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.shadowColor = [UIColor lcTextShadowColor];
    self.textLabel.shadowOffset = CGSizeMake(0, -1);
    
    // initial custom badge, add as subview to icon view
    self.badge = [CustomBadge customBadgeWithString:nil
                                    withStringColor:[UIColor whiteColor]
                                     withInsetColor:[UIColor redColor]
                                     withBadgeFrame:YES
                                withBadgeFrameColor:[UIColor clearColor]
                                          withScale:1.0
                                        withShining:NO
                                         withShadow:NO];
    [self.iconImage addSubview:self.badge];
    [self.badge setHidden:YES];
  
    return self;
}

- (void)layoutSubviews {
    titleLabel.text = self.title;
  
    if ([self.title isEqualToString:@"Latest Chatty"]) {
        self.iconImage.image = [UIImage imageNamed:@"Chatty-Inactive.png"];
        self.iconImage.highlightedImage = [UIImage imageNamed:@"Chatty-Active.png"];
    }
    else if ([self.title hasPrefix:@"Messages"]) {
        self.iconImage.image = [UIImage imageNamed:@"Messages-Inactive.png"];
        self.iconImage.highlightedImage = [UIImage imageNamed:@"Messages-Active.png"];
    }
    else {
        self.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-Inactive.png", self.title]];
        self.iconImage.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-Active.png", self.title]];
    }
}

- (void)setBadgeWithNumber:(NSUInteger)badgeNumber {
    [self.badge setHidden:YES];
    if (badgeNumber <= 0) return;
    
    // modify left edge of badge frame depending on how many digits are in the unread message count
    float leftEdge = self.iconImage.frameWidth - 15;
    if (badgeNumber >= 10) leftEdge -= 10;
    if (badgeNumber >= 100) leftEdge -= 10;
    if (badgeNumber >= 1000) leftEdge -= 10;
    [self.badge setFrame:CGRectMake(leftEdge, -5, self.badge.frame.size.width, self.badge.frame.size.height)];
    
    //use autoBadgeSizeWithString to set value in badge after it has been initialized
    [self.badge autoBadgeSizeWithString:[NSString stringWithFormat:@"%lu", (unsigned long)badgeNumber]];
    
    //only show if the number is positive
    [self.badge setHidden:NO];
}

@end
