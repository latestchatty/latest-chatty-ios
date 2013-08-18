//
//  RootCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RootCell.h"
#import "CustomBadge.h"

@implementation RootCell

@synthesize title, iconImage, badge;

+ (CGFloat)cellHeight {
    return 68;
}

- (id)init {
    self = [super initWithNibName:@"RootCell" bundle:nil];
  
    self.textLabel.font = [UIFont boldSystemFontOfSize:24];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.shadowColor = [UIColor lcTextShadowColor];
    self.textLabel.shadowOffset = CGSizeMake(0, -1);

    // create a custom selection view with a gray color and has a height 1 pt less so that the black stroke view at the bottom of the cell is still visible
    UIView *selectionView = [[UIView alloc] initWithFrame:CGRectMake(self.frameX, self.frameY, self.frameWidth, self.frameHeight-1)];
    selectionView.backgroundColor = [UIColor lcSelectionGrayColor];
    self.selectedBackgroundView = selectionView;
    [selectionView release];
    
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
  
    if ([self.title isEqualToString:@"LatestChatty"]) {
        self.iconImage.image = [UIImage imageNamed:@"LatestChatIcon.48.png"];
        self.iconImage.highlightedImage = [UIImage imageNamed:@"LatestChatIcon.48-Active.png"];
    }
    else if ([self.title hasPrefix:@"Messages"]) {
        self.iconImage.image = [UIImage imageNamed:@"MessagesIcon.48.png"];
        self.iconImage.highlightedImage = [UIImage imageNamed:@"MessagesIcon.48-Active.png"];
    }
    else {
        self.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Icon.48.png", self.title]];
        self.iconImage.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Icon.48-Active.png", self.title]];
    }
}

- (void)setBadgeWithNumber:(int)badgeNumber {
    [self.badge setHidden:YES];
    
    // modify left edge of badge frame depending on how many digits are in the unread message count
    float leftEdge = self.iconImage.frameWidth - 20;
    if (badgeNumber >= 10) leftEdge = leftEdge - 10;
    if (badgeNumber >= 100) leftEdge = leftEdge - 10;
    if (badgeNumber >= 1000) leftEdge = leftEdge - 10;
    [self.badge setFrame:CGRectMake(leftEdge, 0, self.badge.frame.size.width, self.badge.frame.size.height)];
    
    //use autoBadgeSizeWithString to set value in badge after it has been initialized
    [self.badge autoBadgeSizeWithString:[NSString stringWithFormat:@"%i", badgeNumber]];
    
    //only show if the number is positive
    if (badgeNumber > 0) [self.badge setHidden:NO];
}

- (void)dealloc {
    [title release];
    [titleLabel release];
    [iconImage release];
    [badge release];
    [super dealloc];
}

@end
