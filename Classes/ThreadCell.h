//
//  ThreadCell.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableCellFromNib.h"
#import "Story.h"
#import "Post.h"

@interface ThreadCell : TableCellFromNib {
  NSUInteger storyId;
  Post  *rootPost;
  
  IBOutlet UILabel *author;
  IBOutlet UILabel *date;
  IBOutlet UILabel *preview;
  IBOutlet UILabel *replyCount;
  IBOutlet UIView  *categoryStripe;
}

@property (assign) NSUInteger storyId;
@property (retain) Post *rootPost;

@end
