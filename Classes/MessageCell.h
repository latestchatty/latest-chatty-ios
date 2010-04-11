//
//  MessageCell.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
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

@property (retain) Message *message;
@property (nonatomic, retain) UILabel *subjectLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *previewLabel;

@end
