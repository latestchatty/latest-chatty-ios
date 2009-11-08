//
//  UIView+Additions.m
//  LatestChatty2
//
//  Created by Jeffrey Forbes on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIView+Additions.h"


@implementation UIView(UIViewAdditions)


-(CGRect)centerInView:(UIView*)view
{
	CGRect viewFrame = view.frame;
	CGRect selfFrame = self.frame;
	
	CGRect retVal = self.frame;
	retVal.origin.x = (int)(viewFrame.size.width/2 - selfFrame.size.width/2);
	retVal.origin.y = (int)(viewFrame.size.height/2 - selfFrame.size.height/2);
	self.frame = retVal;
	return retVal;
}

-(CGRect)centerOnYAxisInView:(UIView*)view
{
	CGRect viewFrame = view.frame;
	CGRect selfFrame = self.frame;
	
	CGRect retVal = self.frame;
	retVal.origin.y = (int)(viewFrame.size.height/2 - selfFrame.size.height/2);
	self.frame = retVal;
	return retVal;
}

-(CGRect)centerOnXAxisInView:(UIView*)view
{
	CGRect viewFrame = view.frame;
	CGRect selfFrame = self.frame;
	
	CGRect retVal = self.frame;
	retVal.origin.x = (int)(viewFrame.size.width/2 - selfFrame.size.width/2);
	self.frame = retVal;
	return retVal;
}


@end
