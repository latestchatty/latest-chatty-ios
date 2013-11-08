//
//  StoryCell.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009. All rights reserved.
//

#import "TableCellFromNib.h"
#import "Story.h"

@interface StoryCell : TableCellFromNib {
    Story *story;

    IBOutlet UILabel *title;
    IBOutlet UILabel *preview;
    IBOutlet UILabel *timestamp;
    IBOutlet UILabel *commentCount;
    IBOutlet UIButton *__weak chattyButton;
}

@property (strong) Story *story;
@property (weak, readonly) UIButton *chattyButton;

+ (CGFloat)cellHeight;

@end
