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

- (id)init {
  self = [super initWithNibName:@"MessageCell" bundle:nil];
  return self;
}

- (void)layoutSubviews {
  fromLabel.text = message.from;
  dateLabel.text = [Message formatDate:message.date];
  subjectLabel.text = message.subject;
  previewLabel.text = message.preview;
  newStripe.hidden = !message.unread;
}

- (void)dealloc {
  self.message = nil;
  [super dealloc];
}


@end
