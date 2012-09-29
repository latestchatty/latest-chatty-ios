//
//    ReplyCell.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/24/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ReplyCell.h"

#define INDENDATION 15.0

@implementation ReplyCell

@synthesize post, isThreadStarter;

+ (CGFloat)cellHeight {
    return 24.0;
}

- (id)init {
    self = [super initWithNibName:@"ReplyCell" bundle:nil];
    self.isThreadStarter = NO;
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Set the cell text
    preview.text = post.preview;
    
    // Set the username
    usernameLabel.text = post.author;
    
    if (isThreadStarter) {
        usernameLabel.font = [UIFont boldSystemFontOfSize:usernameLabel.font.pointSize];
    } else {
        usernameLabel.font = [UIFont systemFontOfSize:usernameLabel.font.pointSize];
    }
    
    // Set the indentation depth
    CGFloat indentation = 3 + post.depth * self.indentationWidth;
    CGFloat previewWidth = self.frame.size.width - indentation;
    if (usernameLabel) previewWidth -= (usernameLabel.frame.size.width + 20);
    
    preview.frame = CGRectMake(indentation, 0, previewWidth, self.frame.size.height);
    
    // Choose a text color based on time level of the post
    if (post.timeLevel >= 4) {
        grayBullet.alpha = 0.2;
    } else {
        grayBullet.alpha = 1.0 - (0.2 * post.timeLevel);
    }
    
    // Set latest to bold
    if (post.timeLevel == 0) {
        preview.font = [UIFont boldSystemFontOfSize:14];
    } else {
        preview.font = [UIFont systemFontOfSize:14];
    }
    
    // Only show blue bullet if this is my post.
    CGRect bulletFrame = CGRectMake(indentation - 12, 0, 10, self.frame.size.height);
    blueBullet.frame = bulletFrame;
    grayBullet.frame = bulletFrame;
    if ([post.author.lowercaseString isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"].lowercaseString]) {
        blueBullet.hidden = (post.depth == 0);
        grayBullet.hidden = YES;
    } else {
        blueBullet.hidden = YES;
        grayBullet.hidden = (post.depth == 0);
    }
    
    // Set category stripe
    categoryStripe.backgroundColor = [post categoryColor];
    categoryStripe.frame = CGRectMake(indentation - 3, categoryStripe.frame.origin.y,
                                      categoryStripe.frame.size.width, categoryStripe.frame.size.height);
}

- (void)dealloc {
    self.post = nil;
    [super dealloc];
}


@end
