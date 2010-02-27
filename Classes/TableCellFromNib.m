//
//  TableCellFromNib.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TableCellFromNib.h"


@implementation TableCellFromNib


+ (CGFloat)cellHeight {
    return 44.0;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundleOrNil {
    UIViewController *cellFactory = [[[UIViewController alloc] initWithNibName:nibName bundle:nibBundleOrNil] autorelease];
    self = (TableCellFromNib *)cellFactory.view;
    [self retain];

    return self;
}

@end
