//
//    ReplyCell.m
//    LatestChatty2
//
//    Created by Alex Wayne on 3/24/09.
//    Copyright 2009. All rights reserved.
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
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Set the highlight text color to white
    preview.highlightedTextColor = [UIColor whiteColor];
    usernameLabel.highlightedTextColor = [UIColor whiteColor];
    
    // Set the cell text
    preview.text = post.preview;
    
    // Set the username
    usernameLabel.text = post.author;
    if (isThreadStarter) {
        usernameLabel.font = [UIFont boldSystemFontOfSize:usernameLabel.font.pointSize];
        usernameLabel.textColor = [UIColor yellowColor];
    } else {
        usernameLabel.font = [UIFont systemFontOfSize:usernameLabel.font.pointSize];
        usernameLabel.textColor = [UIColor lcAuthorColor];
    }
    
    // Set the indentation depth
    CGFloat indentation = 3 + post.depth * self.indentationWidth;
    CGFloat previewWidth = self.frame.size.width - indentation;
    if (usernameLabel) previewWidth -= (usernameLabel.frame.size.width + 20);
    preview.frame = CGRectMake(indentation, 0, previewWidth, self.frame.size.height);
    grayBullet.frame = CGRectMake(indentation - 12, 1, 10, self.frame.size.height);
    
    // Set preview text label color by reply order
    // Top 5 most recent posts increase in white level until fully white with the most recent reply
    // Modify alpha of non-participant bullet to match the preview text color
    switch (post.timeLevel) {
        case 0:
            grayBullet.alpha = 1.0;
            // Set latest to bold
            preview.font = [UIFont boldSystemFontOfSize:preview.font.pointSize];
            preview.textColor = [UIColor whiteColor];
            break;
        case 1:
            grayBullet.alpha = 1.0 - (0.15 * post.timeLevel);
            preview.font = [UIFont systemFontOfSize:preview.font.pointSize];
            preview.textColor = [UIColor lcReplyLevel1Color];
            break;
        case 2:
            grayBullet.alpha = 1.0 - (0.15 * post.timeLevel);
            preview.font = [UIFont systemFontOfSize:preview.font.pointSize];
            preview.textColor = [UIColor lcReplyLevel2Color];
            break;
        case 3:
            grayBullet.alpha = 1.0 - (0.15 * post.timeLevel);
            preview.font = [UIFont systemFontOfSize:preview.font.pointSize];
            preview.textColor = [UIColor lcReplyLevel3Color];
            break;
        case 4:
            grayBullet.alpha = 1.0 - (0.15 * post.timeLevel);
            preview.font = [UIFont systemFontOfSize:preview.font.pointSize];
            preview.textColor = [UIColor lcReplyLevel4Color];
            break;            
        default:
            grayBullet.alpha = 0.25;
            preview.font = [UIFont systemFontOfSize:preview.font.pointSize];
            preview.textColor = [UIColor lcReplyLevel5Color];
            break;
    }
    
    // Color the preview and author labels blue if this is my post
    if ([post.author.lowercaseString isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"].lowercaseString]) {
        usernameLabel.textColor = [UIColor lcBlueParticipantColor];
        preview.textColor = [UIColor lcBlueParticipantColor];
    }
    
    // Set category stripe
    self.backgroundColor = [post categoryColor];
    categoryStripe.hidden = YES;
//    categoryStripe.backgroundColor = [post categoryColor];
//    categoryStripe.frame = CGRectMake(indentation - 3, categoryStripe.frame.origin.y,
//                                      categoryStripe.frame.size.width, categoryStripe.frame.size.height);
    
    // If lol tags are enabled and lolCounts came in when constructing this cell, parse the counts to make an attributed string
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"lolTags"] && post.lolCounts) {
        NSUInteger highestTagCount = 0;
        NSString *highestTag;
        for (NSString *key in post.lolCounts) {
            NSString *value = [post.lolCounts valueForKey:key];
            if (highestTagCount < [value integerValue]) {
                highestTagCount = [value integerValue];
                highestTag = [[NSString alloc] initWithString:key];
            }
        }
        
        if ([highestTag isEqualToString:@"lol"]) {
            grayBullet.image = [UIImage imageNamed:@"Post-Indicator-LOL"];
            grayBullet.alpha = 0.75;
        } else if ([highestTag isEqualToString:@"inf"]) {
            grayBullet.image = [UIImage imageNamed:@"Post-Indicator-INF"];
            grayBullet.alpha = 0.75;
        } else if ([highestTag isEqualToString:@"unf"]) {
            grayBullet.image = [UIImage imageNamed:@"Post-Indicator-UNF"];
            grayBullet.alpha = 0.75;
        } else if ([highestTag isEqualToString:@"tag"]) {
            grayBullet.image = [UIImage imageNamed:@"Post-Indicator-TAG"];
            grayBullet.alpha = 0.75;
        } else if ([highestTag isEqualToString:@"wtf"]) {
            grayBullet.image = [UIImage imageNamed:@"Post-Indicator-WTF"];
            grayBullet.alpha = 0.75;
        } else if ([highestTag isEqualToString:@"ugh"]) {
            grayBullet.image = [UIImage imageNamed:@"Post-Indicator-UGH"];
            grayBullet.alpha = 0.75;
        } else {
            grayBullet.image = [UIImage imageNamed:@"Post-Indicator"];
        }
    } else {
        grayBullet.image = [UIImage imageNamed:@"Post-Indicator"];
    }
    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
//        self.backgroundColor = [UIColor lcRepliesTableBackgroundDarkColor];
//    } else {
//        self.backgroundColor = [UIColor lcRepliesTableBackgroundColor];
//    }
}

@end
