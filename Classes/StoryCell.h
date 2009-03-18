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
  IBOutlet UILabel *preview;
  IBOutlet UILabel *timestamp;
  IBOutlet UILabel *commentCount;
  IBOutlet UIButton *chattyButton;
}

@property (retain) Story *story;
@property (readonly) UIButton *chattyButton;

+ (CGFloat)cellHeight;

@end
