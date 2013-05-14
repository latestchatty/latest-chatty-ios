//
//  MessageCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 4/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MessageCell.h"


@implementation MessageCell

@synthesize message, previewLabel, subjectLabel, dateLabel;

+ (CGFloat)cellHeight {
	return 85.0;
}

- (id)init {
    self = [super initWithNibName:@"MessageCell" bundle:nil];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    fromLabel.text = message.from;
    dateLabel.text = [Message formatDate:message.date];
    subjectLabel.text = message.subject;
    previewLabel.text = message.preview;
    newStripe.hidden = !message.unread;
}

- (void)dealloc {
    self.message = nil;
    self.previewLabel = nil;
    self.subjectLabel = nil;
    self.dateLabel = nil;
    [super dealloc];
}

@end
