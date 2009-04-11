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
  IBOutlet UILabel *bodyLabel;
  IBOutlet UIView  *newStripe;
}

@property (retain) Message *message;

@end
