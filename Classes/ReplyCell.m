//
//    ReplyCell.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/24/09.
//    Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ReplyCell.h"

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
    
    // Set the highlight text color to white
    preview.highlightedTextColor = [UIColor whiteColor];
    
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
    
//    // Choose a text color based on time level of the post
//    if (post.timeLevel >= 4) {
//        grayBullet.alpha = 0.2;
//    } else {
//        grayBullet.alpha = 1.0 - (0.2 * post.timeLevel);
//    }
    
    /* RGB values
     0  255,255,255
     1  218,225,229
     2  194,200,204
     3  183,187,189
     4  157,163,166
     >5 150,155,158
     */
    
    // Set preview text label color by reply order
    // Top 5 most recent posts increase in white level until fully white with the most recent reply
    // Modify alpha of non-participant bullet to match the preview text color
    switch (post.timeLevel) {
        case 0:
            grayBullet.alpha = 1.0 - (0.2 * post.timeLevel);
            // Set latest to bold
            preview.font = [UIFont boldSystemFontOfSize:14];
            preview.textColor = [UIColor whiteColor];
            break;
        case 1:
            grayBullet.alpha = 1.0 - (0.2 * post.timeLevel);
            preview.font = [UIFont systemFontOfSize:14];
            preview.textColor = [UIColor lcReplyLevel1Color];
            break;
        case 2:
            grayBullet.alpha = 1.0 - (0.2 * post.timeLevel);
            preview.font = [UIFont systemFontOfSize:14];
            preview.textColor = [UIColor lcReplyLevel2Color];
            break;
        case 3:
            grayBullet.alpha = 1.0 - (0.2 * post.timeLevel);
            preview.font = [UIFont systemFontOfSize:14];
            preview.textColor = [UIColor lcReplyLevel3Color];
            break;
        case 4:
            grayBullet.alpha = 1.0 - (0.2 * post.timeLevel);
            preview.font = [UIFont systemFontOfSize:14];
            preview.textColor = [UIColor lcReplyLevel4Color];
            break;            
        default:
            grayBullet.alpha = 0.4;
            preview.font = [UIFont systemFontOfSize:14];
            preview.textColor = [UIColor lcReplyLevel5Color];
            break;
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
