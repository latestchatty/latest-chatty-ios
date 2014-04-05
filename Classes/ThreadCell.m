//
//  ThreadCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009. All rights reserved.
//

#import "ThreadCell.h"

@implementation ThreadCell

@synthesize storyId;
@synthesize rootPost;

- (id)init {
	self = [super initWithNibName:@"ThreadCell" bundle:nil];
    
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	// Set text labels
	author.text = rootPost.author;
	preview.text = rootPost.preview;
    date.text = [Post formatDate:rootPost.date];
    
    // force white text color on highlight
    author.highlightedTextColor = [UIColor whiteColor];
    date.highlightedTextColor = [UIColor whiteColor];
    replyCount.highlightedTextColor = [UIColor whiteColor];
    lolCountsLabel.highlightedTextColor = [UIColor whiteColor];
	
	NSString* newPostText = nil;
	if (rootPost.newReplies) {
		newPostText = [NSString stringWithFormat:@"+%ld", (long)rootPost.newReplies];
		replyCount.text = [NSString stringWithFormat:@"%lu (%@)", (unsigned long)rootPost.replyCount, newPostText];
	} else {
        replyCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)rootPost.replyCount];
    }
    
	// Set background to a light color if the user is the root poster
	if ([rootPost.author.lowercaseString isEqualToString:[defaults stringForKey:@"username"].lowercaseString]) {
        self.backgroundColor = [UIColor lcCellParticipantColor];
	} else {
        self.backgroundColor = [UIColor lcCellNormalColor];
	}
    
    if (rootPost.pinned) {
        self.backgroundColor = [UIColor lcCellPinnedColor];
    }
	
	// Set side color stripe for the post category
	categoryStripe.backgroundColor = rootPost.categoryColor;
	
	// Detect participation
    BOOL foundParticipant = NO;
	for (NSDictionary *participant in rootPost.participants) {
		NSString *username = [defaults stringForKey:@"username"].lowercaseString;
        NSString *participantName = [participant objectForKey:@"username"];
        participantName = participantName.lowercaseString;
        
		if (username && ![username isEqualToString:@""] && [participantName isEqualToString:username]) {
            foundParticipant = YES;
        }
    }
    
    if (foundParticipant) {
        replyCount.textColor = [UIColor lcBlueParticipantColor];
    } else {
        replyCount.textColor = [UIColor lcLightGrayTextColor];
    }
    
    // Choose which timer icon to show based on post date and participation indication
    timerIcon.image = [Post imageForPostExpiration:rootPost.date withParticipant:foundParticipant];
    
    // If lol tags are enabled and lolCounts came in when constructing this cell, parse the counts to make an attributed string
    NSMutableAttributedString *tags;
    if ([defaults boolForKey:@"lolTags"] && rootPost.lolCounts) {
        tags = [Tag buildThreadCellTag:rootPost.lolCounts];
    }
    
    // if the tags string was allocated and appended to...
    if (tags != nil && tags.length > 0) {
        // set the final attributed string to the label
        lolCountsLabel.attributedText = tags;
        // iPhone: modify the preview label's frame size depending on whether tags are visible
        // iPad: modify the preview label frame origin depending on whether tags are visible        
        if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
            preview.frameHeight = 42.0f;
        } else {
            preview.frameHeight = 54.0f;
        }
    } else {
        lolCountsLabel.attributedText = nil;
        if (![[LatestChatty2AppDelegate delegate] isPadDevice]) {
            preview.frameHeight = 54.0f;
        } else {
            preview.frameHeight = 68.0f;
        }
    }
}

- (BOOL)showCount {
	return !replyCount.hidden;
}

- (void)setShowCount:(BOOL)shouldShowCount {
	replyCount.hidden = !shouldShowCount;
}

@end
