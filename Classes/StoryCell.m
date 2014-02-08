//
//  StoryCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009. All rights reserved.
//

#import "StoryCell.h"

@implementation StoryCell

@synthesize story;
@synthesize chattyButton;

+ (CGFloat)cellHeight {
    return 110.0;
}

- (id)init {
    self = [super initWithNibName:@"StoryCell" bundle:nil];
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    title.text        = story.title;
    preview.text      = story.preview;
    timestamp.text    = [Story formatDate:story.date];
    commentCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)story.commentCount];
    
    // force white text color on highlight
    title.highlightedTextColor = [UIColor whiteColor];
    preview.highlightedTextColor = [UIColor whiteColor];
    timestamp.highlightedTextColor = [UIColor whiteColor];
    commentCount.highlightedTextColor = [UIColor whiteColor];
    
//	UIImageView *background = (UIImageView *)self.backgroundView;
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
//        background.image = [UIImage imageNamed:@"CellBackgroundDark.png"];
//    } else {
//        background.image = [UIImage imageNamed:@"CellBackground.png"];
//    }
}

@end
