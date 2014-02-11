//
//  ThreadCell.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009. All rights reserved.
//

#import "TableCellFromNib.h"
#import "Story.h"
#import "Post.h"

@interface ThreadCell : TableCellFromNib {
	NSUInteger storyId;
	Post *rootPost;
	
	IBOutlet UILabel *author;
	IBOutlet UILabel *date;
	IBOutlet UILabel *preview;
	IBOutlet UILabel *replyCount;
	IBOutlet UILabel *lolCountsLabel;
	IBOutlet UIView  *categoryStripe;
	IBOutlet UIImageView *timerIcon;
}

@property (assign) NSUInteger storyId;
@property (strong) Post *rootPost;
@property (assign) BOOL showCount;

@end
