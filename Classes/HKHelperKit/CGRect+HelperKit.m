//
//  CGRect+HelperKit.m
//  HelperKit
//
//  Created by Alex Wayne on 2/25/10.
//  Copyright 2010 Beautiful Pixel. All rights reserved.
//

#import "CGRect+HelperKit.h"

CGRect CGRectCenterInRect(CGRect rect, CGRect parentRect, BOOL horizontal, BOOL vertical) {
    if (horizontal) rect.origin.x = round(parentRect.size.width/2  - rect.size.width/2);
    if (vertical)   rect.origin.y = round(parentRect.size.height/2 - rect.size.height/2);
    
	return rect;
}

CGRect CGRectWithPadding(CGRect rect, CGFloat top, CGFloat right, CGFloat bottom, CGFloat left) {
    rect.origin.x    += left;
    rect.origin.y    += top;
    rect.size.width  -= (left + right);
    rect.size.height -= (top + bottom);
    
    return rect;
}

CGRect CGRectWithTranslation(CGRect rect, CGFloat x, CGFloat y) {
    rect.origin.x += x;
    rect.origin.y += y;
    
    return rect;
}