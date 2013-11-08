//
//  MessageCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/11/09.
//  Copyright 2009. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

@synthesize message, previewLabel, subjectLabel, dateLabel;

+ (CGFloat)cellHeight {
	return 80.0;
}

- (id)init {
    self = [super initWithNibName:@"MessageCell" bundle:nil];
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    fromLabel.text = message.from;
    dateLabel.text = [Message formatDate:message.date];
    subjectLabel.text = message.subject;
    previewLabel.text = message.preview;
    newStripe.hidden = !message.unread;
    
    // force white text color on highlight
    fromLabel.highlightedTextColor = [UIColor whiteColor];
    dateLabel.highlightedTextColor = [UIColor whiteColor];
    subjectLabel.highlightedTextColor = [UIColor whiteColor];
    
//	UIImageView *background = (UIImageView *)self.backgroundView;
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
//        background.image = [UIImage imageNamed:@"CellBackgroundDark.png"];
//    } else {
//        background.image = [UIImage imageNamed:@"CellBackground.png"];
//    }
}

@end
