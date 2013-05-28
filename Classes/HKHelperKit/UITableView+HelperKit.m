//
//  UITableViewController+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 3/9/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "UITableView+HelperKit.h"


@implementation UITableView (HelperKit)

- (UITableViewCell*)selectedCell {
    return [self cellForRowAtIndexPath:[self indexPathForSelectedRow]];
}

@end
