//
//  Story.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface Story : Model {
  NSString *title;
  NSUInteger commentCount;
}

@property (copy) NSString *title;
@property (readonly) NSUInteger commentCount;

@end
