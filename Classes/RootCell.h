//
//  RootCell.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableCellFromNib.h"


@interface RootCell : TableCellFromNib {
  IBOutlet UILabel *titleLabel;
  IBOutlet UIImageView *iconImage;
  
  NSString *title;
}

@property (copy) NSString *title;

@end
