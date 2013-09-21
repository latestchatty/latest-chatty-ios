//
//  MessageCell.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/11/09.
//  Copyright 2009. All rights reserved.
//

#import "TableCellFromNib.h"
#import "Message.h"

@interface MessageCell : TableCellFromNib {
  Message *message;
  
  IBOutlet UILabel *fromLabel;
  IBOutlet UILabel *dateLabel;
  IBOutlet UILabel *subjectLabel;
  IBOutlet UILabel *previewLabel;
  IBOutlet UIView  *newStripe;
}

@property (strong) Message *message;
@property (nonatomic, strong) UILabel *subjectLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *previewLabel;

@end
