//
//  Tag.h
//  LatestChatty2
//
//  Created by Alex Wayne on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  TagTypeLOL,
  TagTypeINF,
  TagTypeMark,
} TagType;

@interface Tag : NSObject {
  
}

+ (void)tagPostId:(NSUInteger)postId tag:(TagType)tagType;

@end
