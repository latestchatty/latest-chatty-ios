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
}

@property (copy) NSString *from;

+ (ModelLoader *)findAllWithDelegate:(id<ModelLoadingDelegate>)delegate;

@end
