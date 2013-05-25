//
//  ThreadCell.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ThreadCell.h"

@implementation ThreadCell

@synthesize storyId;
@synthesize rootPost;

+ (CGFloat)cellHeight {
	return 65.0;
}

- (id)init {
	self = [super initWithNibName:@"ThreadCell" bundle:nil];
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// Set text labels
	author.text       = rootPost.author;
	preview.text      = rootPost.preview;
	date.text         = [Post formatDate:rootPost.date];
	
	NSString* newPostText = nil;
	if( rootPost.newReplies ){
		newPostText = [NSString stringWithFormat:@"+%d", rootPost.newReplies];
		replyCount.text = [NSString stringWithFormat:@"%i (%@)", rootPost.replyCount, newPostText];
	} else {
        replyCount.text = [NSString stringWithFormat:@"%i", rootPost.replyCount];
    }
	
	// Set background to a light color if the user is the root poster
	UIImageView *background = (UIImageView *)self.backgroundView;
	if ([rootPost.author.lowercaseString isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"].lowercaseString]) {
		author.font = [UIFont boldSystemFontOfSize:12.0];
		background.image = [UIImage imageNamed:@"CellBackgroundLight.png"];
	} else {
		author.font = [UIFont systemFontOfSize:12.0];
		background.image = [UIImage imageNamed:@"CellBackground.png"];
	}
	
	// Set side color stripe for the post category
	categoryStripe.backgroundColor = rootPost.categoryColor;
	
	// Detect participation
    BOOL foundParticipant = NO;
	for (NSDictionary *participant in rootPost.participants) {
		NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"].lowercaseString;
        NSString *participantName = [participant objectForKey:@"username"];
        participantName = participantName.lowercaseString;
        
		if (username && ![username isEqualToString:@""] && [participantName isEqualToString:username]) {
            foundParticipant = YES;
        }
    }
    
    if (foundParticipant) {
        replyCount.textColor = [UIColor colorWithRed:116.0/255.0 green:196.0/255.0 blue:255.0/255.0 alpha:1.0];
    } else {
        replyCount.textColor = [UIColor colorWithRed:176.0/255.0 green:180.0/255.0 blue:184.0/255.0 alpha:1.0];
    }
    
    // Choose which timer icon to show based on post date and participation indication
    timerIcon.image = [Post imageForPostExpiration:rootPost.date withParticipant:foundParticipant];
	
	// Show new post icon
    //newPostsIcon.hidden = !rootPost.newPost;
}

- (BOOL)showCount {
	return !replyCount.hidden;
}

- (void)setShowCount:(BOOL)shouldShowCount {
	replyCount.hidden = !shouldShowCount;
}

- (void)dealloc {
	self.rootPost = nil;
	[super dealloc];
}

@end
