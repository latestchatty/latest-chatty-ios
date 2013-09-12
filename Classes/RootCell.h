//
//  RootCell.h
//  LatestChatty2
//
//  Created by Alex Wayne on 4/10/09.
//  Copyright 2009. All rights reserved.
//

#import "TableCellFromNib.h"
#import "CustomBadge.h"

@interface RootCell : TableCellFromNib {
    IBOutlet UILabel *titleLabel;
    IBOutlet UIImageView *iconImage;

    NSString *title;
    CustomBadge *badge;
}

@property (copy) NSString *title;
@property (retain, nonatomic) CustomBadge *badge;
@property (retain, nonatomic) IBOutlet UIImageView *iconImage;

- (void)setBadgeWithNumber:(int)badgeNumber;

@end
