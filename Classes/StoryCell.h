//
//  StoryCell.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableCellFromNib.h"
#import "Story.h"

@interface StoryCell : TableCellFromNib {
  Story *story;
  
  IBOutlet UILabel *title;
  IBOutlet UILabel *modelId;
  IBOutlet UILabel *commentCount;
}

@property (retain) Story *story;

+ (CGFloat)cellHeight;

@end
