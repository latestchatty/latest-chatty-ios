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
        tags = [[NSMutableAttributedString alloc] init];
        for (NSString *key in rootPost.lolCounts) {
            NSDictionary *attributes;
            BOOL customTag = NO;
            NSString *value = [rootPost.lolCounts valueForKey:key];
            
            // make an attributes dictionary to hold the appropriate background color for the tag
            if ([key isEqualToString:@"lol"]) {
                attributes = @{NSBackgroundColorAttributeName:[UIColor lcLOLColor]};
            } else if ([key isEqualToString:@"inf"]) {
                attributes = @{NSBackgroundColorAttributeName:[UIColor lcINFColor]};
            } else if ([key isEqualToString:@"unf"]) {
                attributes = @{NSBackgroundColorAttributeName:[UIColor lcUNFColor]};
            } else if ([key isEqualToString:@"tag"]) {
                attributes = @{NSBackgroundColorAttributeName:[UIColor lcTAGColor]};
            } else if ([key isEqualToString:@"wtf"]) {
                attributes = @{NSBackgroundColorAttributeName:[UIColor lcWTFColor]};
            } else if ([key isEqualToString:@"ugh"]) {
                attributes = @{NSBackgroundColorAttributeName:[UIColor lcUGHColor]};
            } else {
                attributes = nil;
                customTag = YES;
            }
            
            // ignore custom tags (ie. not the standard tags above) that may come from lol counts data
            if (!customTag) {
                // append this tag to the attributed string
                NSAttributedString *attribTag = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ %@ ", key, value] attributes:attributes];
                [tags appendAttributedString:attribTag];
                [tags appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            }
        }
    }
    
    // if the tags string was allocated and appended to...
    if (tags != nil && tags.length > 0) {
        // set the final attributed string to the label
        lolCountsLabel.attributedText = tags;
        // push the preview label's frame up/down depending on whether tags are visible
        preview.frameY = 20.0f;
    } else {
        lolCountsLabel.attributedText = nil;
        preview.frameY = 27.0f;
    }
}

- (BOOL)showCount {
	return !replyCount.hidden;
}

- (void)setShowCount:(BOOL)shouldShowCount {
	replyCount.hidden = !shouldShowCount;
}

@end
