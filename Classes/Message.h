//
//  Story.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "StringAdditions.h"

@interface Message : Model {
  NSString *from;
  NSString *subject;
  NSString *body;
  NSDate   *date;
  BOOL unread;
}

@property (copy) NSString *from;
@property (copy) NSString *subject;
@property (copy) NSString *body;
@property (retain) NSDate *date;
@property (assign) BOOL unread;

+ (ModelLoader *)findAllWithDelegate:(id<ModelLoadingDelegate>)delegate;

@end
