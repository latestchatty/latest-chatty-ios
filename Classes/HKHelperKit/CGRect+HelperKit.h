//
//  CGRect+HelperKit.h
//  HelperKit
//
//  Created by Alex Wayne on 2/25/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

// Returns a new CGRect set to be centered in the parent rect
CGRect CGRectCenterInRect(CGRect rect, CGRect parentRect, BOOL horizontal, BOOL vertical);

// Returns a new CGRect inset along each edge by the specified amounts
CGRect CGRectWithPadding(CGRect rect, CGFloat top, CGFloat right, CGFloat bottom, CGFloat left);

// Returns a new CGRect translated along X and Y
CGRect CGRectWithTranslation(CGRect rect, CGFloat x, CGFloat y);